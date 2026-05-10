const { Snowflake } = require('nodejs-snowflake');
const jsonWebToken = require('jsonwebtoken');
const config = require('../../config');
const prisma = require('./prisma');
const uid = new Snowflake({
    custom_epoch: 19112021000,
    instance_id: undefined
});

module.exports = {
    createSnowflakeId: function () {
        return uid.idFromTimestamp(Date.now()).toString()
    },
    checkAuth: async function (req, res, next) {
        const authHeader = req.headers['authorization'] || req.headers['Authorization'];
        const token = authHeader?.split(' ')[1] || req.query.token || req.body.token || req.cookies?.auth_token;
        if (!token) {
            return res.status(401).json({ code: 401, msg: 'Unauthorized' });
        }
        try {
            const findBotToken = await prisma.users.findFirst({
                where: { bot_token: token }
            });
            if (findBotToken) {
                req.user = findBotToken;
                return next();
            } else {
                const decoded = jsonWebToken.verify(token, config.JWT_SECRET);
                const findUser = await prisma.users.findUnique({ where: { id: decoded.id } });
                if (!findUser) {
                    return res.status(401).json({ code: 401, msg: 'Unauthorized' });
                }
                req.user = findUser;
                return next();
            }
        }
        catch (err) {
            return res.status(401).json({ code: 401, msg: 'Unauthorized' });
        }
    },
    checkCompanyOwner: async function (req, res, next) {
        const findCompany = await prisma.companies.findUnique({
            where: { id: req.params.company_id }
        });
        if (!findCompany) {
            return res.status(404).json({ code: 404, msg: 'Company not found' });
        }
        if ((findCompany.owned_by !== req.user.id) && !req.user.flags?.includes('ADMIN')) {
            return res.status(403).json({ code: 403, msg: 'Forbidden' });
        }
        req.company = findCompany;
        return next();
    },
    checkPlaceOwner: async function (req, res, next) {
        const findPlace = await prisma.places.findUnique({
            where: { id: req.params.place_id }
        });
        if (!findPlace) {
            return res.status(404).json({ code: 404, msg: 'Place not found' });
        }
        if ((findPlace.user_id === req.user.id) || req.user.flags?.includes('ADMIN')) {
            return next();
        }
        const findCompany = await prisma.companies.findUnique({
            where: { id: findPlace.company_id }
        });
        if (!findCompany || findCompany.owned_by !== req.user.id) {
            return res.status(403).json({ code: 403, msg: 'Forbidden' });
        }
        return next();
    },
    checkProductOwner: async function (req, res, next) {
        const findProduct = await prisma.products.findUnique({
            where: { id: req.params.product_id }
        });
        if (!findProduct) {
            return res.status(404).json({ code: 404, msg: 'Product not found' });
        }
        const findPlace = await prisma.places.findUnique({
            where: { id: findProduct.place_id }
        });
        if (!findPlace) {
            return res.status(404).json({ code: 404, msg: 'Place not found' });
        }
        if ((findPlace.user_id === req.user.id) || req.user.flags?.includes('ADMIN')) {
            return next();
        }
        const findCompany = await prisma.companies.findUnique({
            where: { id: findPlace.company_id }
        });
        if (!findCompany || findCompany.owned_by !== req.user.id) {
            return res.status(403).json({ code: 403, msg: 'Forbidden' });
        }
        return next();
    },
    checkIsAdmin: async function (req, res, next) {
        if (!req.user.flags?.includes('ADMIN')) {
            return res.status(403).json({ code: 403, msg: 'Forbidden: Admins only' });
        }
        return next();
    }
}
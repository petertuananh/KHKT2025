const express = require('express');
const router = express.Router();
const prisma = require('../utils/prisma');
const utils = require('../utils');

router.get('/', async (req, res) => {
    try {
        const places = await prisma.places.findMany({
            include: {
                user: true,
                company: true,
                products: true
            }
        });
        return res.json({ code: 200, msg: 'Ok', data: places });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

router.get('/:place_id', async (req, res) => {
    const placeId = req.params.place_id;
    try {
        const place = await prisma.places.findUnique({
            where: {
                id: placeId
            },
            include: {
                user: true,
                company: true,
                products: true
            }
        });
        if (!place) {
            return res.status(404).json({ code: 404, msg: 'Place not found' });
        }
        return res.json({ code: 200, msg: 'Ok', data: place });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

router.put('/', utils.checkAuth, async (req, res) => {
    const { name, description, address, latitude, longitude, company_id } = req.body;
    if (!name) {
        return res.status(400).json({ code: 400, msg: 'Missing required fields' });
    }

    if (company_id) {
        const company = await prisma.companies.findUnique({
            where: { id: company_id }
        });
        if (!company) {
            return res.status(400).json({ code: 400, msg: 'Invalid company_id' });
        }
        if ((company.owned_by !== req.user.id) && (!req.user.flags?.includes("ADMIN"))) {
            return res.status(403).json({ code: 403, msg: 'Forbidden: You do not own this company' });
        }
    }
    try {
        const newPlace = await prisma.places.create({
            data: {
                id: utils.createSnowflakeId(),
                name,
                description,
                address,
                latitude: req.body.latitude || null,
                longitude: req.body.longitude || null,
                user_id: company_id ? null : req.user.id,
                company_id: company_id || null,
                creator_id: req.user.id
            }
        });
        return res.status(200).json({ code: 200, msg: 'Place created', data: newPlace });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

router.patch('/:place_id', utils.checkAuth, utils.checkPlaceOwner, async (req, res) => {
    const placeId = req.params.place_id;
    const { name, description, address, latitude, longitude } = req.body;

    try {
        const place = await prisma.places.findUnique({
            where: {
                id: placeId
            }
        });
        const updatedPlace = await prisma.places.update({
            where: { id: placeId },
            data: {
                name: name || place.name,
                description: description || place.description,
                address: address || place.address,
                latitude: parseFloat(latitude) || place.latitude,
                longitude: parseFloat(longitude) || place.longitude
            }
        });
        return res.json({ code: 200, msg: 'Place updated', data: updatedPlace });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});


router.delete('/:place_id', utils.checkAuth, utils.checkPlaceOwner, async (req, res) => {
    const placeId = req.params.place_id;
    try {
        await prisma.places.delete({
            where: { id: placeId }
        });
        return res.json({ code: 200, msg: 'Place deleted' });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

router.patch('/:place_id', utils.checkAuth, utils.checkPlaceOwner, async (req, res) => {
    const placeId = req.params.place_id;
    const { name, description, address, latitude, longitude } = req.body;
    try {

        const updatedPlace = await prisma.places.update({
            where: { id: placeId },
            data: {
                name: name || place.name,
                description: description || place.description,
                address: address || place.address,
                latitude: latitude !== undefined ? latitude : place.latitude,
                longitude: longitude !== undefined ? longitude : place.longitude
            }
        });
        return res.json({ code: 200, msg: 'Place updated', data: updatedPlace });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

router.put('/:place_id/products', utils.checkAuth, utils.checkPlaceOwner, async (req, res) => {
    const { name, description, price, stock, unit_type } = req.body;
    if (!name || !description || !price || !stock || !unit_type) {
        return res.status(400).json({ code: 400, msg: 'Missing required fields' });
    }

    try {
        const newProduct = await prisma.products.create({
            data: {
                id: utils.createSnowflakeId(),
                name,
                description,
                price: parseFloat(price),
                stock: parseInt(stock),
                unit_type,
                place_id: req.params.place_id
            }
        });
        return res.json({ code: 200, msg: 'Product created', data: newProduct });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

module.exports = router;
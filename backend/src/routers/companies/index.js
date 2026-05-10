const express = require('express');
const router = express.Router();
const prisma = require('../../utils/prisma');
const utils = require('../../utils');


router.get('/', async (req, res) => {
    const selectCompanyAll = await prisma.companies.findMany({
        include: {
            places: true,
            deliveries: true,
            recruitments: true,
            scrapes: true
        }
    });
    return res.json({ code: 200, msg: 'Ok', data: selectCompanyAll });
});


router.get('/search', async (req, res) => {
    const searchType = req.query.type;
    const searchQuery = req.query.q || req.query.query || req.query.search || req.query.keyword || '';
    let result;
    if (searchType === 'all' || !searchType) {
        result = await prisma.companies.findMany({
            where: {
                name: { contains: searchQuery, mode: 'insensitive' },
            }
        });
    } else if (searchType === 'recruitments') {
        result = await prisma.companyRecruitments.findMany({
            where: {
                title: { contains: searchQuery, mode: 'insensitive' }
            },
            include: {
                company: true
            }
        });
    } else if (searchType === 'deliveries') {
        result = await prisma.companyDeliveries.findMany({
            where: {
                title: { contains: searchQuery, mode: 'insensitive' }
            },
            include: {
                company: true
            }
        });
    } else if (searchType === 'scrapes') {
        result = await prisma.companyScrapes.findMany({
            where: {
                name: { contains: searchQuery, mode: 'insensitive' }
            },
            include: {
                company: true
            }
        });
    } else {
        return res.status(400).json({
            code: 400, msg: 'Invalid search type'
        });
    }
    return res.json({ code: 200, msg: 'Ok', data: result });
});

router.get('/:company_id', async (req, res) => {
    const company_id = req.params.company_id;
    const findCompanyFull = await prisma.companies.findUnique({
        where: { id: company_id },
        include: {
            owner: {
                omit: {
                    hashed_password: true,
                    bot_token: true
                }
            },
            places: true,
            deliveries: true,
            recruitments: true,
            scrapes: true
        }
    });
    return res.json({
        code: 200, msg: 'Ok', data: findCompanyFull
    });
});

router.put('/', utils.checkAuth, async (req, res) => {
    const { name, international_name, short_name, tax_id, description, address, phone, email, website } = req.body;
    if (!name) {
        return res.status(400).json({ code: 400, msg: 'Name is required' });
    }
    const newCompany = await prisma.companies.create({
        data: {
            id: utils.createSnowflakeId(),
            name,
            international_name: international_name || null,
            short_name: short_name || null,
            tax_id: tax_id || null,
            description: description || null,
            address: address || null,
            phone: phone || null,
            email: email || null,
            website: website || null,
            owned_by: req.user.id,
        }
    });
    return res.json({ code: 201, msg: 'Company created', data: newCompany });
});

router.delete('/:company_id', utils.checkAuth, utils.checkCompanyOwner, async (req, res) => {
    const company_id = req.params.company_id;
    if (!company_id) {
        return res.status(400).json({ code: 400, msg: 'company_id is required' });
    }
    await prisma.companies.update({
        where: { id: company_id },
        data: {
            is_active: false,
            is_deleted: true
        }
    });
    return res.json({ code: 200, msg: 'Company deleted' });
});

router.patch('/:company_id', utils.checkAuth, utils.checkCompanyOwner, async (req, res) => {
    const allowed_fields = ['name', 'international_name', 'short_name', 'tax_id', 'description', 'address', 'phone', 'email', 'website', 'lat', 'lng'];
    const updateData = {};
    for (const field of allowed_fields) {
        if (req.body[field] !== undefined) {

            // Kiểm tra tên field
            if (field === 'lat' || field === 'lng') {
                updateData[field] = parseFloat(req.body[field]);
            } else {
                updateData[field] = req.body[field];
            }
        }
    }

    const updatedCompany = await prisma.companies.update({
        where: { id: req.params.company_id },
        data: updateData
    });
    return res.json({ code: 200, msg: 'Company updated', data: updatedCompany });
});

router.get('/:company_id/transactions', utils.checkAuth, utils.checkCompanyOwner, async (req, res) => {
    const getCompanyTransactions = await prisma.company_transactions.findMany({
        where: {
            company_id: req.params.company_id
        },
        include: {
            from_user: true,
            order: true
        }
    });
    return res.json({code: 200, msg: 'Ok', data: getCompanyTransactions});
});

router.get('/:company_id/:type', utils.checkAuth, async (req, res) => {
    const type = req.params.type;
    const company_id = req.params.company_id;
    if (type == 'recruitments') {
        const recruitments = await prisma.companyRecruitments.findMany({
            where: { company_id }
        });
        return res.json({ code: 200, msg: 'Ok', data: recruitments });
    } else if (type == 'deliveries') {
        const deliveries = await prisma.companyDeliveries.findMany({
            where: { company_id }
        });
        return res.json({ code: 200, msg: 'Ok', data: deliveries });
    } else if (type == 'scrapes') {
        const scrapes = await prisma.companyScrapes.findMany({
            where: { company_id }
        });
        return res.json({ code: 200, msg: 'Ok', data: scrapes });
    } else {
        return res.status(400).json({ code: 400, msg: 'Invalid type' });
    }
});

// router.post('/:company_id/recruitments', utils.checkAuth, async (req, res) => {
//     const company_id = req.params.company_id;
//     const { title, description, requirements, location, salary_range_from, salary_range_to, employment_type } = req.body;

// });

router.post('/:company_id/recruitments', utils.checkAuth, utils.checkCompanyOwner, async (req, res) => {
    const company_id = req.params.company_id;
    const {
        title,
        description,
        requirements,
        location,
        salary_range_from,
        salary_range_to,
        employment_type
    } = req.body;

    if (!title || !description || !requirements) {
        return res.status(400).json({ code: 400, msg: 'Missing required fields' });
    }

    const recruitment = await prisma.companyRecruitments.create({
        data: {
            id: utils.createSnowflakeId(),
            title,
            description,
            requirements,
            location: location || null,
            salary_range_from: salary_range_from || null,
            salary_range_to: salary_range_to || null,
            employment_type: employment_type || null,
            company_id,
            created_by: req.user.id
        }
    });

    return res.json({ code: 201, msg: 'Recruitment created', data: recruitment });
});

router.patch('/:company_id/recruitments/:id', utils.checkAuth, async (req, res) => {
    const allowed = [
        'title',
        'description',
        'requirements',
        'location',
        'salary_range_from',
        'salary_range_to',
        'employment_type'
    ];

    const updateData = {};
    for (const f of allowed) {
        if (req.body[f] !== undefined) {
            updateData[f] = req.body[f];
        }
    }

    const updated = await prisma.companyRecruitments.update({
        where: { id: req.params.id },
        data: updateData
    });

    return res.json({ code: 200, msg: 'Recruitment updated', data: updated });
});

router.delete('/:company_id/recruitments/:id', utils.checkAuth, async (req, res) => {
    await prisma.companyRecruitments.delete({
        where: { id: req.params.id }
    });

    return res.json({ code: 200, msg: 'Recruitment deleted' });
});

router.post('/:company_id/deliveries', utils.checkAuth, utils.checkCompanyOwner, async (req, res) => {
    const company_id = req.params.company_id;
    const { title, weight, length, width, height, budget } = req.body;

    if (!title || weight == null || length == null || width == null || height == null || budget == null) {
        return res.status(400).json({ code: 400, msg: 'Missing required fields' });
    }

    const delivery = await prisma.companyDeliveries.create({
        data: {
            id: utils.createSnowflakeId(),
            title,
            weight: parseFloat(weight),
            length: parseFloat(length),
            width: parseFloat(width),
            height: parseFloat(height),
            budget: parseFloat(budget),
            company_id,
            created_by: req.user.id
        }
    });

    return res.json({ code: 201, msg: 'Delivery created', data: delivery });
});

router.patch('/:company_id/deliveries/:id', utils.checkAuth, async (req, res) => {
    const allowed = ['title', 'weight', 'length', 'width', 'height', 'budget'];
    const updateData = {};

    for (const f of allowed) {
        if (req.body[f] !== undefined) {
            updateData[f] = parseFloat(req.body[f]);
        }
    }

    const updated = await prisma.companyDeliveries.update({
        where: { id: req.params.id },
        data: updateData
    });

    return res.json({ code: 200, msg: 'Delivery updated', data: updated });
});

router.delete('/:company_id/deliveries/:id', utils.checkAuth, async (req, res) => {
    await prisma.companyDeliveries.delete({
        where: { id: req.params.id }
    });

    return res.json({ code: 200, msg: 'Delivery deleted' });
});

router.post('/:company_id/scrapes', utils.checkAuth, utils.checkCompanyOwner, async (req, res) => {
    const company_id = req.params.company_id;
    const { name, quantity, unit_type, unit_price } = req.body;

    if (!name || quantity == null || !unit_type || unit_price == null) {
        return res.status(400).json({ code: 400, msg: 'Missing required fields' });
    }

    const scrape = await prisma.companyScrapes.create({
        data: {
            id: utils.createSnowflakeId(),
            name,
            quantity: parseInt(quantity),
            unit_type,
            unit_price: parseFloat(unit_price),
            company_id,
            created_by: req.user.id
        }
    });

    return res.json({ code: 201, msg: 'Scrape created', data: scrape });
});

router.patch('/:company_id/scrapes/:id', utils.checkAuth, utils.checkCompanyOwner, async (req, res) => {
    const allowed = ['name', 'quantity', 'unit_type', 'unit_price'];
    const updateData = {};

    for (const f of allowed) {
        if (req.body[f] !== undefined) {
            updateData[f] = (f === 'quantity')
                ? parseInt(req.body[f])
                : (f === 'unit_price' ? parseFloat(req.body[f]) : req.body[f]);
        }
    }

    const updated = await prisma.companyScrapes.update({
        where: { id: req.params.id },
        data: updateData
    });

    return res.json({ code: 200, msg: 'Scrape updated', data: updated });
});

router.delete('/:company_id/scrapes/:id', utils.checkAuth, utils.checkCompanyOwner, async (req, res) => {
    await prisma.companyScrapes.delete({
        where: { id: req.params.id }
    });

    return res.json({ code: 200, msg: 'Scrape deleted' });
});


router.patch(
    '/:company_id/financials',
    utils.checkAuth,
    utils.checkCompanyOwner,
    async (req, res) => {
        try {
            const userId = req.user.id
            const company = req.company

            const { action, amount } = req.body

            if (!action) {
                return res.status(400).json({
                    code: 400,
                    msg: 'ACTION_REQUIRED',
                })
            }

            if (!amount || Number(amount) <= 0) {
                return res.status(400).json({
                    code: 400,
                    msg: 'INVALID_AMOUNT',
                })
            }

            let result

            switch (action) {
                /**
                 * CÔNG TY RÚT TIỀN
                 */
                case 'withdraw': {
                    const { note } = req.body

                    result = await financialHelpers.companyWithdraw({
                        companyId: company.id,
                        amount,
                        note,
                        performedBy: userId,
                    })
                    break
                }

                /**
                 * CÔNG TY CHI TIÊU
                 */
                case 'expense': {
                    const { note } = req.body

                    result = await financialHelpers.companyExpense({
                        companyId: company.id,
                        amount,
                        note,
                        performedBy: userId,
                    })
                    break
                }

                /**
                 * HOÀN TIỀN CHO USER
                 */
                case 'refund': {
                    const { to_user_id, order_id, note } = req.body

                    if (!to_user_id) {
                        return res.status(400).json({
                            code: 400,
                            msg: 'TO_USER_REQUIRED',
                        })
                    }

                    result = await financialHelpers.companyRefundUser({
                        companyId: company.id,
                        toUserId: to_user_id,
                        orderId: order_id,
                        amount,
                        note,
                        performedBy: userId,
                    })
                    break
                }

                /**
                 * PHÍ HỆ THỐNG
                 */
                case 'fee': {
                    const { note } = req.body

                    result = await financialHelpers.companyFee({
                        companyId: company.id,
                        amount,
                        note,
                    })
                    break
                }

                /**
                 * ĐIỀU CHỈNH TĂNG SỐ DƯ (ADMIN)
                 */
                case 'income_adjust': {
                    if (!req.user.flags?.includes('ADMIN')) {
                        return res.status(403).json({
                            code: 403,
                            msg: 'FORBIDDEN',
                        })
                    }

                    const { note } = req.body

                    result = await financialHelpers.companyIncomeAdjust({
                        companyId: company.id,
                        amount,
                        note,
                        performedBy: userId,
                    })
                    break
                }

                default:
                    return res.status(400).json({
                        code: 400,
                        msg: 'UNKNOWN_ACTION',
                    })
            }

            return res.json({
                code: 200,
                msg: 'OK',
                data: result,
            })
        } catch (err) {
            console.error(err)

            let status = 500
            let msg = 'INTERNAL_SERVER_ERROR'

            if (err.message === 'INSUFFICIENT_BALANCE') {
                status = 400
                msg = 'INSUFFICIENT_BALANCE'
            }

            if (err.message === 'COMPANY_NOT_FOUND') {
                status = 404
                msg = 'COMPANY_NOT_FOUND'
            }

            return res.status(status).json({
                code: status,
                msg,
            })
        }
    }
)



module.exports = router;
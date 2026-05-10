const express = require('express');
const router = express.Router();
const prisma = require('../utils/prisma');
const utils = require('../utils');

router.get('/', async (req, res) => {
    try {
        const categories = await prisma.product_categories.findMany({
            include: {
                products: true
            }
        });
        return res.json({ code: 200, msg: 'Ok', data: categories });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

router.get('/:category_id', async (req, res) => {
    const categoryId = req.params.category_id;
    try {
        const category = await prisma.product_categories.findUnique({
            where: { id: categoryId },
            include: {
                products: true
            }
        });
        if (!category) {
            return res.status(404).json({ code: 404, msg: 'Category not found' });
        }
        return res.json({ code: 200, msg: 'Ok', data: category });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

router.put('/', utils.checkAuth, utils.checkIsAdmin, async (req, res) => {
    const { name, description } = req.body;
    if (!name) {
        return res.status(400).json({ code: 400, msg: 'Missing required fields' });
    }
    try {
        const newCategory = await prisma.product_categories.create({
            data: {
                id: utils.createSnowflakeId(),
                name,
                description
            }
        });
        return res.json({ code: 200, msg: 'Category created', data: newCategory });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

router.delete('/:category_id', utils.checkAuth, utils.checkIsAdmin, async (req, res) => {
    const categoryId = req.params.category_id;
    try {
        const category = await prisma.product_categories.findUnique({
            where: { id: categoryId }
        });
        if (!category) {
            return res.status(404).json({ code: 404, msg: 'Category not found' });
        }
        await prisma.product_categories.delete({
            where: { id: categoryId }
        });
        return res.json({ code: 200, msg: 'Category deleted' });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

router.patch('/:category_id', utils.checkAuth, utils.checkIsAdmin, async (req, res) => {
    const categoryId = req.params.category_id;
    const { name, description } = req.body;
    try {
        const category = await prisma.product_categories.findUnique({
            where: { id: categoryId }
        });
        if (!category) {
            return res.status(404).json({ code: 404, msg: 'Category not found' });
        }
        const updatedCategory = await prisma.product_categories.update({
            where: { id: categoryId },
            data: {
                name: name || category.name,
                description: description || category.description
            }
        });
        return res.json({ code: 200, msg: 'Category updated', data: updatedCategory });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

module.exports = router;
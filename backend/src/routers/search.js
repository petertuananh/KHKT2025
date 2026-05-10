const express = require('express');
const router = express.Router();
const prisma = require('../utils/prisma');
const { callAI } = require('../utils/ai-service');
const { findProducts } = require('../utils/product-service');
const { scoreProduct } = require('../utils/score');
const SENSITIVE_FIELDS = ['hashed_password', 'bot_token'];

router.get('/', async (req, res) => {
    const searchCategory = req.query.category || req.query.type || req.query.data || '';
    const searchQuery = req.query.q || req.query.query || req.query.search || req.query.keyword || '';
    const searchIncludes = req.query.ic || req.query.include;

    let results = {
        users: [],
        companies: [],
        places: [],
        categories: [],
        products: []
    };

    // parse include
    let includeObject = undefined;
    if (searchIncludes) {
        const incArr = searchIncludes.split(',').map(i => i.trim());
        includeObject = incArr.reduce((acc, key) => {
            acc[key] = true;
            return acc;
        }, {});
    }

    try {
        // USERS
        if (searchCategory.includes('users') || searchCategory === '') {
            const users = await prisma.users.findMany({
                where: {
                    OR: [
                        { id: { contains: searchQuery, mode: 'insensitive' } },
                        { username: { contains: searchQuery, mode: 'insensitive' } },
                        { display_name: { contains: searchQuery, mode: 'insensitive' } },
                        { email: { contains: searchQuery, mode: 'insensitive' } },
                        { phone_number: { contains: searchQuery, mode: 'insensitive' } },
                    ]
                },
                include: includeObject,
                // omit: SENSITIVE_FIELDS.reduce((acc, field) => { acc[field] = true; return acc; }, {})
            });
            results.users = results.users.concat(users);
        }

        // COMPANIES
        if (searchCategory.includes('companies') || searchCategory === '') {
            const companies = await prisma.companies.findMany({
                where: {
                    OR: [
                        { id: { contains: searchQuery, mode: 'insensitive' } },
                        { tax_id: { contains: searchQuery, mode: 'insensitive' } },
                        { name: { contains: searchQuery, mode: 'insensitive' } },
                        { international_name: { contains: searchQuery, mode: 'insensitive' } },
                        { short_name: { contains: searchQuery, mode: 'insensitive' } },
                        { description: { contains: searchQuery, mode: 'insensitive' } },
                        { address: { contains: searchQuery, mode: 'insensitive' } },
                        { owned_by: { contains: searchQuery, mode: 'insensitive' } },
                    ]
                },
                include: includeObject
            });
            results.companies = results.companies.concat(companies);
        }

        // PLACES
        if (searchCategory.includes('places') || searchCategory === '') {
            const places = await prisma.places.findMany({
                where: {
                    OR: [
                        { id: { contains: searchQuery, mode: 'insensitive' } },
                        { name: { contains: searchQuery, mode: 'insensitive' } },
                        { description: { contains: searchQuery, mode: 'insensitive' } },
                        { address: { contains: searchQuery, mode: 'insensitive' } },
                        { user_id: { contains: searchQuery, mode: 'insensitive' } },
                        { company_id: { contains: searchQuery, mode: 'insensitive' } },
                    ]
                },
                include: includeObject
            });
            results.places = results.places.concat(places);
        }

        // CATEGORIES
        if (searchCategory.includes('categories') || searchCategory === '') {
            const categories = await prisma.product_categories.findMany({
                where: {
                    OR: [
                        { id: { contains: searchQuery, mode: 'insensitive' } },
                        { name: { contains: searchQuery, mode: 'insensitive' } },
                        { description: { contains: searchQuery, mode: 'insensitive' } },
                    ]
                },
                include: includeObject
            });
            results.categories = results.categories.concat(categories);
        }

        // PRODUCTS
        if (searchCategory.includes('products') || searchCategory === '') {
            const products = await prisma.products.findMany({
                where: {
                    OR: [
                        { id: { contains: searchQuery, mode: 'insensitive' } },
                        { name: { contains: searchQuery, mode: 'insensitive' } },
                        { description: { contains: searchQuery, mode: 'insensitive' } },
                        // { sku: { contains: searchQuery, mode: 'insensitive' } },
                        // { barcode: { contains: searchQuery, mode: 'insensitive' } },
                    ]
                },
                include: { ...includeObject, ...{ files: true } }
            });
            results.products = results.products.concat(products);
        }

        // 🔥 ONLY ONE LINE OF SANITIZATION HERE
        const clean = sanitizeDeep(results);

        return res.json({ code: 200, msg: 'Ok', data: clean });
    } catch (error) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error', error: error.message });
    }
});

router.post("/", async (req, res) => {
    try {
        const { query, min_stock, max_price, userLat, userLon } = req.body;

        // 1. Gọi AI
        const aiResult = await callAI({ query, min_stock, max_price });
        console.log("AI RESULT:", aiResult);
        // 2. Tìm sản phẩm
        let products = await findProducts(aiResult.filters, min_stock, max_price);
        // console.log("PRODUCTS:", products);

        // 3. Chấm điểm & sort
        products = products
            .map((p) => ({
                ...p,
                score: scoreProduct(p, aiResult, userLat, userLon, min_stock),
            }))
            .sort((a, b) => b.score.ai_score - a.score.ai_score);
        res.json({
            explain: aiResult.explain,
            results: products,
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Search failed" });
    }
});

module.exports = router;


function sanitizeDeep(data) {
    if (!data) return data;

    // ⚠️ FIX: Nếu là Date thì giữ nguyên
    if (data instanceof Date) return data;

    // Array
    if (Array.isArray(data)) {
        return data.map(item => sanitizeDeep(item));
    }

    // Object
    if (typeof data === 'object') {
        const cleaned = {};
        for (const key in data) {
            if (SENSITIVE_FIELDS.includes(key)) continue;
            cleaned[key] = sanitizeDeep(data[key]);
        }
        return cleaned;
    }

    return data; // primitive
}

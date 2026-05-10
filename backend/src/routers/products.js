const express = require('express');
const router = express.Router();
const prisma = require('../utils/prisma');
const utils = require('../utils');
const { deleteFileEverywhere } = require('../utils/file');

router.get('/', async (req, res) => {
    try {
        const products = await prisma.products.findMany({
            include: {
                place: {
                    include: {
                        user: {
                            omit: {
                                hashed_password: true,
                                bot_token: true
                            }
                        },
                        company: true
                    }
                },
                files: true
            }
        });
        return res.json({ code: 200, msg: 'Ok', data: products });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

router.get('/:product_id', async (req, res) => {
    const productId = req.params.product_id;
    try {
        const product = await prisma.products.findUnique({
            where: { id: productId },
            include: {
                category: true,
                place: {
                    include: {
                        user: {
                            omit: {
                                hashed_password: true,
                                bot_token: true
                            }
                        },
                        company: true
                    }
                },
                files: true
            }
        });
        if (!product) {
            return res.status(404).json({ code: 404, msg: 'Product not found' });
        }
        return res.json({ code: 200, msg: 'Ok', data: product });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

router.patch('/:product_id', utils.checkAuth, utils.checkProductOwner, async (req, res) => {
    const productId = req.params.product_id;
    const { name, description, price, stock, unit_type, category_id } = req.body;

    try {
        const product = await prisma.products.findUnique({
            where: { id: productId },
        });
        if (!product) {
            return res.status(404).json({ code: 404, msg: 'Product not found' });
        }

        const updatedProduct = await prisma.products.update({
            where: { id: productId },
            data: {
                name: name || product.name,
                description: description || product.description,
                price: price !== undefined ? parseFloat(price) : product.price,
                stock: stock !== undefined ? parseInt(stock) : product.stock,
                unit_type: unit_type || product.unit_type,
                category_id: category_id !== undefined ? (category_id || null) : product.category_id
            }
        });
        return res.json({ code: 200, msg: 'Product updated', data: updatedProduct });
    } catch (err) {
        console.log(err)
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

router.delete('/:product_id', utils.checkAuth, utils.checkProductOwner, async (req, res) => {
    const productId = req.params.product_id;
    try {
        await prisma.products.delete({
            where: { id: productId }
        });
        return res.json({ code: 200, msg: 'Product deleted' });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

router.delete('/:product_id/images/:image_id', utils.checkAuth, utils.checkProductOwner, async (req, res) => {
    try {
        const { product_id, image_id } = req.params;

        // 1. xoá file (CDN + DB)
        await deleteFileEverywhere(image_id);

        // 2. sắp lại order
        const images = await prisma.files.findMany({
            where: { product_id },
            orderBy: { order: 'asc' }
        });

        for (let i = 0; i < images.length; i++) {
            await prisma.files.update({
                where: { id: images[i].id },
                data: { order: i }
            });
        }

        return res.json({ code: 200, msg: 'Deleted' });
    } catch (err) {
        console.error(err);

        if (err.message === 'FILE_NOT_FOUND') {
            return res.status(404).json({ code: 404, msg: 'File không tồn tại' });
        }

        return res.status(500).json({
            code: 500,
            msg: 'Xoá ảnh thất bại'
        });
    }
}
);

router.patch('/:product_id/images/order', utils.checkAuth, utils.checkProductOwner, async (req, res) => {
    const { order } = req.body;
    // order = [{id, order}]

    try {
        for (const img of order) {
            await prisma.files.update({
                where: {
                    id: img.id,
                    product_id: req.params.product_id
                },
                data: { order: img.order }
            });
        }

        return res.json({ code: 200, msg: 'Order updated' });
    } catch (error) {
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});


module.exports = router;
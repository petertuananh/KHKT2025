const express = require('express');
const router = express.Router();
const prisma = require('../utils/prisma');
const utils = require('../utils');
const Axios = require('axios');
const sharp = require('sharp');
const config = require('../../config');
const {
    fetchImageBufferFromCDN,
    resizeImage
} = require('../utils/image');

router.get('/avatars/:user_id', async (req, res) => {
    try {
        let width = 128, height = 128;
        if (req.query.size) {
            const m = req.query.size.match(/^(\d+)x(\d+)$/);
            if (m) {
                width = +m[1];
                height = +m[2];
            }
        }

        const user = await prisma.users.findUnique({
            where: { id: req.params.user_id }
        });

        if (!user) {
            return res.status(404).json({ code: 404, msg: 'User not found' });
        }

        let imageBuffer = null;

        // Có avatar
        if (user.avatar_file_id) {
            const file = await prisma.files.findUnique({
                where: { id: user.avatar_file_id }
            });

            imageBuffer = await fetchImageBufferFromCDN(file);
        }

        // Không có avatar → UI Avatars
        if (!imageBuffer) {
            const uiAvatarRes = await Axios({
                url: 'https://ui-avatars.com/api/',
                method: 'GET',
                responseType: 'arraybuffer',
                params: {
                    name: user.name || user.username || user.display_name || 'User',
                    size: Math.max(width, height),
                    bold: true,
                    format: 'png'
                }
            });

            imageBuffer = Buffer.from(uiAvatarRes.data);
        }

        const output = await resizeImage(imageBuffer, width, height);
        res.setHeader('Content-Type', 'image/png');
        res.setHeader('Cache-Control', 'public, max-age=604800, immutable'); // 7 ngày
        res.setHeader('ETag', `"${user.avatar_file_id}-${width}x${height}"`);
        return res.send(output);

    } catch (err) {
        // console.error(err);
        return res.status(500).json({ code: 500, msg: 'Internal server error' });
    }
});

router.get('/product_images/:product_id/:image_id', async (req, res) => {
    try {
        let width = 450, height = 300;
        if (req.query.size) {
            const m = req.query.size.match(/^(\d+)x(\d+)$/);
            if (m) {
                width = +m[1];
                height = +m[2];
            }
        }

        const product = await prisma.products.findUnique({
            where: { id: req.params.product_id }
        });
        if (!product) {
            return res.status(404).json({ code: 404, msg: 'Product not found' });
        }

        const file = await prisma.files.findFirst({
            where: {
                id: req.params.image_id,
                product_id: req.params.product_id
            }
        });
        if (!file) {
            return res.status(404).json({ code: 404, msg: 'Image not found' });
        }

        const imageBuffer = await fetchImageBufferFromCDN(file);
        if (!imageBuffer) {
            return res.status(500).json({ code: 500, msg: 'Không tải được ảnh từ CDN' });
        }

        const output = await resizeImage(imageBuffer, width, height);
        res.setHeader('Content-Type', 'image/png');
        res.setHeader('Cache-Control', 'public, max-age=604800, immutable'); // 7 ngày
        res.setHeader('ETag', `"${file.id}-${width}x${height}"`);
        return res.send(output);

    } catch (err) {
        // console.error(err);
        return res.status(500).json({ code: 500, msg: 'Internal server error' });
    }
});


module.exports = router;
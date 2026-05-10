const express = require('express');
const router = express.Router();
const prisma = require('../utils/prisma');
const utils = require('../utils');
const Axios = require('axios');
const config = require('../../config');
const multer = require('multer');
const fs = require('fs');
const { deleteFileEverywhere } = require('../utils/file');
const upload = multer({ dest: '/tmp' }).fields([
    { name: 'files', maxCount: 1000 },     // KHỚP request
    { name: 'filenames[]' },             // KHỚP request
]);
const FormData = require('form-data');

router.get('/', async (req, res) => {
    const search = req.query.search;
    const files = await prisma.files.findMany({
        where: {
            name: {
                contains: search || '',
            }
        }
    });
    return res.json({ code: 200, msg: 'Lấy danh sách file thành công', data: files });
});


router.get('/:file_id', async (req, res) => {
    const file = await prisma.files.findUnique({
        where: {
            id: req.params.file_id
        }
    });
    if (!file) return res.json({ code: 404, msg: 'Không tìm thấy file' });
    const getFileFromCDN = await Axios({
        url: `${config.CDN_API_URL}/?action=download&filename=${file.id}.${file.name.split('.').pop()}`,
        method: 'POST',
        headers: {
            Authorization: `${config.CDN_PASSWORD}`
        }
    }).catch(err => {
        console.error(err);
        // return res.status(500).json({code: 500, msg: 'Lỗi khi tải file từ CDN'});
    });
    if (!getFileFromCDN?.data || getFileFromCDN.status !== 200) {
        return res.status(500).json({ code: 500, msg: 'Lỗi khi tải file từ CDN' });
    }
    await prisma.user_file_requests.create({
        data: {
            id: utils.createSnowflakeId(),
            file_id: req.params.file_id,
            user_id: req.user.id
        }
    });
    file.download_url = getFileFromCDN.data.data.url;
    if (!file.download_url) return res.status(500).json({ code: 500, msg: 'Lỗi khi tải file từ CDN' });
    return res.json({
        code: 200,
        msg: 'Lấy link tải file thành công',
        data: file
    });
});

router.put('/', upload, async (req, res) => {
    try {
        const { type } = req.body;

        if (!req.files || req.files.files.length === 0) {
            return res.status(400).json({ code: 400, msg: 'Không có file upload' });
        }

        // --- Lấy filenames[] từ body ---
        let filenames = req.body.filenames;   // có thể là string hoặc array

        // nếu chỉ có 1 phần tử → Multer trả về string → ép thành array
        if (!Array.isArray(filenames)) {
            filenames = [filenames];
        }



        // Kiểm tra số lượng
        if (filenames.length !== req.files.files.length) {
            return res.status(400).json({
                code: 400,
                msg: 'Số lượng filenames không khớp số lượng files upload'
            });
        }


        const results = [];

        // --- Xử lý file theo đúng index ---
        for (let i = 0; i < req.files.files.length; i++) {
            const fileId = crypto.randomUUID();
            
            const file = req.files.files[i];
            const displayName = decodeURIComponent(filenames[i] || file.originalname); // fallback nếu thiếu


            const form = new FormData();
            form.append("file", fs.createReadStream(file.path));

            // 1. Upload file lên CDN
            const uploadToCDN = await Axios({
                url: `${config.CDN_API_URL}/?action=upload`,
                method: 'POST',
                headers: {
                    "Authorization": config.CDN_PASSWORD,
                },
                data: form
            });

            if (uploadToCDN.status !== 200) {
                continue; // skip file lỗi
            }

            const tempName = uploadToCDN.data.data.filename;
            const ext = file.originalname.split('.').pop();

            // 2. Tạo ID và tên file cuối
            const finalName = `${fileId}.${ext}`;

            // 3. Rename file trên CDN
            await Axios({
                url: `${config.CDN_API_URL}/?action=rename`,
                method: 'POST',
                headers: { Authorization: config.CDN_PASSWORD },
                data: {
                    old: tempName,
                    new: finalName
                }
            });

            // 4. Lưu DB → Lưu đúng tên client gửi
            const saved = await prisma.files.create({
                data: {
                    id: fileId,
                    name: displayName,
                    product_id: req.body.product_id || null,
                    user_id: req.user.id
                }
            });

            results.push({
                ...saved,
                cdn_filename: finalName
            });

            if (type == 'user_avatar') {
                if (i > 0) {
                    break; // Chỉ cho upload 1 file avatar
                }
                const user_id = (req.body.user_id && req.user.flags.includes('ADMIN')) ? req.body.user_id : req.user.id
                await prisma.users.update({
                    where: {
                        id: user_id
                    },
                    data: { avatar_file_id: fileId }
                });
            } else if (type == 'company_logo') {
                if (i > 0) {
                    break; // Chỉ cho upload 1 file logo công ty
                }
                if (!req.body.company_id) {
                    return res.status(400).json({ code: 400, msg: 'Thiếu company_id để upload logo công ty' });
                }
                const company = await prisma.companies.findUnique({
                    where: { id: req.body.company_id }
                });
                if (!company) {
                    return res.status(404).json({ code: 404, msg: 'Công ty không tồn tại' });
                }
                if (company.owned_by !== req.user.id && !req.user.flags?.includes('ADMIN')) {
                    return res.status(403).json({ code: 403, msg: 'Bạn không có quyền sửa logo công ty này' });
                }
                await prisma.companies.update({
                    where: { id: req.body.company_id },
                    data: { logo_file_id: fileId }
                });
            } else if (type == 'product_image') {
                if (!req.body.product_id) {
                    return res.status(400).json({ code: 400, msg: 'Thiếu product_id để upload ảnh sản phẩm' });
                }
                const product = await prisma.products.findUnique({
                    where: { id: req.body.product_id }
                });
                if (!product) {
                    return res.status(404).json({ code: 404, msg: 'Sản phẩm không tồn tại' });
                }
                const place = await prisma.places.findUnique({
                    where: { id: product.place_id }
                });
                if (!place) {
                    return res.status(404).json({ code: 404, msg: 'Địa điểm của sản phẩm không tồn tại' });
                }
                if (place.user_id !== req.user.id && !req.user.flags?.includes('ADMIN')) {
                    return res.status(403).json({ code: 403, msg: 'Bạn không có quyền sửa ảnh sản phẩm này' });
                }
                await prisma.products.update({
                    where: { id: req.body.product_id },
                    data: {
                        files: {
                            connect: [{ id: fileId }] // <-- nối file đã tồn tại
                        }
                    }
                });
            }


        }

        return res.json({
            code: 200,
            msg: "Upload nhiều file thành công",
            data: results
        });

    } catch (err) {
        console.error(err);
        return res.status(500).json({ code: 500, msg: 'Lỗi server khi upload file' });
    }
});


router.patch('/:file_id', async (req, res) => {
    try {
        const { new_name } = req.body;

        if (!new_name) {
            return res.status(400).json({ code: 400, msg: "Thiếu tên file mới" });
        }

        const file = await prisma.files.findUnique({
            where: { id: req.params.file_id }
        });

        if (!file) {
            return res.status(404).json({ code: 404, msg: "File không tồn tại" });
        }

        // CẬP NHẬT TÊN FILE TRONG DB
        const updated = await prisma.files.update({
            where: { id: file.id },
            data: { name: new_name }
        });

        return res.json({
            code: 200,
            msg: "Đổi tên file thành công",
            data: updated
        });

    } catch (err) {
        console.error(err);
        return res.status(500).json({ code: 500, msg: "Lỗi server khi đổi tên file" });
    }
});
router.delete('/:file_id', async (req, res) => {
    try {
        await deleteFileEverywhere(req.params.file_id);
        return res.json({ code: 200, msg: 'Xoá file thành công' });
    } catch (err) {
        return res.status(500).json({ code: 500, msg: 'Xoá file thất bại' });
    }
});



module.exports = router;
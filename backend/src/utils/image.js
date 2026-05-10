// src/utils/image.js
const Axios = require('axios');
const sharp = require('sharp');
const config = require('../../config');

/**
 * Lấy buffer ảnh từ CDN thông qua file record
 */
async function fetchImageBufferFromCDN(file) {
    if (!file) return null;

    // 1️⃣ Xin link download
    const cdnMeta = await Axios({
        url: `${config.CDN_API_URL}/?action=download&filename=${file.id}.${file.name.split('.').pop()}`,
        method: 'POST',
        headers: {
            Authorization: config.CDN_PASSWORD
        }
    });

    const downloadUrl = cdnMeta.data?.data?.url;
    if (!downloadUrl) return null;

    // 2️⃣ Tải ảnh thật
    const imageRes = await Axios({
        url: downloadUrl,
        method: 'GET',
        responseType: 'arraybuffer'
    });

    return Buffer.from(imageRes.data);
}

/**
 * Resize buffer ảnh
 */
async function resizeImage(buffer, width, height) {
    return sharp(buffer)
        .resize(width, height, { fit: 'cover' })
        .png()
        .toBuffer();
}

module.exports = {
    fetchImageBufferFromCDN,
    resizeImage
};

const Axios = require('axios');
const prisma = require('./prisma');
const config = require('../../config');

async function deleteFileEverywhere(file_id) {
    // 1. lấy file
    const file = await prisma.files.findUnique({
        where: { id: file_id }
    });

    if (!file) {
        throw new Error('FILE_NOT_FOUND');
    }

    const ext = file.name.split('.').pop();
    const cdnFilename = `${file.id}.${ext}`;

    // 2. xoá CDN
    const cdnRes = await Axios({
        url: `${config.CDN_API_URL}/?action=remove`,
        method: 'POST',
        headers: {
            Authorization: config.CDN_PASSWORD,
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        data: new URLSearchParams({
            filename: cdnFilename
        }).toString()
    });

    if (cdnRes.status !== 200) {
        throw new Error('CDN_DELETE_FAILED');
    }

    // 3. xoá DB
    await prisma.files.delete({
        where: { id: file_id }
    });

    return true;
}

module.exports = {
    deleteFileEverywhere
};

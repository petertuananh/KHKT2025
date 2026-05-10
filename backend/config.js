require('dotenv').config();

module.exports = {
    PORT: process.env.PORT || 3000,
    JWT_SECRET: process.env.JWT_SECRET,
    GOOGLE_CLIENT_ID: '7348902793997842432',
    GOOGLE_CLIENT_SECRET: 'bfTOJKbpOltQdm9Ax5UqZcWPHWBQp0',
    OAUTH2_REDIRECT_URI: 'https://trashe.io.vn/api/auth/callback',
    CDN_API_URL: process.env.CDN_API_URL,
    CDN_PASSWORD: process.env.CDN_PASSWORD
}
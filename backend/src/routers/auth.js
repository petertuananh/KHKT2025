const express = require('express');
const router = express.Router();

const axios = require('axios');
const jwt = require('jsonwebtoken');

const config = require('../../config');
const utils = require('../utils');

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

router.get('/login', async (req, res) => {

    const state = utils.createSnowflakeId();

    const params = new URLSearchParams({
        client_id: config.GOOGLE_CLIENT_ID,
        redirect_uri: config.OAUTH2_REDIRECT_URI,
        response_type: 'code',
        scope: 'openid profile email',
        state
    });

    return res.redirect(
        `https://iam.softapi.vn/oauth/authorize?${params.toString()}`
    );
});

router.get('/callback', async (req, res) => {

    const code = req.query.code;

    if (!code) {
        return res.status(400).json({
            error: 'Missing code'
        });
    }

    try {

        /*
            EXCHANGE TOKEN
        */

        const tokenResponse = await axios.post(
            'https://iam.softapi.vn/oauth/token',

            new URLSearchParams({
                grant_type: 'authorization_code',
                code,
                client_id: config.GOOGLE_CLIENT_ID,
                client_secret: config.GOOGLE_CLIENT_SECRET,
                redirect_uri: config.OAUTH2_REDIRECT_URI
            }),

            {
                headers: {
                    'Content-Type':
                        'application/x-www-form-urlencoded'
                }
            }
        );

        console.log(tokenResponse.data);

        const {
            access_token,
            id_token,
            refresh_token
        } = tokenResponse.data;

        /*
            USERINFO
        */

        const userInfoResponse = await axios.get(
            'https://iam.softapi.vn/oauth/userinfo',
            {
                headers: {
                    Authorization:
                        `Bearer ${access_token}`
                }
            }
        );

        console.log(userInfoResponse.data);

        const {
            sub,
            email,
            preferred_username,
            name
        } = userInfoResponse.data;

        /*
            FIND USER
        */

        let user = await prisma.users.findFirst({
            where: {
                OR: [
                    { google_id: sub },
                    { email: email || undefined }
                ]
            }
        });

        /*
            CREATE USER
        */

        if (!user) {

            user = await prisma.users.create({
                data: {

                    id: utils.createSnowflakeId(),

                    google_id: sub,

                    email: email || null,

                    display_name:
                        name ||
                        preferred_username ||
                        null,

                    username:
                        preferred_username ||
                        (
                            email
                                ? email.split('@')[0]
                                : `user_${Date.now()}`
                        )
                }
            });

        }

        /*
            CREATE JWT
        */

        const token = jwt.sign(
            {
                id: user.id,
                username: user.username,
                email: user.email
            },
            config.JWT_SECRET,
            {
                expiresIn: '7d'
            }
        );

        /*
            REDIRECT
        */

        return res.redirect(
            `/login.php?token=${encodeURIComponent(token)}`
        );

    } catch (err) {

        console.error(
            err.response?.data || err.message
        );

        return res.status(500).json({
            error: 'Internal server error'
        });
    }
});

module.exports = router;
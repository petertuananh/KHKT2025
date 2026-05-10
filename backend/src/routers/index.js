const express = require('express');
const router = express.Router();
const utils = require('../utils');
// router.get('/', (req, res) => {
//     return res.json({code: 200, msg: 'Ok, NodeJS'})
// });

router.post('/', (req, res) => {
    return res.json({ code: 200, msg: 'Ok, NodeJS' })
});

router.use('/auth', require('./auth'));
router.use('/companies', require('./companies'));
router.use('/users', utils.checkAuth, require('./users'));
router.use('/chats', utils.checkAuth, require('./chats'));
router.use('/files', utils.checkAuth, require('./files'));
router.use('/orders', utils.checkAuth, require('./orders'));
router.use('/payment', require('./payment'));
// router.use('/admin', utils.checkAuth, utils.checkIsAdmin, require('./admin'));
router.use('/places', require('./places'));
router.use('/search', require('./search'));
router.use('/products', require('./products'));
router.use('/categories', require('./categories'));
router.use('/media-proxy', require('./media-proxy'));

module.exports = router;
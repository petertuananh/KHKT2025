const express = require('express');
const router = express.Router();
const prisma = require('../../utils/prisma');

router.patch('/:user_id', async (req, res) => {
    const userId = req.params.user_id;
    const { username, display_name, email, phone_number, flags } = req.body;
    try {
        const getUser = await prisma.users.findUnique({
            where: { id: userId }
        });
        if (!getUser) {
            return res.status(404).json({ code: 404, msg: 'User not found' });
        }
        const updatedUser = await prisma.users.update({
            where: { id: userId },
            data: {
                username: username || getUser.username,
                display_name: display_name || getUser.display_name,
                email: email || getUser.email,
                phone_number: phone_number || getUser.phone_number,
                flags: flags !== undefined ? flags : getUser.flags
            }
        });
        return res.json({ code: 200, msg: 'User updated', data: updatedUser });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ code: 500, msg: 'Internal Server Error' });
    }
});

module.exports = router;
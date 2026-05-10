const express = require('express');
const router = express.Router();
const crypto = require('crypto');
const payos = require('../utils/payos');
const prisma = require('../utils/prisma');
const utils = require('../utils');
router.post('/payos/webhook', async (req, res) => {
    try {
        /**
         * 1️⃣ Verify chữ ký PayOS
         */
        const webhookData = await payos.webhooks.verify(req.body)

        const {
            orderCode, // = transaction id
            amount,
            code        // '00' = thành công
        } = webhookData

        const txId = String(orderCode)

        /**
         * 2️⃣ Lấy transaction
         */
        const tx = await prisma.user_transactions.findUnique({
            where: { id: txId }
        })

        /**
         * Không tồn tại hoặc đã xử lý → bỏ qua (idempotent)
         */
        if (!tx || tx.status !== 'pending') {
            return res.send('OK')
        }

        /**
         * 3️⃣ Kiểm tra số tiền (rất quan trọng)
         */
        if (Number(tx.amount) !== Number(amount)) {
            console.error('PayOS amount mismatch', {
                txAmount: tx.amount,
                webhookAmount: amount
            })

            await prisma.user_transactions.update({
                where: { id: tx.id },
                data: {
                    status: 'canceled',
                    note: 'Amount mismatch from PayOS'
                }
            })

            return res.send('OK')
        }

        /**
         * 4️⃣ Thanh toán thành công
         */
        if (code === '00') {
            await prisma.$transaction(async (prisma) => {
                // update transaction
                await prisma.user_transactions.update({
                    where: { id: tx.id },
                    data: {
                        status: 'finished',
                        modified_at: new Date()
                    }
                })

                // cộng tiền user
                await prisma.users.update({
                    where: { id: tx.user_id },
                    data: {
                        balance: {
                            increment: Number(tx.amount)
                        }
                    }
                })
            })
        } else {
            /**
             * 5️⃣ Thanh toán thất bại / huỷ
             */
            await prisma.user_transactions.update({
                where: { id: tx.id },
                data: {
                    status: 'canceled',
                    modified_at: new Date()
                }
            })
        }

        return res.send('OK')

    } catch (err) {
        console.error('PayOS webhook error:', err)
        return res.status(400).send('Invalid webhook')
    }
})


module.exports = router;
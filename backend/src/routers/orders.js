const express = require('express');
const router = express.Router();
const prisma = require('../utils/prisma');
const utils = require('../utils');
const financialHelpers = require('../utils/financial');

router.post('/:order_id/checkout', async (req, res) => {
    const orderId = req.params.order_id;
    const userId = req.user.id;
    const isAdmin = req.user.flags?.includes('ADMIN');

    const order = await prisma.orders.findUnique({
        where: { id: orderId },
    });

    if (!order) {
        return res.status(404).json({ code: 404, msg: 'Đơn hàng không tồn tại' });
    }

    // Quyền
    if (order.user_id !== userId && !isAdmin) {
        return res.status(403).json({ code: 403, msg: 'Không có quyền thanh toán đơn này' });
    }

    if (order.status !== 'pending') {
        return res.status(400).json({
            code: 400,
            msg: 'Chỉ có thể thanh toán đơn đang chờ xử lý'
        });
    }

    if (order.products.length <= 0) return res.status(400).json({
        code: 400,
        msg: 'Đơn không có mặt hàng để thanh toán'
    });
    const result = await prisma.$transaction(async (tx) => {


        order.products.forEach(async (pd) => {
            const product = pd.product;
            const getProductById = await tx.products.findUnique({
                where: {
                    id: product.id
                },
                include: {
                    place: {
                        include: {
                            user: true,
                            company: true
                        }
                    }
                }
            });
            if (!getProductById) return;
            const price = Number(getProductById.price);
            const quantity = Number(pd.amount);

            if (!Number.isFinite(price) || !Number.isFinite(quantity)) {
                throw new Error('INVALID_AMOUNT_INPUT');
            }

            const amount = price * quantity;

            if (getProductById.place.user_id) {
                financialHelpers.userTransfer({
                    fromUserId: userId,
                    toUserId: getProductById.place.user_id,
                    amount: amount,
                    note: `Thanh toán đơn hàng ${orderId} cho ${getProductById.place.user.username} [${getProductById.place.user_id}]`,
                });
            } else if (getProductById.place.company_id) {
                financialHelpers.userPayCompany({
                    userId,
                    companyId: getProductById.place.company_id,
                    orderId: orderId,
                    amount: amount,
                    note: `Thanh toán đơn hàng ${orderId}`
                });
            }
            tx.products.update({
                where: { id: product.id },
                data: {
                    stock: { decrement: pd.amount }
                }
            });
        })
        const newOrder = await tx.orders.update({
            where: {
                id: orderId
            },
            data: {
                status: 'paid'
            }
        });
        return newOrder;
    });
    return res.json({ code: 200, msg: 'Thanh toán thành công', data: result })
});

router.delete('/:order_id', async (req, res) => {
    const orderId = req.params.order_id;
    const userId = req.user.id;
    const isAdmin = req.user.flags?.includes('ADMIN');

    const order = await prisma.orders.findUnique({
        where: { id: orderId },
    });

    if (!order) {
        return res.status(404).json({ code: 404, msg: 'Đơn hàng không tồn tại' });
    }

    // Quyền
    if (order.user_id !== userId && !isAdmin) {
        return res.status(403).json({ code: 403, msg: 'Không có quyền hủy đơn này' });
    }

    if (order.status !== 'pending') {
        return res.status(400).json({
            code: 400,
            msg: 'Chỉ có thể hủy đơn đang chờ xử lý'
        });
    }

    await prisma.$transaction(async (tx) => {

        // 1️⃣ Cập nhật trạng thái đơn
        await tx.orders.update({
            where: { id: orderId },
            data: { status: 'cancelled' }
        });
    });

    return res.json({
        code: 200,
        msg: 'Đã hủy đơn hàng'
    });
});


router.get('/', utils.checkIsAdmin, async (req, res) => {
    const getAllOrders = await prisma.orders.findMany({
        include: {
            user: true,
            user_transactions: true,
            company_transactions: true,
        }
    });
    return res.json({code: 200, msg: 'Ok', data: getAllOrders});
});

router.get('/:order_id', async (req, res) => {
    const orderId = req.params.order_id
    const userId = req.user.id
    const isAdmin = req.user.flags?.includes('ADMIN')
    const findOrderById = await prisma.orders.findUnique({
        where: {
            id: req.params.order_id
        },
        include: {
            user: true,
            user_transactions: {
                include: {
                    to_company: true,
                    to_user: true
                }
            },
            company_transactions: true,
        }
    });
    if (findOrderById.user_id !== userId && !isAdmin) {
        return res.status(403).end()
    }
    if (findOrderById.user_id !== req.user.id && !req.user.flags.includes('ADMIN')) return res.json({code: 403, msg: '403: Unauthorized'})
    return res.json({code: 200, msg: 'Ok', data: findOrderById});
});

router.get('/:order_id/invoice.pdf', utils.checkAuth, async (req, res) => {
    const orderId = req.params.order_id
    const userId = req.user.id
    const isAdmin = req.user.flags?.includes('ADMIN')
    const order = await prisma.orders.findUnique({
        where: { id: orderId },
        include: {
            user: true,
            user_transactions: true,
            company_transactions: true
        }
    })

    if (!order) return res.status(404).end()
    if (order.user_id !== userId && !isAdmin) return res.status(403).end()

    const PDFDocument = require('pdfkit')
    const path = require('path')

    const doc = new PDFDocument({ margin: 40 })

    res.setHeader('Content-Type', 'application/pdf')
    res.setHeader(
        'Content-Disposition',
        `inline; filename=invoice-${order.id}.pdf`
    )

    doc.pipe(res)

    // ==== FONT VIỆT ====
    doc.registerFont(
        'Roboto',
        path.join(__dirname, '../fonts/Roboto-Regular.ttf')
    )
    doc.registerFont(
        'Roboto-Bold',
        path.join(__dirname, '../fonts/Roboto-Bold.ttf')
    )

    doc.font('Roboto-Bold').fontSize(18)
        .text('HÓA ĐƠN THANH TOÁN', { align: 'center' })

    doc.moveDown()

    doc.font('Roboto').fontSize(12)
        .text(`Mã đơn: ${order.id}`)
        .text(`Khách hàng: ${order.user.display_name}`)
        .text(`Email: ${order.user.email}`)
        .text(`Ngày tạo: ${new Date(order.created_at).toLocaleString('vi-VN')}`)

    doc.moveDown()

    let total = 0
    order.products.forEach(p => {
        const line = p.product.price * p.amount
        total += line
        doc.text(
            `${p.product.name} — ${p.amount} x ${p.product.price.toLocaleString('vi-VN')} ₫ = ${line.toLocaleString('vi-VN')} ₫`
        )
    })

    doc.moveDown()
    doc.font('Roboto-Bold').fontSize(14)
        .text(`TỔNG TIỀN: ${total.toLocaleString('vi-VN')} ₫`, {
            align: 'right'
        })

    doc.end()
});

module.exports = router;
const express = require('express');
const router = express.Router();
const prisma = require('../../utils/prisma');
const crypto = require('crypto');
const financialHelpers = require('../../utils/financial');
const utils = require('../../utils');
const payos = require('../../utils/payos');

router.get('/@me', async (req, res) => {
    const findUserFull = await prisma.users.findUnique({
        where: { id: req.user.id },
        include: {
            chats: {
                where: {
                    users: {
                        some: { id: req.user.id }
                    }
                },
                include: { users: true, messages: { orderBy: { created_at: 'desc' }, take: 1 } },
            },
            companies: true,
            places: true,
            carts: {
                include: {
                    product: {
                        include: {
                            files: true
                        }
                    }
                }
            },
            company_deliveries: true,
            company_recruitments: true,
            company_scrapes: true
        }
    });
    return res.json({ code: 200, msg: 'Ok', data: findUserFull });
});



router.patch('/:user_id', async (req, res) => {
    let userId = req.params.user_id;
    if (userId === req.user.id || userId == '@me') userId = req.user.id;
    if (userId !== req.user.id && !req.user.flags?.includes('ADMIN')) return res.status(403).json({ code: 403, msg: 'Forbidden' });
    const { username, display_name, email, phone_number, flags } = req.body;
    if (flags && !req.user.flags?.includes('ADMIN')) {
        return res.status(403).json({ code: 403, msg: 'Forbidden: Only admins can modify flags' });
    }
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

router.get('/:user_id', async (req, res) => {
    const findUserFull = await prisma.users.findUnique({
        where: { id: req.params.user_id },
        include: {
            companies: true,
            places: true,
            carts: true,
            company_deliveries: true,
            company_recruitments: true,
            company_scrapes: true
        },
        omit: {
            hashed_password: true,
            bot_token: true
        }
    });
    return res.json({ code: 200, msg: 'Ok', data: findUserFull });
});

router.get('/:user_id/orders', async (req, res) => {
    let userId = req.params.user_id;
    if (userId === req.user.id || userId == '@me') userId = req.user.id;
    if (userId !== req.user.id && !req.user.flags?.includes('ADMIN')) return res.status(403).json({ code: 403, msg: 'Forbidden' });
    const findOrdersByUserId = await prisma.orders.findMany({
        where: {
            user_id: userId,
        },
        include: {
            user_transactions: true
        }
    });
    return res.json({ code: 200, msg: 'Ok', data: findOrdersByUserId });
});

router.patch('/@me', async (req, res) => {
    const { username, display_name, email, phone_number } = req.body;
    const getCurrentUser = await prisma.users.findUnique({
        where: { id: req.user.id }
    });
    const updatedUser = await prisma.users.update({
        where: { id: req.user.id },
        data: {
            username: username || getCurrentUser.username,
            display_name: display_name || getCurrentUser.display_name,
            email: email || getCurrentUser.email,
            phone_number: phone_number || getCurrentUser.phone_number,
        }
    });
    return res.json({ code: 200, msg: 'Ok', data: updatedUser });
})

router.get('/', async (req, res) => {
    const searchQuery = req.query.q || req.query.query || req.query.search || req.query.keyword || '';
    const getUsers = await prisma.users.findMany({
        where: {
            OR: [
                { id: { contains: searchQuery, mode: 'insensitive' } },
                { username: { contains: searchQuery, mode: 'insensitive' } },
                { email: { contains: searchQuery, mode: 'insensitive' } },
                { phone_number: { contains: searchQuery, mode: 'insensitive' } },
                { display_name: { contains: searchQuery, mode: 'insensitive' } },
            ]
        },
        include: {
            companies: true,
        },
        omit: {
            hashed_password: true,
            bot_token: true
        }
    });
    return res.json({ code: 200, msg: 'Ok', data: getUsers });
});

router.get('/@me/cart', async (req, res) => {
    const getUserCart = await prisma.carts.findMany({
        where: {
            user_id: req.user.id
        },
        include: {
            product: true,
        }
    });
    return res.json({ code: 200, msg: 'Ok', data: getUserCart });
});

router.put('/@me/cart', async (req, res) => {
    const { product_id, amount } = req.body;

    if (!product_id || !amount || amount <= 0) {
        return res.status(400).json({ code: 400, msg: 'Dữ liệu không hợp lệ' });
    }

    // Lấy product + stock
    const product = await prisma.products.findUnique({
        where: { id: product_id }
    });

    if (!product) {
        return res.status(404).json({ code: 404, msg: 'Sản phẩm không tồn tại' });
    }

    // Kiểm tra cart hiện tại
    const cartItem = await prisma.carts.findFirst({
        where: {
            user_id: req.user.id,
            product_id
        }
    });

    const newAmount = cartItem ? cartItem.amount + amount : amount;

    if (newAmount > product.stock) {
        return res.status(400).json({
            code: 400,
            msg: 'Số lượng vượt quá tồn kho',
            stock: product.stock
        });
    }

    let result;
    if (cartItem) {
        result = await prisma.carts.update({
            where: { id: cartItem.id },
            data: { amount: newAmount }
        });
    } else {
        result = await prisma.carts.create({
            data: {
                id: crypto.randomUUID(),
                user_id: req.user.id,
                product_id,
                amount
            }
        });
    }

    return res.json({ code: 200, msg: 'Đã thêm vào giỏ hàng', data: result });
});
router.patch('/@me/cart/:id', async (req, res) => {
    const { id } = req.params;
    const { amount } = req.body;

    if (amount == null || amount <= 0) {
        return res.status(400).json({ code: 400, msg: 'Số lượng không hợp lệ' });
    }

    const cartItem = await prisma.carts.findFirst({
        where: {
            id,
            user_id: req.user.id
        },
        include: {
            product: true
        }
    });

    if (!cartItem) {
        return res.status(404).json({ code: 404, msg: 'Item không tồn tại trong cart' });
    }

    if (amount > cartItem.product.stock) {
        return res.status(400).json({
            code: 400,
            msg: 'Số lượng vượt quá tồn kho',
            stock: cartItem.product.stock
        });
    }

    const updated = await prisma.carts.update({
        where: { id },
        data: { amount }
    });

    return res.json({ code: 200, msg: 'Đã cập nhật cart', data: updated });
});
router.delete('/@me/cart/:id', async (req, res) => {
    const { id } = req.params;

    const cartItem = await prisma.carts.findFirst({
        where: {
            id,
            user_id: req.user.id
        }
    });

    if (!cartItem) {
        return res.status(404).json({ code: 404, msg: 'Item không tồn tại' });
    }

    await prisma.carts.delete({
        where: { id }
    });

    return res.json({ code: 200, msg: 'Đã xóa khỏi giỏ hàng' });
});


router.put('/@me/orders', async (req, res) => {
    const userId = req.user.id;

    // 1. Lấy user + cart + product
    const user = await prisma.users.findUnique({
        where: { id: userId },
        include: {
            carts: {
                include: {
                    product: true
                }
            }
        }
    });

    if (!user) {
        return res.status(404).json({ code: 404, msg: 'User không tồn tại' });
    }

    if (!user.carts.length) {
        return res.status(400).json({
            code: 400,
            msg: 'Giỏ hàng trống'
        });
    }

    // 2. Tính tổng tiền + kiểm tra stock
    let totalAmount = 0;

    for (const item of user.carts) {
        if (item.amount > item.product.stock) {
            return res.status(400).json({
                code: 400,
                msg: `Sản phẩm "${item.product.name}" không đủ tồn kho`,
                stock: item.product.stock
            });
        }
        totalAmount += item.amount * item.product.price;
    }

    totalAmount = Math.floor(totalAmount);

    // // 3. Check balance
    // if (user.balance < totalAmount) {
    //     return res.status(400).json({
    //         code: 400,
    //         msg: 'Số dư không đủ',
    //         balance: user.balance,
    //         required: totalAmount
    //     });
    // }

    // 4. Thanh toán (transaction)
    try {
        const orderId = crypto.randomUUID();
        // 4.1 Tạo order
        const order = await prisma.orders.create({
            data: {
                id: orderId,
                user_id: userId,
                status: 'pending',
                products: user.carts
            }
        });

        await prisma.carts.deleteMany({
            where: { user_id: userId }
        });

        // const result = await prisma.$transaction(async (tx) => {
        //     const txId = crypto.randomUUID();


        //     // 4.2 Tạo transaction (use)
        //     await tx.user_transactions.create({
        //         data: {
        //             id: txId,
        //             user_id: userId,
        //             order_id: orderId,
        //             amount: totalAmount,
        //             type: 'use',
        //             status: 'finished'
        //         }
        //     });

        //     // 4.3 Trừ balance
        //     await tx.users.update({
        //         where: { id: userId },
        //         data: {
        //             balance: { decrement: totalAmount }
        //         }
        //     });

        //     // 4.4 Trừ stock
        //     for (const item of user.carts) {
        //         await tx.products.update({
        //             where: { id: item.product_id },
        //             data: {
        //                 stock: { decrement: item.amount }
        //             }
        //         });
        //     }

        //     // 4.5 Clear cart
        //     await tx.carts.deleteMany({
        //         where: { user_id: userId }
        //     });

        //     return order;
        // });

        return res.json({
            code: 200,
            msg: 'Tạo đơn hàng thành công',
            data: order
        });

    } catch (err) {
        console.log(err)
        return res.status(500).json({
            code: 500,
            msg: 'Tạo đơn hàng thất bại'
        });
    }
});


router.patch('/:user_id/financials', async (req, res) => {
    try {
        let userId = req.params.user_id;
        if (userId === req.user.id || userId == '@me') userId = req.user.id;
        if (userId !== req.user.id && !req.user.flags?.includes('ADMIN')) return res.status(403).json({ code: 403, msg: 'Forbidden' });
        const { action, amount, transaction_id } = req.body

        if (!action) {
            return res.status(400).json({
                code: 400,
                msg: 'ACTION_REQUIRED',
            })
        }

        if (!['topup_cancel'].includes(action) && (!amount || Number(amount) <= 0)) {
            return res.status(400).json({
                code: 400,
                msg: 'INVALID_AMOUNT',
            })
        }

        let result

        switch (action) {
            /**
             * ======================
             * NẠP TIỀN (PAYOS)
             * ======================
             */
            case 'topup': {
                const amount = Number(req.body.amount)

                if (!amount || amount < 10000) {
                    return res.status(400).json({
                        code: 400,
                        msg: 'Số tiền tối thiểu là 10.000₫',
                    })
                }

                if (amount > 10000000000) {
                    return res.status(400).json({
                        code: 400,
                        msg: 'Số tiền tối đa là 10.000.000.000₫',
                    })
                }

                // 1️⃣ Tạo transaction pending
                const txId = utils.createSnowflakeId().slice(-12)

                await prisma.user_transactions.create({
                    data: {
                        id: txId,
                        user_id: userId,
                        amount,
                        type: 'topup',
                        status: 'pending',
                        note: 'Nạp qua PayOS',
                    },
                })

                // 2️⃣ Tạo PayOS payment link
                const paymentLink = await payos.paymentRequests.create({
                    orderCode: Number(txId),
                    amount: Math.floor(amount),
                    description: `TOPUP_${userId}`,
                    returnUrl: `${process.env.APP_URL}/manage/topup.php?success=1`,
                    cancelUrl: `${process.env.APP_URL}/manage/topup.php?cancel=1`,
                })

                return res.json({
                    code: 200,
                    msg: 'OK',
                    data: {
                        checkout_url: paymentLink.checkoutUrl,
                        transaction_id: txId,
                    },
                })
            }

            case 'topup_cancel': {
                if (!transaction_id) return res.json({ code: 400, msg: 'Thiếu mã giao dịch.' });
                const findTopupTransaction = await prisma.user_transactions.findFirst({
                    where: {
                        id: transaction_id,
                        user_id: userId,
                        type: 'topup',
                    }
                });
                if (!findTopupTransaction) return res.json({ code: 400, msg: 'Không tìm thấy giao dịch nạp tiền.' });
                if (findTopupTransaction.status !== 'pending') return res.json({ code: 400, msg: 'Giao dịch đã hoàn thành hoặc hủy.' });
                result = await prisma.user_transactions.update({
                    where: {
                        id: findTopupTransaction.id
                    },
                    data: {
                        status: 'cancelled'
                    }
                });
                break
            }

            /**
             * RÚT TIỀN
             */
            case 'withdraw': {
                const { note } = req.body

                result = await financialHelpers.userWithdraw({
                    userId,
                    amount,
                    note,
                })
                break
            }

            /**
             * CHUYỂN TIỀN USER → USER
             */
            case 'transfer': {
                const { to_user_id, note } = req.body

                if (!to_user_id) {
                    return res.status(400).json({
                        code: 400,
                        msg: 'TO_USER_REQUIRED',
                    })
                }

                result = await financialHelpers.userTransfer({
                    fromUserId: userId,
                    toUserId: to_user_id,
                    amount,
                    note,
                })
                break
            }

            /**
             * USER THANH TOÁN ĐƠN HÀNG
             */
            case 'pay_company': {
                const { order_id } = req.body

                if (!order_id) {
                    return res.status(400).json({
                        code: 400,
                        msg: 'ORDER_ID_REQUIRED',
                    })
                }

                // const getOrderById = await

                result = await financialHelpers.userPayCompany({
                    userId,
                    companyId: company_id,
                    orderId: order_id,
                    amount,
                })
                break
            }

            default:
                return res.status(400).json({
                    code: 400,
                    msg: 'UNKNOWN_ACTION',
                })
        }

        return res.json({
            code: 200,
            msg: 'OK',
            data: result,
        })
    } catch (err) {
        console.error(err)

        let status = 500
        let msg = 'INTERNAL_SERVER_ERROR'

        if (err.message === 'INSUFFICIENT_BALANCE') {
            status = 400
            msg = 'INSUFFICIENT_BALANCE'
        }

        if (err.message === 'USER_NOT_FOUND') {
            status = 404
            msg = 'USER_NOT_FOUND'
        }

        return res.status(status).json({
            code: status,
            msg,
        })
    }
});

router.get('/@me/transactions', async (req, res) => {
    try {
        const userId = req.user.id

        const {
            page = 1,
            limit = 20,
            type,
            status,
        } = req.query

        const skip = (Number(page) - 1) * Number(limit)

        const where = {
            user_id: userId,
        }

        if (type) {
            where.type = type
        }

        if (status) {
            where.status = status
        }

        const [items, total] = await Promise.all([
            prisma.user_transactions.findMany({
                where,
                orderBy: {
                    created_at: 'desc',
                },
                skip,
                take: Number(limit),
                include: {
                    to_user: {
                        select: {
                            id: true,
                            username: true,
                            display_name: true,
                        },
                    },
                    to_company: {
                        select: {
                            id: true,
                            name: true,
                        },
                    },
                    order: {
                        select: {
                            id: true,
                            // total: true,
                            status: true,
                        },
                    },
                },
            }),
            prisma.user_transactions.count({ where }),
        ])

        return res.json({
            code: 200,
            msg: 'OK',
            data: {
                items,
                pagination: {
                    page: Number(page),
                    limit: Number(limit),
                    total,
                    total_pages: Math.ceil(total / limit),
                },
            },
        })
    } catch (err) {
        console.error(err)
        return res.status(500).json({
            code: 500,
            msg: 'INTERNAL_SERVER_ERROR',
        })
    }
})


module.exports = router;
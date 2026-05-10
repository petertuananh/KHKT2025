const { PrismaClient, Prisma } = require('@prisma/client')
const crypto = require('crypto')

const prisma = new PrismaClient()

function uuid() {
    return crypto.randomUUID()
}

module.exports = {
    userTopup,
    userWithdraw,
    userTransfer,
    userPayCompany,
    companyWithdraw,
    companyExpense,
    refundOrder
}

async function userTopup({ userId, amount, note }) {
    return prisma.$transaction(async (tx) => {
        const user = await tx.users.findUnique({ where: { id: userId } })
        if (!user) throw new Error('USER_NOT_FOUND')

        const utx = await tx.user_transactions.create({
            data: {
                id: uuid(),
                user_id: userId,
                amount: new Prisma.Decimal(amount),
                type: 'topup',
                status: 'finished',
                note,
            },
        })

        await tx.users.update({
            where: { id: userId },
            data: {
                balance: { increment: Number(amount) },
            },
        })

        return utx
    })
}

async function userWithdraw({ userId, amount, note }) {
    return prisma.$transaction(async (tx) => {
        const user = await tx.users.findUnique({ where: { id: userId } })
        if (!user) throw new Error('USER_NOT_FOUND')

        if (user.balance < Number(amount)) {
            throw new Error('INSUFFICIENT_BALANCE')
        }

        const utx = await tx.user_transactions.create({
            data: {
                id: uuid(),
                user_id: userId,
                amount: new Prisma.Decimal(amount),
                type: 'withdraw',
                status: 'finished',
                note,
            },
        })

        await tx.users.update({
            where: { id: userId },
            data: {
                balance: { decrement: Number(amount) },
            },
        })

        return utx
    })
}

async function userTransfer({ fromUserId, toUserId, amount, note }) {
    return prisma.$transaction(async (tx) => {
        const from = await tx.users.findUnique({ where: { id: fromUserId } })
        const to = await tx.users.findUnique({ where: { id: toUserId } })

        if (!from || !to) throw new Error('USER_NOT_FOUND')
        if (from.balance < Number(amount)) {
            throw new Error('INSUFFICIENT_BALANCE')
        }

        const utx = await tx.user_transactions.create({
            data: {
                id: uuid(),
                user_id: fromUserId,
                to_user_id: toUserId,
                amount: new Prisma.Decimal(amount),
                type: 'transfer',
                status: 'finished',
                note,
            },
        })

        await tx.users.update({
            where: { id: fromUserId },
            data: { balance: { decrement: Number(amount) } },
        })

        await tx.users.update({
            where: { id: toUserId },
            data: { balance: { increment: Number(amount) } },
        })

        return utx
    })
}

async function userPayCompany({
    userId,
    companyId,
    orderId,
    amount,
    note
}) {
    return prisma.$transaction(async (tx) => {
        const user = await tx.users.findUnique({ where: { id: userId } })
        const company = await tx.companies.findUnique({ where: { id: companyId } })

        if (!user || !company) throw new Error('NOT_FOUND')
        if (user.balance < Number(amount)) {
            throw new Error('INSUFFICIENT_BALANCE')
        }

        const userTx = await tx.user_transactions.create({
            data: {
                id: uuid(),
                user_id: userId,
                to_company_id: companyId,
                order_id: orderId,
                amount: new Prisma.Decimal(amount),
                type: 'payment',
                status: 'finished',
                note: note
            },
        })

        const companyTx = await tx.company_transactions.create({
            data: {
                id: uuid(),
                company_id: companyId,
                from_user_id: userId,
                order_id: orderId,
                amount: new Prisma.Decimal(amount),
                type: 'income',
                status: 'finished',
                note: note
            },
        })

        await tx.users.update({
            where: { id: userId },
            data: { balance: { decrement: Number(amount) } },
        })

        await tx.companies.update({
            where: { id: companyId },
            data: { balance: { increment: Number(amount) } },
        })

        return { userTx, companyTx }
    })
}

async function companyWithdraw({ companyId, amount, note }) {
    return prisma.$transaction(async (tx) => {
        const company = await tx.companies.findUnique({ where: { id: companyId } })
        if (!company) throw new Error('COMPANY_NOT_FOUND')

        if (company.balance < Number(amount)) {
            throw new Error('INSUFFICIENT_BALANCE')
        }

        const ctx = await tx.company_transactions.create({
            data: {
                id: uuid(),
                company_id: companyId,
                amount: new Prisma.Decimal(amount),
                type: 'withdraw',
                status: 'finished',
                note,
            },
        })

        await tx.companies.update({
            where: { id: companyId },
            data: { balance: { decrement: Number(amount) } },
        })

        return ctx
    })
}

async function companyExpense({
    companyId,
    amount,
    type = 'expense',
    note,
}) {
    return prisma.$transaction(async (tx) => {
        const company = await tx.companies.findUnique({ where: { id: companyId } })
        if (!company) throw new Error('COMPANY_NOT_FOUND')

        if (company.balance < Number(amount)) {
            throw new Error('INSUFFICIENT_BALANCE')
        }

        const ctx = await tx.company_transactions.create({
            data: {
                id: uuid(),
                company_id: companyId,
                amount: new Prisma.Decimal(amount),
                type,
                status: 'finished',
                note,
            },
        })

        await tx.companies.update({
            where: { id: companyId },
            data: { balance: { decrement: Number(amount) } },
        })

        return ctx
    })
}

async function refundOrder({
    orderId,
    userId,
    companyId,
    amount,
    note,
}) {
    return prisma.$transaction(async (tx) => {
        const company = await tx.companies.findUnique({ where: { id: companyId } })
        if (!company) throw new Error('COMPANY_NOT_FOUND')

        if (company.balance < Number(amount)) {
            throw new Error('COMPANY_BALANCE_NOT_ENOUGH')
        }

        const userTx = await tx.user_transactions.create({
            data: {
                id: uuid(),
                user_id: userId,
                order_id: orderId,
                amount: new Prisma.Decimal(amount),
                type: 'refund',
                status: 'finished',
                note,
            },
        })

        const companyTx = await tx.company_transactions.create({
            data: {
                id: uuid(),
                company_id: companyId,
                order_id: orderId,
                amount: new Prisma.Decimal(amount),
                type: 'refund',
                status: 'finished',
                note,
            },
        })

        await tx.users.update({
            where: { id: userId },
            data: { balance: { increment: Number(amount) } },
        })

        await tx.companies.update({
            where: { id: companyId },
            data: { balance: { decrement: Number(amount) } },
        })

        return { userTx, companyTx }
    })
}

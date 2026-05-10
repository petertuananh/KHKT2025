var PrismaClient = require("@prisma/client").PrismaClient;
var prisma = new PrismaClient();

function findProducts(filters, min_stock, max_price) {
    return prisma.Products.findMany({
        where: {
            category_id: filters.category_id || undefined,
            stock: {
                gte: min_stock || 0
            },
            price: max_price !== undefined && max_price !== null
                ? { lte: max_price/min_stock *1000}
                : undefined,
            place_id: filters.place_id || undefined
        },
        include: {
            place: true,
            files: true
        }
    });
}

module.exports = {
    findProducts: findProducts
};

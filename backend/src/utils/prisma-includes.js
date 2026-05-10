const { Prisma } = require('@prisma/client');
const dmmf = Prisma.dmmf;

// Lấy danh sách include hợp lệ từ schema
function getValidIncludesForModel(modelName) {
    const model = dmmf.datamodel.models.find(m => m.name === modelName);
    if (!model) return [];

    return model.fields
        .filter(f => f.kind === 'object')   // relation field
        .map(f => f.name);
}

module.exports = { getValidIncludesForModel };

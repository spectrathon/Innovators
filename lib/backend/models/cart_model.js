const mongoose = require('mongoose');

const cartSchema = mongoose.Schema(
    {
        uid: {
            type: String,
            required: true,
        },
        buyerUid: {
            type: String,
            required: true,
        },
        title: {
            type: String,
            required: true,
        },
        des: {
            type: String,
            required: true,
        },
        amountPerUnit: {
            type: Number,
            required: true,
        },
        numberOfUnits: {
            type: Number,
            required: true,
        },
        total: {
            type: Number,
            required: true,
        },
        urls: [
                {
                    type: String,
                    require: true,
                },
        ],
        address: {
            type: String,
            required: true,
        },
        latlng: {
            latitude: {
                type: Number,
            },
            longitude: {
                type: Number,
            },
        }
    }
);

const schema = mongoose.model('cartSchema', cartSchema);

module.exports = schema;
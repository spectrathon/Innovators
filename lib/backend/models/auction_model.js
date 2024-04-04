const mongoose = require('mongoose');

const auctionSchema = mongoose.Schema(
    {
        uid: {
            type: String,
            required: true,
        },
        aid: {
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
        startingPrice: {
            type: Number,
            required: true,
        },
        numberOfUnits: {
            type: Number,
            required: true,
        },
        currentPrice: {
            type: Number,
            required: true,
        },
        urls: [
                {
                    type: String,
                    require: true,
                },
        ],
        bidList: [
            {
                name: {
                    type: String,
                require: true,
                },
                uid: {
                    type: String,
                require: true,
                },
                bidPrice: {
                    type: Number,
                require: true,
                },
            },
    ],
    }
);

const schema = mongoose.model('auctionSchema', auctionSchema);

module.exports = schema;
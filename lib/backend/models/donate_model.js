const mongoose = require('mongoose');

const donateScheme = mongoose.Schema(
    {
        uid: {
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
        time: {
            type: String,
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

const schema = mongoose.model('donateScheme', donateScheme);

module.exports = schema;
const express = require('express');
const mongoose = require('mongoose');
const wasteModel = require('../models/waste_model');

const router = express.Router();

router.get("/search/", async (req, res) => {
    try{
        const title = req.query.title;

        let waste = await wasteModel.find({ title: { $regex: title, $options: 'i' } });
        res.json(waste);
    }catch(e){
        res.status(500).json({'error': `${e}`});
    }
});

module.exports = router;
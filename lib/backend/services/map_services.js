const express = require('express');
const wasteModel = require('../models/waste_model');

const mapRouter = express.Router();

mapRouter.get('/get-waste-location/', async (req, res) => {
    try{
        const locs = await wasteModel.find();
        res.json(locs);
    }catch(e){
        res.status(500).json({"Error" : `${e}`});
    }
});

module.exports = mapRouter;
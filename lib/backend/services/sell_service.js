const express = require('express');
const wasteModel = require('../models/waste_model');
const sell = express.Router();

sell.post('/post-waste/', async (req, res) => {
    try{
    const {title, des, amountPerUnit, numberOfUnits, total, uid, urls, address, latlng} = req.body;
    console.log(title);
    console.log(urls)
    let wm = wasteModel({title, des, amountPerUnit, numberOfUnits, total, uid, urls, address, latlng});
    wm.save();
    res.json(wm);
    }catch(e){
        console.log(`ERROR: ${e}`);
    }
});

sell.get("/get-products/", async (req, res) => {
    try{
        const prods = await wasteModel.find();
        console.log('PRODUCTS!!!');
        console.log(prods);
        res.json(prods);
    }catch(e){
        res.status(500).json({"error" : `${e}`});
    }
});

module.exports = sell;
const express = require('express');
const aucRouter = express.Router();
const aucModel = require('../models/auction_model');


aucRouter.post('/post-auction/', (req, res) => {
    try{
        const {uid, aid, numberOfUnits, currentPrice, startingPrice, title, des, urls, bidList} = req.body;
        console.log('hello');
        let am = aucModel({uid, aid, numberOfUnits, currentPrice, startingPrice, title, des, urls, bidList});
        am.save();
        console.log(bidList);
        res.json(am);
    }catch(e){
        res.status(500).json({"error": `${e}`});
    }
});

aucRouter.get("/get-auction-prods/", async (req, res) => {
    try{
        const prods = await aucModel.find();
        res.json(prods);
    }catch(e){
        res.status(500).json({"error": `${e}`});
    }
});

module.exports = aucRouter;
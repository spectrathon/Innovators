const express = require('express');
const cartRouter = express.Router();
const cartModel = require('../models/cart_model');
const auth = require('../middleware/auth');

cartRouter.post('/add-to-cart/', async (req, res) => {
    try{
    const {title, des, amountPerUnit, numberOfUnits, total, uid, urls, address, latlng, userId, buyerUid} = req.body;
    const id = req.userId;
    let cm = cartModel({title, des, amountPerUnit, numberOfUnits, total, uid, urls, address, latlng, buyerUid});
    cm.save();
    res.json(cm);
    }catch(e){
        console.log(`ERROR: ${e}`);
    }
});

cartRouter.post('/get-cart-products/', async (req, res) => {
    try{
    const {buyerUid} = req.body;
    const prods = await cartModel.find({buyerUid});
    res.json(prods);
    }catch(e){
        console.log(`ERROR: ${e}`);
        res.status(500).json({"error" : `${e}`});
    }
});

cartRouter.post('/check-cart/', async (req, res) => {
    try{
    const {uid, title, des} = req.body;
    const prods = await cartModel.find({buyerUid: uid});
    for(const pro of prods){
        if(pro.title == title && pro.des == des)
        return res.json(true);
    }
    return res.json(false);
    // if(prods){
    //     const product = await prods.find({title});
    //     if(product)
    //     return res.json(true);
    // }
    // res.json(false);
    }catch(e){
        console.log(`ERROR: ${e}`);
        res.status(500).json({"error" : `${e}`});
    }
});

module.exports = cartRouter;
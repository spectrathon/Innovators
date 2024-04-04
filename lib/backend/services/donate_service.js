const express = require('express');
const mongoose = require('mongoose');

const donateRouter = express.Router();

const donateModel = require('../models/donate_model');

donateRouter.post('/post-donate/', async (req, res) => {
    try{
        const {uid, urls, latlng, des, title, address, time} = req.body;
        let dm = donateModel({uid, urls, des, title, address, time, latlng});

        await dm.save();
        res.json(dm);
    }catch(e){
        res.status(500).json({"sderror": `${e}`});
    }
});

donateRouter.get('/get-donate-products/', async (req, res) => {
    try{
        let dmList = await donateModel.find();
        console.log(dmList);
        console.log('hello world!');
        res.json(dmList);
    }catch(e){
        res.status(500).json({"error": `${e}`});
    }
});

module.exports = donateRouter;
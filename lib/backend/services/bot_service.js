const { GoogleGenerativeAI } = require("@google/generative-ai");
const { json } = require("body-parser");
require('dotenv').config();
const genAI = new GoogleGenerativeAI('AIzaSyDUI83mOXOlbRa4a3k4xuzo8FVErnmDWQM');

const model = genAI.getGenerativeModel({ model: "gemini-pro"});
const express = require('express');

const botRouter = express.Router();


botRouter.post('/prompt/', async (req, res) => {
    try{
        const {msg}  = req.body;
        const model = genAI.getGenerativeModel({ model: "gemini-pro"});
  
        const prompt = msg;
      
        const result = await model.generateContent(prompt);
        const response = await result.response;
        const text = response.text();
        console.log(text);
        res.json(text);
    }catch(e){
        return res.json({"error" : `${e}`});
    }
});


module.exports = botRouter;
const { application } = require("express");
const express = require("express");
const mongoose = require("mongoose");
const userModel = require("../models/user_model");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");

const authRouter = express.Router();

authRouter.post("/sign-up/", async (req, res) => {
    try{
        const {name, email, password, phone, uid} = req.body;

        const userExists = await userModel.findOne({email});
        if(userExists){
            return res.status(400).json({"msg" : "User with this email already exists!"});
        }
        const hashedPass = await bcrypt.hash(password, 8);
        let um = userModel({name, email, password: hashedPass, phone, uid});

        const token = await jwt.sign({id: um._id}, "passwordKey");
        um.save();
        res.json({token, ...um._doc});

    }catch(e){
        res.status(500).json({"Error: " : `${e.message}`});
    }
});

authRouter.post('/sign-in/', async (req, res) => {
    try{
        const {email, password} = req.body;
        const user = await userModel.findOne({email});

        if(!user){
            return res.status(400).json({"msg" : "Invalid email!"});
        }

        const isPassValid = await bcrypt.compare(password, user.password);
        if(!isPassValid){
            return res.status(400).json({"msg" : "Wrong password!"});
        }

        res.json(user);

    }catch(e){
        res.status(500).json({"Error: " : `${e}`});
    }
});

module.exports = authRouter;
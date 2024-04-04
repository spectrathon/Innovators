const express = require('express');
const userRouter = express();
const userModel = require('../models/user_model');
const auth = require('../middleware/auth');

userRouter.get('/get-user/' , auth, async (req, res) => {
    try{
        const token = req.token;
        console.log(req.token);
        const user = await userModel.findById(req.userId);

        console.log(user);
        if(!user){
            return res.status(400).json({"msg" : 'No user found!'});
        }
        res.json({...user._doc, token: req.token});
    } 
    catch(e){
        return res.status(500).json({"msg" : `${e}`});
    }
});
module.exports = userRouter;
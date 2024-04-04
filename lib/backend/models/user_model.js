const mongoose = require("mongoose");

const userSchema = mongoose.Schema(
    {
       name: {
        type: String,
        required: true,
        trim: true
       },
       uid: {
        type: String,
        required: true,
        trim: true,
       },
       role: {
        type: String,
        default: "user",
        trim: true,
       },
       email: {
        type: String,
        required: true,
        trim: true,
       },
       password: {
        type: String,
        required: true,
        trim: true,
       },
       phone: {
        type: String,
        default: "",
        trim: true,
       }
    }
);

authModel = mongoose.model("model", userSchema);

module.exports = authModel;
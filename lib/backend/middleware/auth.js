const jwt = require("jsonwebtoken");

const auth = async (req, res, next) => {

    const token = req.header("x-auth-token");
    if(!token)
    return res.status(400).json({'msg' : 'No token found'});

    const verified = jwt.verify(token, "passwordKey");
    if(!verified)
    return res.status(400).json({'msg' : 'Access denied!'});

    req.userId = verified.id;
    req.token = token;
    next();
}

module.exports = auth;
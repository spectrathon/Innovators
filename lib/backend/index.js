const express = require("express");
const mongo = require("mongoose");
const auth = require("./services/auth_service");
const userService = require('./services/user_service');
const sellRouter = require('./services/sell_service');
const mapRouter = require('./services/map_services');
const cartRouter = require('./services/cart_service');
const aucRouter = require('./services/auction_service');
const searchRouter = require('./services/search_service');
const bodyParser = require('body-parser');
const {createServer} = require('http');
const {Server} = require('socket.io');
const donateRouter = require('./services/donate_service');
const auctionModel = require('./models/auction_model');
const botRouter = require('./services/bot_service');

const PORT = 3000;
// const serverIp = "0.0.0.0";
const serverIp = "172.26.17.164";

const app = express();
app.use(express.json());
app.use(sellRouter);
app.use(searchRouter);
app.use(donateRouter);
app.use(auth);
app.use(userService);
app.use(mapRouter);
app.use(botRouter);
app.use(cartRouter);
app.use(aucRouter);
app.use(bodyParser.json());

const httpServer = createServer(app);
const io = new Server(httpServer);

const mongoKey = "mongodb+srv://rounakpro18:ronypro18@cluster0.2gjqiyf.mongodb.net/";

io.on('connection', (socket) => {
    console.log('backend connected!');
    socket.on('auction', (auctionId) => {
        console.log(`${auctionId}`);
        // console.log(`postId: ${postId}`);
        socket.join(auctionId);
        socket.on('bid', async (data)=>{
            console.log(data);
            const auc = await auctionModel.findOne({aid: auctionId});
            console.log(auc.bidList);
            auc.bidList.push(data);
            // let uniSet = new Set(auc.bidList);
            // auc.bidList = Array.from(uniSet);
            auc.currentPrice = data.bidPrice;
            //auc.bidList[0] = data;
            auc.save();
            io.to(auctionId).emit('getBid', data);
        //     console.log(updateLoc);
        //     io.to(postId).emit('getLoc', updateLoc);
        });
    });
    socket.on('disconnect', () => {
        console.log('User disconnected:', socket.id);
      });
});


httpServer.listen(PORT, serverIp, ()=>{
    console.log('connected!');
});

mongo.connect(mongoKey).then(() => {
    console.log("Database Connected!");
}).catch((e) => {
    console.log(`ERROR: ${e}`);
});
import 'bid_model.dart';

class AuctionModel{
  String title, des, uid, aid;
  int numberOfUnits, startingPrice, currentPrice;
  List<dynamic> urls;
  List bidList;

  AuctionModel({
    required this.title,
    required this.uid,
    required this.aid,
    required this.startingPrice,
    required this.des,
    required this.numberOfUnits,
    required this.currentPrice,
    required this.urls,
    required this.bidList,
  });
}
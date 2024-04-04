import 'package:euse/models/auction_model.dart';
import 'package:euse/models/donate_model.dart';
import 'package:euse/models/user_model.dart';
import 'package:euse/providers/user_provider.dart';
import 'package:euse/screens/login_screen.dart';
import 'package:euse/screens/view_auction_screen.dart';
import 'package:euse/screens/view_donate_product.dart';
import 'package:euse/screens/view_product_screen.dart';
import 'package:euse/services/auction_service.dart';
import 'package:euse/services/donate_service.dart';
import 'package:euse/services/sell_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/waste_model.dart';
import '../providers/score_pro.dart';
import '../widgets/auction_product_card.dart';
import '../widgets/donate_product_card.dart';
import '../widgets/product_card.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with SingleTickerProviderStateMixin{

  late TabController tabController;

  int soldQuantity = 8;
  int donatedQuantity = 16;
  int auctionedQuantity = 2;
  List<WasteModel> wmList = [];
  List<DonateModel> dmList = [];
  List<AuctionModel> amList = [];
  bool isLoading = false;
  UserModel? um;
  String a =
  '''
  ┌─────────────────────────────────────────────────────────┐
  │ A new version of Flutter is available!                  │
  │                                                         │
  │ To update to the latest version, run "flutter upgrade". │
  └─────────────────────────────────────────────────────────┘
  ''';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(a);
    tabController = TabController(length: 3, vsync: this);
    um = Provider.of<UserPro>(context, listen: false).um;
    print("ID: ${um!.uid}");
    getSold();
  }

  getSold() async {
    setState(() {
      isLoading = true;
    });
    UserModel um = Provider.of<UserPro>(context, listen: false).um;

    wmList = await SellService(context: context).getProds();
    // soldQuantity = wmList.length;
    dmList = await DonateService(context: context).getDonateProds();
    // dmList.removeWhere((element) => element.uid != um.uid);

    donatedQuantity = dmList.length;
    amList = await AuctionService(context: context).getProds();
    // amList.removeWhere((element) => element.uid != um.uid);

    auctionedQuantity = amList.length;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }, child: Icon(Icons.logout, color: Colors.white,),),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: size.height * 0.1,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person, color: Colors.grey, size: 40,),
                        ),
                        SizedBox(width: 16.0,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${um == null ? "Rounak Naik" : um!.name}', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18),),
                            Text('${um == null ? "User" : um!.role}'),
                          ],
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  Image.asset('assets/coins.png', height: 24, width: 24,),
                  SizedBox(width: 8.0,),
                  Text('${Provider.of<ScorePro>(context).score}', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),),
                  SizedBox(width: 8.0,),
                ],
              ),
              SizedBox(height: 8.0,),
              Row(
                children: [
                  Icon(Icons.email, color: Colors.black.withOpacity(0.5),),
                  SizedBox(width: 8.0,),
                  Text('${um == null ? "rounak@gmail.com" : um!.email}'),
                ],
              ),
              SizedBox(height: 8.0,),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.black.withOpacity(0.5),),
                  SizedBox(width: 8.0,),
                  Text('${um == null || um!.phone.isEmpty ? "9322942635" : um!.phone}'),
                ],
              ),
              SizedBox(height: 16.0,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Sold', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),),
                            SizedBox(height: 4.0,),
                            Text('${soldQuantity}'),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12,),),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Donated', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),),
                            SizedBox(height: 4.0,),
                            Text('${donatedQuantity}'),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12,),),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Auctioned', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),),
                            SizedBox(height: 4.0,),
                            Text('${auctionedQuantity}'),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12,),),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 8.0,),
              TabBar(tabs: [
                Tab(text: 'Sold[$soldQuantity]',),
                Tab(text: 'Donated[$donatedQuantity]',),
                Tab(text: 'Auctioned[$auctionedQuantity]',),
              ], controller: tabController,),
              Expanded(
                child: TabBarView(children: [
                  Container(
                    child: ListView(
                      children: wmList
                          .map(
                            (e) => InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProduct(wm: e))),
                          child: Container(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ProductCard(
                                wm: e,
                                height: size.height * 0.1,
                                width: size.width * 0.5,
                                titleFontSize: 16,
                                priceFontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                  Container(
                    child: ListView(
                      children: dmList
                          .map(
                            (e) => InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDonateProduct(dm: e))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 200,
                              child: DonateProductCard(
                                dm: e,
                                height: size.height * 0.1,
                                width: size.width * 0.5,
                                titleFontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                  Container(
                    child: ListView(
                      children: amList
                          .map(
                            (e) => InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAuctionScreen(item: e))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 200,
                              child: AuctionProductCard(
                                am: e,
                                height: size.height * 0.1,
                                width: size.width * 0.5,
                                titleFontSize: 16,
                                priceFontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                ], controller: tabController,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

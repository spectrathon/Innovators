import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:euse/constanst.dart';
import 'package:euse/models/user_model.dart';
import 'package:euse/models/waste_model.dart';
import 'package:euse/providers/user_provider.dart';
import 'package:euse/screens/test_screen.dart';
import 'package:euse/screens/view_auction_screen.dart';
import 'package:euse/screens/view_donate_product.dart';
import 'package:euse/screens/view_donate_screen.dart';
import 'package:euse/screens/view_product_screen.dart';
import 'package:euse/screens/sell_screen.dart';
import 'package:euse/services/auction_service.dart';
import 'package:euse/services/donate_service.dart';
import 'package:euse/services/sell_service.dart';
import 'package:euse/widgets/auction_product_card.dart';
import 'package:euse/widgets/carousel_card.dart';
import 'package:euse/widgets/custom_card.dart';
import 'package:euse/widgets/donate_product_card.dart';
import 'package:euse/widgets/product_card.dart';
import 'package:euse/widgets/search_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/auction_model.dart';
import '../models/donate_model.dart';
import '../services/bot_service.dart';
import 'buy_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<WasteModel> wmList = [];
  List<AuctionModel> amList = [];
  List<DonateModel> dmList = [];
  UserModel? um;
  List<dynamic> ytList = [
    {
      'link': 'https://www.youtube.com/watch?v=-uyIzKIw0xY',
      'title': 'How e-waste is harming our world',
    },
    {
      'link': 'https://www.youtube.com/watch?v=ApdkhWd7SfQ',
      'title': 'How To Recycle E-Waste | Wilma Rodrigues | #OneForChange',
    },{
      'link': 'https://www.youtube.com/watch?v=CmP67zq5hfo',
      'title': 'Digital India : e-Waste Management',
    },

  ];
  bool ytLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProds();
    // getYtLinks();
  }

  getYtLinks() async {
    setState(() {
      ytLoading = true;
    });

    String prompt =
    """
   Suggest 3 Youtube videos link code which are related to E-Waste and can educate/help users.
The response HAS TO BE in JSON STRING FORMAT
ONLY RETURN A JSON STRING at the end
NO OTHER CHARACTERS OR TOKENS, ONLY A JSON STRING

The JSON object template is given below:
    [
      {
        "link": "https://www.youtube.com/xyz",
        "title": "Video title",
      },
      {
        "link": "https://www.youtube.com/watch?v=xyz",
        "title": "Video title",
      },{
        "link": "https://www.youtube.com/watch?v=xyz",
        "title": "Youtube video title",
      },
    ]
    
I REPEAT, ONLY RETURN A JSON STRING NO OTHER CHARACTERS OR TOKENS THE RESPONSE, RESPOND IN THE FORMAT OF THE TEMPLATE GIVEN.
Please give valid youtube video links
    """;
    String text = await BotService(context: context).prompt(prompt);
    try {
      setState(() {
        ytList = jsonDecode(text.trim());
      });
      print("Youtube\n$ytList");
    }catch(e){
      print(e);
      List list = text.split('json');
      String fin = list.last.split('`').first;
      ytList = jsonDecode(fin.trim());
      print(ytList);
    }
    setState(() {
      ytLoading = false;
    });
  }


  launchUrl(String code) async {
    try {
      // if (Platform) {
      if (await canLaunch(
          '$code')) {
        await launch('$code',
            forceSafariVC: false);
      } else {
        if (await canLaunch(
            '$code')) {
          await launch(
              '$code');
        } else {
          throw 'Could not launch $code';
        }
      }
    }catch(e){
      print('HELLO');
      ytList = [
        {
          'link': 'https://www.youtube.com/watch?v=-uyIzKIw0xY',
          'title': 'How e-waste is harming our world',
        },
        {
          'link': 'https://www.youtube.com/watch?v=ApdkhWd7SfQ',
          'title': 'How To Recycle E-Waste | Wilma Rodrigues | #OneForChange',
        },{
          'link': 'https://www.youtube.com/watch?v=CmP67zq5hfo',
          'title': 'Digital India : e-Waste Management',
        },

      ];
      setState(() {

      });
    }
  }
    // } else {
    //   const url = 'https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw';
    //   if (await canLaunch(url)) {
    //     await launch(url);
    //   } else {
    //     throw 'Could not launch $url';
    //   }
    // }

  getProds() async {
    wmList = await SellService(context: context).getProds();
    amList = await AuctionService(context: context).getProds();
    dmList = await DonateService(context: context).getDonateProds();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    um = Provider.of<UserPro>(context).um;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => TestScreen()));
      //   },
      //   child: Icon(Icons.add, color: Colors.white,),
      // ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hey, ${um!.name}!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),),
                      SizedBox(height: 4.0,),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: kGreyText, size: 20,),
                          SizedBox(width: 4.0,),
                          Text('Goa Engineering College, Ponda', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kGreyText),),
                        ],
                      )
                    ],
                  ),
                  Spacer(),
                  LottieBuilder.asset('anim/recycle.json', height: 70, width: 70,),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchContainer(
                  onChanged: (value){

                  },
                )
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    'E-Waste sale near you',
                    style: kSmallText,
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BuyScreen())),
                    child: Text(
                      'See all',
                      style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: size.height * 0.18,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: wmList
                      .map(
                        (e) => InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProduct(wm: e))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ProductCard(
                              wm: e,
                              height: size.height * 0.13,
                              width: size.width * 0.5,
                              titleFontSize: 16,
                              priceFontSize: 15,
                            ),
                          ),
                        ),
                      ).toList(),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Below are some products available to bid',
                style: kSmallText,
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: size.height * 0.2,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: amList
                      .map(
                        (e) => InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAuctionScreen(item: e))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AuctionProductCard(
                          am: e,
                          height: size.height * 0.1,
                          width: size.width * 0.5,
                          titleFontSize: 16,
                          priceFontSize: 15,
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Below are some products available for donation',
                style: kSmallText,
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: size.height * 0.2,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: dmList
                      .map(
                        (e) => InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDonateProduct(dm: e))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DonateProductCard(
                          dm: e,
                          height: size.height * 0.1,
                          width: size.width * 0.5,
                          titleFontSize: 16,
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Below are some videos that might be useful',
                style: kSmallText,
              ),
              SizedBox(
                height: 8,
              ),
              !ytLoading ? Container(
                height: size.height * 0.3,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ytList.map((e){

                    return InkWell(child: YtCard(code: e['link'], title: e['title']), onTap: (){
                      try {
                        launchUrl(e['link']);
                      }catch(e){
                        print('HELLOOO2');
                      }
                    },);
                  }).toList()
                ),
              ): Container(),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 16,
              ),
              Text('Below are some recent news about Global Waste!', style: kSmallText,),
              SizedBox(
                height: 8,
              ),
              CarouselCard(items: [
                Image.asset('assets/dum.png', fit: BoxFit.cover,),
                Image.asset('assets/dum2.png', fit: BoxFit.cover,),
                Image.asset('assets/dum3.png', fit: BoxFit.cover,),
                Container(
                  color: Colors.pink,
                ),
              ], ),
            ],
          ),
        ),
      )),
    );
  }
}

class YtCard extends StatelessWidget {
  YtCard({required this.code, required this.title});
  String code, title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                width: 200,
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), image: DecorationImage(image: NetworkImage('https://img.youtube.com/vi/${code.split('v=').last}/0.jpg',), fit: BoxFit.cover),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('$title', overflow: TextOverflow.ellipsis, maxLines: 1,),
            ),
          ],
        ),
      ),
    );
  }
}

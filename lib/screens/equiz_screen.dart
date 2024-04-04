import 'dart:async';
import 'dart:convert';

import 'package:euse/constanst.dart';
import 'package:euse/screens/nav_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/quiz_model.dart';
import '../providers/score_pro.dart';
import '../services/bot_service.dart';

class EQuizScreen extends StatefulWidget {
  const EQuizScreen({super.key});

  @override
  State<EQuizScreen> createState() => _EQuizScreenState();
}

class _EQuizScreenState extends State<EQuizScreen> {
  List<QuizModel> qList = [];
  Map jsonQuestions = kQuestionJson;
  int time = 30;
  late Timer _timer;
  bool answered = false;
  bool opt1 = false, opt2 = false, opt3 = false, opt4 = false;
  int selectedOpt = 0;
  int pageIndex = 0;
  bool showAns = false;
  int score = 0;
  bool loading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  convertJsonToModel(){
    List<dynamic> questions = jsonQuestions['questions'];

    // Convert JSON data to QuizModel objects
    qList.clear();
    for (var question in questions) {
      qList.add(QuizModel.fromJson(question));
    }
    setState(() {

    });
  }

  getQuestionsFromAi() async {
    setState(() {
      loading = true;
    });
    String prompt = '''
    Generate 3 questions related to E-Waste in JSON. Each question should have 4 options, 1 correctAnswer and explanation.
    The final response should be STRICTLY IN JSON STRING format.
    Example of json format:
{
  "questions": [
    {
      "question": "What does the term 'e-waste' refer to?",
      "options": {
        "option1": "Electronic waste",
        "option2": "Electrical waste",
        "option3": "Environmental waste",
        "option4": "Ecological waste"
      },
      "correctAnswer": "Electronic waste",
      "explanation": "E-waste refers to discarded electronic devices, such as computers, smartphones, and TVs, that have reached the end of their useful life."
    },
    {
      "question": "Which of the following electronic devices can be considered e-waste?",
      "options": {
        "option1": "Microwave oven",
        "option2": "Refrigerator",
        "option3": "Smartphone",
        "option4": "All of the above"
      },
      "correctAnswer": "All of the above",
      "explanation": "All of the listed electronic devices can be considered e-waste when they are no longer functional or are discarded by the owner."
    },
    .
    .
    .
  ]
}
The response should be in JSON STRING.
    ''';
    String text = await BotService(context: context).prompt(prompt);
    print(text);
    try {
      jsonQuestions = jsonDecode(text);
      List list = jsonQuestions['questions'];
      list.add({
        "question": "over",
        "options": {
          "option1": "Donate or sell old electronics",
          "option2": "Repair and upgrade existing devices",
          "option3": "Recycle electronics at designated facilities",
          "option4": "All of the above"
        },
        "correctAnswer": "All of the above",
        "explanation": "Consumers can reduce e-waste generation by donating or selling old electronics, repairing and upgrading existing devices to extend their lifespan, and recycling electronics at designated facilities to ensure proper disposal and resource recovery."
      });
      jsonQuestions['questions'] = list;
    }catch(e){
      List list0 = text!.split('json');
      String fin = list0.last.split('`').first;
      jsonQuestions = jsonDecode(fin.trim());
      List list = jsonQuestions['questions'];
      list.add({
        "question": "over",
        "options": {
          "option1": "Donate or sell old electronics",
          "option2": "Repair and upgrade existing devices",
          "option3": "Recycle electronics at designated facilities",
          "option4": "All of the above"
        },
        "correctAnswer": "All of the above",
        "explanation": "Consumers can reduce e-waste generation by donating or selling old electronics, repairing and upgrading existing devices to extend their lifespan, and recycling electronics at designated facilities to ensure proper disposal and resource recovery."
      });
      jsonQuestions['questions'] = list;
      print(e);
    }
    convertJsonToModel();
    startTimer();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuestionsFromAi();

  }

  startTimer() async {

    _timer = await Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        time--;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if(time <= 0){
      setState(() {
        answered = true;
        _timer.cancel();
      });
    }

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        actions: [
          Text('${score}', style: TextStyle(fontSize: 24, color: Colors.white),),
          SizedBox(width: 16,),
        ],
        title: Text(
          'E-QUIZ',
          style: TextStyle(color: Colors.white),
        ),
        forceMaterialTransparency: true,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
          child: loading? Center(
            child: LottieBuilder.asset('anim/recycle.json', height: size.height * 0.3,),
          ) : Column(
            children: [
              Expanded(
                child: PageView(
                        children: qList.map((e) {
                return e.question == 'over' ? Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('YOUR SCORE IS \n${score}', style: TextStyle(fontSize: 32, color: Colors.white), textAlign: TextAlign.center,),
                        SizedBox(height: 16.0,),
                        ElevatedButton(onPressed: (){
                          Provider.of<ScorePro>(context, listen: false).setScore(score);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reward Claimed!',), backgroundColor: kPrimaryColor,));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => NavScreen()));;
                          Navigator.pop(context);
                        }, child: Text('CLAIM REWARD')),
                      ],
                    ),
                  ),
                ): Column(
                    mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    '${e.question}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.acme(color: Colors.white, fontSize: 22),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        child: Center(
                          child: Row(
                            children: [
                              LottieBuilder.asset('anim/timer.json', height: 70,),
                              Center(
                                child: Text(
                                  '${time}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.acme(color: time < 10 ? Colors.red.withOpacity(0.8) : (time <= 15 ? Colors.deepOrange.withOpacity(0.8) : Colors.white), fontSize: 40, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width: 30,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: size.height * 0.3,
                        child: ListView(
                          children: [
                            InkWell(
                              onTap: (){
                                // if(e.options[0] == e.correctAnswer){
                                  setState(() {
                                    showAns = true;
                                    selectedOpt = 1;
                                    opt1 = true;
                                    opt2 = false;
                                    opt3 = false;
                                    opt4 = false;
                                    if(e.correctAnswer == e.options[0])
                                      setState(() {
                                        score+=10;
                                      });
                                  });
                                // }
                              },
                              child: Card(
                                color: (selectedOpt == 1) ? (e.correctAnswer == e.options[0] ? Colors.blueAccent : Colors.redAccent) : Colors.white,
                                child: Container(
                                  height: 50,
                                  child: Center(child: Text('${e.options[0]}', style: TextStyle(color: selectedOpt == 1 ? Colors.white: Colors.black),)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            InkWell(
                              onTap: (){
                                // if(e.options[1] == e.correctAnswer){
                                  setState(() {
                                    selectedOpt = 2;
                                    showAns = true;

                                    opt2 = true;
                                    opt1 = false;
                                    opt3 = false;
                                    opt4 = false;
                                    if(e.correctAnswer == e.options[1])
                                      setState(() {
                                        score+=10;
                                      });
                                  });
                                // }
                              },
                              child: Card(
                                color: (selectedOpt == 2) ? (e.correctAnswer == e.options[1] ? Colors.blueAccent : Colors.redAccent) : Colors.white,
                                child: Container(
                                  height: 50,
                                  child: Center(child: Text('${e.options[1]}', style: TextStyle(color: selectedOpt == 2 ? Colors.white: Colors.black),)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            InkWell(

                              onTap: (){
                                // if(e.options[2] == e.correctAnswer){
                                  setState(() {
                                    if(e.correctAnswer == e.options[2])
                                      setState(() {
                                        score+=10;
                                      });
                                    showAns = true;

                                    selectedOpt = 3;
                                    opt3 = true;
                                    opt1 = false;
                                    opt2 = false;
                                    opt4 = false;
                                  });
                                // }
                              },
                              child: Card(
                                color: (selectedOpt == 3) ? (e.correctAnswer == e.options[2] ? Colors.blueAccent : Colors.redAccent) : Colors.white,

                                child: Container(
                                  height: 50,
                                  child: Center(child: Text('${e.options[2]}', style: TextStyle(color: selectedOpt == 3 ? Colors.white: Colors.black),)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            InkWell(
                              onTap: (){
                                // if(e.options[3] == e.correctAnswer){
                                  setState(() {
                                    if(e.correctAnswer == e.options[3])
                                      setState(() {
                                        score+=10;
                                      });
                                    showAns = true;

                                    selectedOpt = 4;
                                    opt4 = true;
                                    opt1 = false;
                                    opt2 = false;
                                    opt3 = false;
                                  });
                                // }
                              },
                              child: Card(
                                color: (selectedOpt == 4) ? (e.correctAnswer == e.options[3] ? Colors.blueAccent : Colors.redAccent) : Colors.white,
                                child: Container(
                                  height: 50,
                                  child: Center(child: Text('${e.options[3]}', style: TextStyle(color: selectedOpt == 4 ? Colors.white: Colors.black),)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Visibility(
                    visible: selectedOpt != 0,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('ANSWER: ${e.correctAnswer}\n\nEXPLANATION: ${e.explanation.toString()}', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                ]);
                        }).toList(),
                  onPageChanged: (index){
                          if(index == 10){
                            Provider.of<ScorePro>(context, listen: false).setScore(score);
                          }
                    setState(() {
                      pageIndex = index+1;
                      _timer.cancel();
                      time = 30;
                      startTimer();
                      selectedOpt = 0;
                      opt1 = opt2 = opt3 = opt4 = false;
                    });
                  },
                      ),
              ),
              Visibility(visible: pageIndex != 11,child: Text('Question $pageIndex out of ${qList.length - 1}', style: TextStyle(color: Colors.white),)),
            ],
          ),),
    );
  }
}

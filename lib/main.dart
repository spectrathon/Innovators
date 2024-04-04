import 'package:euse/constanst.dart';
import 'package:euse/providers/score_pro.dart';
import 'package:euse/providers/user_provider.dart';
import 'package:euse/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: 'AIzaSyDUI83mOXOlbRa4a3k4xuzo8FVErnmDWQM');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserPro()),
    ChangeNotifierProvider(create: (context) => ScorePro()),
  ],
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      //   useMaterial3: false,
      // ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: kPrimaryColor)
      ),
      home: WelcomeScreen(),
    );
  }
}
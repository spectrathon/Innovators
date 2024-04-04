import 'package:euse/constanst.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor.withOpacity(0.4), boxShadow: [BoxShadow(blurRadius: 100, spreadRadius: 20, offset: Offset(0, 20), color: kPrimaryColor.withOpacity(0.4))]),
              ),
            ),
            Container(
              decoration: BoxDecoration(boxShadow: [BoxShadow(blurRadius: 100, spreadRadius: 20, offset: Offset(0, 20), color: Colors.black.withOpacity(0.3))]),
            )
          ],
        ),
      ),
    );
  }
}

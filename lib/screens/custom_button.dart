import 'package:flutter/material.dart';
import 'package:euse/constanst.dart';

class CustomButton extends StatelessWidget {
  CustomButton({required this.text, required this.onTap, this.isLoading = false, this.loadingWidget = null, this.fontSize= 16, this.height = 54});
  String text;
  Function onTap;
  bool isLoading;
  var loadingWidget;
  double fontSize;
  double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(16)),
        child: Center(child: isLoading ? loadingWidget : Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: fontSize),)),
      ),
    );
  }
}

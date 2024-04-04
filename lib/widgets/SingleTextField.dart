import 'package:flutter/material.dart';
import 'package:euse/constanst.dart';

class SingleTextField extends StatefulWidget {
  SingleTextField({
    required this.size,
    required this.hintText,
    required this.onChanged,
    this.icon,
    this.secured = false,
    this.suffixIcon,
    this.value = '',
    this.type = TextInputType.text,
    this.controller,
    this.generate = null,
    this.aiText = null
  });

  final icon, suffixIcon, secured;
  final Size size;
  String hintText, value;
  Function onChanged;
  TextEditingController? controller;
  TextInputType type;
  final aiText;
  Function(String)? generate;

  @override
  State<SingleTextField> createState() => _SingleTextFieldState();
}

class _SingleTextFieldState extends State<SingleTextField> {

  TextEditingController cont = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.controller == null) {
      cont.text = widget.value ?? '';
    }
    else{
      print('reached');
      cont = widget.controller!;
      cont.text = widget.value ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.hintText.contains('Total')){
      cont = widget.controller!;
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: TextFormField(
        keyboardType: widget.type,
        controller: cont,
        onChanged: (value) {
          widget.onChanged(value);
        },
        maxLines: widget.secured ? 1 : null,
        obscureText: widget.secured,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: widget.icon,
          suffixIcon: widget.suffixIcon,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(
                12,
              ),),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
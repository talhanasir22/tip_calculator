import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldContainer extends StatelessWidget{
  const TextFieldContainer({super.key, required this.text, required this.controller, required this.height, required this.width});
  final String text;
  final TextEditingController controller;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: const Color(0xFF0d3b79),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(text,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
          SizedBox(
              width: 200,
              child: TextField(
                maxLength: 15,
                style: TextStyle(fontSize: 20,color: Colors.white),
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(),
                inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),],
                decoration: InputDecoration(counterText: '' , hintText: '0.0' , hintStyle: TextStyle(color: Colors.white60)
                ),
              )),
        ],
      ),
    );

  }

}
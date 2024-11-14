import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget{
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage(title: 'Tip Calculator',)));
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: const Color(0xFF0d3b79),
      child: Image.asset('assets/Images/Tip & Split.png',
      ),
    );
  }
}
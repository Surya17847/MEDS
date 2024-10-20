import 'dart:async';

import 'package:flutter/material.dart';

import 'home.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
  void initState() {
   Timer(Duration(seconds: 2), (){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return EntryTypeSelection();
    }));
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    body:Container(
      color:Color(0xFFC2005D), 
      child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/meds_start.png', height: 100, width: 100),
            Text("MEDS",style:TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color:Colors.white
            )),
              Text("Medicine Exchange and Distribution System",style:TextStyle(
          fontSize: 14,
          // fontWeight: FontWeight.w800,
          color:Colors.white
        )),
          ],
        ),
      
      )
    )
   );
  }
}
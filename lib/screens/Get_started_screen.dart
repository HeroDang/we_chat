import 'dart:developer';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/auth/login_screen.dart';
import 'package:we_chat/screens/main_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreen();
}

class _GetStartedScreen extends State<GetStartedScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 9900), () {
    //   //exit full-screen
    //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //       systemNavigationBarColor: Colors.white,
    //       statusBarColor: Colors.white));
    //   // //navigator to login screen
    //   //   Navigator.pushReplacement(
    //   //       context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    // });
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      body: Stack(
     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Positioned(
            top: mq.height * .12,
            width: mq.width,
            child: Text(
              'Get Closer To ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize: 22, color: Colors.black87, letterSpacing: .5),
            )),
          Positioned(
            top: mq.height * .15,
            width: mq.width,
            child: Text(
              'EveryOne',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize: 22, color: Colors.black87, letterSpacing: .5),
            )),
             Positioned(
            top: mq.height * .22,
            width: mq.width,
            child: Text(
              'Helps you to contact everyone',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: Colors.black87, letterSpacing: .5),
            )),
            Positioned(
            top: mq.height * .24,
            width: mq.width,
            child: Text(
              ' with just easy way',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: Colors.black87, letterSpacing: .5),
            )),
          Positioned(
            top: mq.height * .15,
            right: mq.width * .03,
            width: mq.width * .9,
            height: mq.height * .7,
            child: Image.asset('images/get_started_screen.png')),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .1,
            width: mq.width * .8,
            height: mq.height * .08,
          child: ElevatedButton(
          child: Text('GET STARTED',textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize: 17, color: Colors.white, letterSpacing: .8),),
          onPressed: (){
            if (APIs.auth.currentUser != null) {
        log('\nUser: ${APIs.auth.currentUser}');
        APIs.getSelfInfo().then((value) {
          //navigator to home screen
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const MainScreen()));
        });
      } else {
        //navigator to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
          },
           style: ElevatedButton.styleFrom(
            // foregroundColor: Color(0xFF5E88DA), 
            backgroundColor: Color(0xFF5E88DA), padding: EdgeInsets.all(20.0),
            fixedSize: Size(300,80),
            shape: StadiumBorder(),
            shadowColor: Color(0xFF5E88DA),
            elevation: 15,
           )
        ),
        )
        ],
      ),
    );
  }
 }

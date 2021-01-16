import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Authentication/authenication.dart';
import 'Config/config.dart';



Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences= await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'e-Shop',color: Colors.white,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: SplashScreen()
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
{

  @override
  void initState() {
    super.initState();
    displaySplash();
  }
  displaySplash(){
    Timer(Duration(seconds: 1), () async {
      if(await EcommerceApp.auth.currentUser() !=null){
        Route route = MaterialPageRoute(builder: (_) => MyHomeScreen());
        Navigator.pushReplacement(context, route);
      }
      else
      {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(colors: [Colors.white,Colors.white],
              begin: const FractionalOffset(0.0, 0.0),end:const FractionalOffset(0.0, 0.0),
              stops: [0.0,1.0],tileMode: TileMode.clamp),





        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 10,),
              Text("Fitness App",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
              Image.asset("assets/meditation_bg.png"),
              SizedBox(height: 10,),
              Text("Your Personal Trainer",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}

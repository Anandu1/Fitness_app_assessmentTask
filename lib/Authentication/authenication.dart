import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';



class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,child: Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.black),backgroundColor: Colors.white,
        title: Text("Fitness",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        bottom: TabBar(labelColor: Colors.black,
          tabs: [
            Tab(icon: Icon(Icons.lock,color: Colors.red,),text: "Login",),
            Tab(icon: Icon(Icons.person,color: Colors.red,),text: "SignUp",),

          ],
          indicatorColor: Colors.white54,
          indicatorWeight: 5,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(

        ),
        child:TabBarView(
          children: [
            Login(),
            Register()
          ],
        ) ,
      ),
    ),
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/Config/config.dart';
import 'package:fitness/DialogBox/errorDialog.dart';
import 'package:fitness/HomeScreen.dart';
import 'package:flutter/material.dart';

import '../adminLogin.dart';
import '../customTextField.dart';




class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>
{


  final TextEditingController _emailTextEditingController= TextEditingController();
  final TextEditingController _passwordTextEditingController= TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width, _screenheight= MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.red[900],
                    Colors.red[400],
                    Colors.red[100]
                  ]
              )
          ),
        child:Column(mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/work.png",height: 240,width: 240,),
            ),
            Padding(padding: EdgeInsets.all(8),
            child: Text("Login to your account",style: TextStyle(color: Colors.white),),),
            SizedBox(height: 25,),
            Form(child: Column(
              children: [
            CustomTextField(
              controller:_emailTextEditingController ,
              data: Icons.email,
              hintText: "Email",
              isObsecure: false,
            ),
            CustomTextField(
              controller:_passwordTextEditingController ,
              data: Icons.lock,
              hintText: "Password",
              isObsecure: true,
            ),
            SizedBox(height: 25,),
            Container(
              height: 50.0,
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.greenAccent,
                color: Colors.black,
                elevation: 1.0,
                child: GestureDetector(
                  onTap: () {
                   loginUser();
                  },
                  child: Center(
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,),
            Container(
              height: 50.0,
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.greenAccent,
                color: Colors.indigo,
                elevation: 1.0,
                child: GestureDetector(
                  onTap: () {},
                  child: Center(
                    child: Text(
                      'Use Facebook',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ),
            ),
                SizedBox(height: 25,),
                Container(
                  height: 50.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.greenAccent,
                    color: Colors.red,
                    elevation: 1.0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Center(
                        child: Text(
                          'Google SignIn',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ),
                ),
          ]
      ),
    ),
            SizedBox(height: 50,),
            Container(
              height: 4,
              width: _screenwidth*0.8,
              color: Colors.red,

            ),
            SizedBox(height: 10,),
            FlatButton.icon(onPressed:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminSignInPage())
                , ), label: Text("i'm trainer",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),),icon: Icon(Icons.nature_people),
            )])
      ));

  }
  FirebaseAuth _auth =FirebaseAuth.instance;
  void loginUser() async{
        showDialog(context: context,builder: (c){
          return MyHomeScreen();
        });
        FirebaseUser firebaseUser;
        await _auth.signInWithEmailAndPassword(email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim(),).then((value) => (authUser){
              firebaseUser= authUser.user;
        }
        ).catchError((error){
          Navigator.pop(context);
          showDialog(context: context,builder:(c){
            return ErrorAlertDialog(message:error.message.toString() ,);

          });
        });
        if(firebaseUser!= null){
          readData(firebaseUser);
        }
  }
  Future readData(FirebaseUser fUser) async{

    Firestore.instance.collection("users").document(fUser.uid).get().then((dataSnapshot) async{
      await EcommerceApp.sharedPreferences.setString("uid", dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName,dataSnapshot.data[EcommerceApp.userName].text);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, dataSnapshot.data[EcommerceApp.userAvatarUrl]);
      List<String> cartList = dataSnapshot.data[EcommerceApp.userCartList].cast<String>();

      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}

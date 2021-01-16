
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/Authentication/register.dart';
import 'package:flutter/material.dart';

import 'AdminHomeScreen.dart';
import 'Authentication/RegisterAdmin.dart';
import 'Authentication/authenication.dart';
import 'DialogBox/errorDialog.dart';
import 'customTextField.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red,
        title: Text("Trainer Login"),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final TextEditingController _adminIdTextEditingController= TextEditingController();
  final TextEditingController _passwordTextEditingController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width, _screenheight= MediaQuery.of(context).size.height;
    return SingleChildScrollView(
        child: Container(

            child:Column(mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset("assets/work.png",height: 240,width: 240,),
                  ),
                  Padding(padding: EdgeInsets.all(8),
                    child: Text("Login to your account",style: TextStyle(color: Colors.white),),),
                  SizedBox(height: 10,),
                  Form(child: Column(
                      children: [
                        CustomTextField(
                          controller:_adminIdTextEditingController ,
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
                        SizedBox(height: 10,),
                      ]
                  ),
                  ),
                  MaterialButton(minWidth: 200,height: 50,
                    onPressed: (){
                    _adminIdTextEditingController.text.isNotEmpty && _passwordTextEditingController.text.isNotEmpty ? loginAdmin():showDialog(context: context
                        ,builder: (c){
                          return ErrorAlertDialog(message: "Please write email and password",);
                        });
                  },color: Colors.red,
                    child: Text("Login",style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(height: 20,),
                  MaterialButton(minWidth: 200,height: 50,
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return RegisterAdmin();
                        }),
                      );
                    },color: Colors.red,
                    child: Text("Register",style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 4,
                    width: _screenwidth*0.8,
                    color: Colors.pink,

                  ),

                  FlatButton.icon(onPressed:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthenticScreen())
                    , ), label: Text("i'm not Trainer",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),),icon: Icon(Icons.nature_people),
                  )])
        ));
  }
  loginAdmin(){
    Firestore.instance.collection("admins").getDocuments().then((snapshot){
      snapshot.documents.forEach((result) {
        if(result.data["id"] != _adminIdTextEditingController.text.trim())
          {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("your id is not correct")));
          }
        else if (result.data["password"] != _passwordTextEditingController.text.trim())
          {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("your password is not correct")));
          }
        else {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome Dear Trainer, " + result.data["name"])));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return AdminHomeScreen();
            }),
          );
        }
      });
    });
  }
}

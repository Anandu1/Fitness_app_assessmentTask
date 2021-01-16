import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness/AdminHomeScreen.dart';
import 'package:fitness/Config/config.dart';
import 'package:fitness/DialogBox/errorDialog.dart';
import 'package:fitness/DialogBox/loadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../customTextField.dart';

class RegisterAdmin extends StatefulWidget {
  @override
  _RegisterAdminState createState() => _RegisterAdminState();
}

class _RegisterAdminState extends State<RegisterAdmin> {
  final TextEditingController _nameTextEditingController= TextEditingController();
  final TextEditingController _emailTextEditingController= TextEditingController();
  final TextEditingController _passwordTextEditingController= TextEditingController();
  final TextEditingController _cpasswordTextEditingController= TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userImgUrl = "";
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width, _screenheight= MediaQuery.of(context).size.height;
    return Scaffold(
    body:
      SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.red[900],
                  Colors.red[700],
                  Colors.red
                ]
            )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              onTap: ()=> _selectandpickimage,
              child: CircleAvatar(
                  radius: _screenheight*0.10,
                  backgroundColor: Colors.grey,
                  backgroundImage: _imageFile==null ? null: FileImage(_imageFile),
                  child: _imageFile==null ? Icon(Icons.add_photo_alternate,size: _screenwidth*0.15,color: Colors.black,)
                      : null
              ),
            ),
            SizedBox(height: 8,),
            Form(key: _formkey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller:_nameTextEditingController ,
                      data: Icons.person,
                      hintText: "Name",
                      isObsecure: false,
                    ),
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
                    CustomTextField(
                      controller:_cpasswordTextEditingController ,
                      data: Icons.lock,
                      hintText: "Confirm password",
                      isObsecure: false,
                    ),
                  ],
                )),
            SizedBox(height: 30,),
            Container(
              height: 50.0,
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.greenAccent,
                color: Colors.black,
                elevation: 1.0,
                child: GestureDetector(
                  onTap: () {
                    registerUser();
                  },
                  child: Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(height: 4.0,width: _screenheight*0.8,color: Colors.white,),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    ));
  }
  Future <void> _selectandpickimage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }
  Future <void> uploadAndSaveImage() async
  {
    if(_imageFile== null)
    {
      showDialog(context: context,builder: (c)
      {
        return ErrorAlertDialog(message: "Please Select an Image file",);
      });
    }
    else{
      _passwordTextEditingController.text== _cpasswordTextEditingController.text ?
      _emailTextEditingController.text.isNotEmpty && _cpasswordTextEditingController.text.isNotEmpty
          && _nameTextEditingController.text.isNotEmpty
          ? uploadToStorage()
          : displayDialog("Please fill up the complete forum")
          : displayDialog("Password do not match");
    }
  }
  displayDialog(String msg){
    showDialog(context: context,
        builder:(c) {
          return ErrorAlertDialog(message: msg,);
        });
  }
  uploadToStorage() async{
    showDialog(context: context,builder: (c){
      return LoadingAlertDialog(message: "Authenticating, Please Wait..... ",);
    });
    String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();
    StorageReference storageReference = FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage)  {
      userImgUrl = urlImage;
      registerUser();
    });
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  void registerUser() async {
    FirebaseUser firebaseUser;
    await _auth.createUserWithEmailAndPassword(email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),).then((auth){
      firebaseUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context,builder:(c){
        return ErrorAlertDialog(message:error.message.toString() ,);

      });

    });
    if(firebaseUser !=null){
      saveUserInfoToFireStore(firebaseUser).then((value) {

        Route route = MaterialPageRoute(builder: (c)=> AdminHomeScreen());
        Navigator.pushReplacement(context, route);
      });}
  }
  Future saveUserInfoToFireStore(FirebaseUser Fuser) async{
    Firestore.instance.collection("users").document(Fuser.uid).setData(
        {
          "uid": Fuser.uid,
          "email": Fuser.email,
          "name": _nameTextEditingController.text.trim(),
          "url": userImgUrl,
        }
    );
    await EcommerceApp.sharedPreferences.setString("uid", Fuser.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, Fuser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName,_nameTextEditingController.text);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImgUrl);
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String get image => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trainer  DashBoard"),
      ),
      body: Center(child:
      Column(
        children: <Widget>[
          SizedBox(height: 300,),
          Container(
            height: 50.0,
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.greenAccent,
              color: Colors.indigo,

              child: GestureDetector(
                onTap: () {

                          getImage(context, image);


                },
                child: Center(
                  child: Text(
                    'Get Workout videos',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ));

  }

Future<Widget> getImage(BuildContext context, String imageName) async{
    Image image;
   await  FireStorageService.loadImage(context, imageName).then((value) {
     image = Image.network(value.toString(),fit: BoxFit.scaleDown,);
    });
   return image;
}
 
}
class FireStorageService extends ChangeNotifier{
      FireStorageService();
      static Future<dynamic> loadImage(BuildContext context, String Image) async{
        return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
      }

}

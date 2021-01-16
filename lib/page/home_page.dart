import 'dart:io';
import 'package:fitness/model/media_source.dart';
import 'package:fitness/page/source_page.dart';
import 'package:fitness/widget/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../ImageMain.dart';


class ImageHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ImageHomePage> {
  File fileMedia;
  MediaSource source;
  Future getImage() async{
    var tempImage= await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      fileMedia = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Upload your workout session"),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: fileMedia== null ? Text("Select a File",style: TextStyle(fontWeight: FontWeight.bold),) :
                  RaisedButton(child: Text("Upload"),color: Colors.blue,
                      onPressed:(){ enableUpload();}

                  ),
                ),
                Expanded(
                  child: fileMedia == null
                      ? Icon(Icons.photo, size: 120)
                      : (source == MediaSource.image
                          ? Image.file(fileMedia)
                          : VideoWidget(fileMedia)),
                ),
                const SizedBox(height: 24),
                RaisedButton(
                  child: Text('Capture Image'),
                  shape: StadiumBorder(),
                  onPressed: () => capture(MediaSource.image),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
                const SizedBox(height: 12),
                RaisedButton(
                  child: Text('Capture Video'),
                  shape: StadiumBorder(),
                  onPressed: () => capture(MediaSource.video),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),

              ],
            ),
          ),
        ),
      );

  Future capture(MediaSource source) async {
    setState(() {
      this.source = source;
      this.fileMedia = null;
    });

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SourcePage(),
        settings: RouteSettings(
          arguments: source,
        ),
      ),
    );

    if (result == null) {
      return;
    } else {
      setState(() {
        fileMedia = result;
      });
    }
  }
   enableUpload() async {
              final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("MyWorkout");
              final StorageUploadTask task = firebaseStorageRef.putFile(fileMedia);
              StorageTaskSnapshot taskSnapshot = await task.onComplete;
              taskSnapshot.ref.getDownloadURL().then(
                    (value) => print("Done: $value"),
              );
            }

  }


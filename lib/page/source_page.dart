import 'package:fitness/widget/camera_button_widget.dart';
import 'package:fitness/widget/gallery_button_widget.dart';
import 'package:flutter/material.dart';


class SourcePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Source'),
      ),
      body: ListView(
        children: [
          CameraButtonWidget(),
          GalleryButtonWidget(),
        ],
      ),
    );
  }
}

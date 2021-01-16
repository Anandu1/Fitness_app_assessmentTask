import 'package:fitness/page/home_page.dart';
import 'package:flutter/material.dart';

import 'notification.dart';




class imageMain extends StatelessWidget {
  static final String title = 'Pick Image & Video';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: ImageHomePage(),
      );
}

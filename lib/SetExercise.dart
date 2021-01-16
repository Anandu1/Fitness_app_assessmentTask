import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetExercise extends StatefulWidget {
  @override
  _SetExerciseState createState() => _SetExerciseState();
}

class _SetExerciseState extends State<SetExercise> {
  String dropdownValue = "Daily";
  List<String> dropdownItems = <String>[
    "Daily","Weekly","Custom"
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 36,
          elevation: 8,
          onChanged: (String newValue){
            setState(() {
              dropdownValue= newValue;
            });
        },
          items: dropdownItems.map<DropdownMenuItem<String>>((String value)
          {
            return DropdownMenuItem<String>(value: value,
                child: Text(value));
          }
          ).toList()
        ),
      ),
    );
  }
}

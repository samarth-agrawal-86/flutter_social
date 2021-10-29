import 'package:flutter/material.dart';

Container CircularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10),
    child: CircularProgressIndicator(
      //color: Colors.purple,
      valueColor: AlwaysStoppedAnimation(Colors.teal),
    ),
  );
}

Container LinearProgress() {
  return Container(
    padding: EdgeInsets.only(bottom: 10),
    child: LinearProgressIndicator(
      //color: Colors.purple,
      valueColor: AlwaysStoppedAnimation(Colors.teal),
    ),
  );
}

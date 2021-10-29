import 'package:flutter/material.dart';

TextButton klogoutButton(Function() onPress) {
  return TextButton(
    style: TextButton.styleFrom(
        backgroundColor: Colors.blue, primary: Colors.white),
    onPressed: onPress,
    child: Text('Log Out'),
  );
}

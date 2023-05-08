import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showSnackBar(BuildContext context, String title, {bool isError = false}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(title),
    backgroundColor: isError ? Colors.redAccent : Colors.greenAccent,
  ));
}


void showPopupMessage(String message) {
  // Use your preferred method to display a popup message on the screen
  // This could be a package like fluttertoast or a custom widget
  // Here's an example using fluttertoast:
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
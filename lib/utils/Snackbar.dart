import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context,{required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.red[300],
      content: Text(message,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

void showSuccessMessage(BuildContext context,{required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.amber[300],
      content: Text(message,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

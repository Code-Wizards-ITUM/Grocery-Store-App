import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, // Change arrow color to white
        ),
      ),
      body: Center(child: Text('Signup Screen Placeholder')),
    );
  }
}

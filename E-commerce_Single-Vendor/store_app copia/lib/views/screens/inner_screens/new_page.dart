import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('This is the app bar'),
      ),
      body: Center(
        child: Text('hello world'),
      ),
      bottomSheet: Container(
        height: 50,
        width: double.infinity,
        color: Colors.blue,
        child: Center(
            child: Text(
          'This is the footer',
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}

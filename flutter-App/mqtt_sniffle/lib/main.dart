// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: const Color.fromARGB(255, 98, 7, 255),
      body: Center(
        child: Column(children: [
          SizedBox(
            height: 200,
          ),
          ElevatedButton(
            style: ButtonStyle(),
            onPressed: () {},
            child: Text("publish"),
          ),
        ]),
      ),
    ));
  }
}

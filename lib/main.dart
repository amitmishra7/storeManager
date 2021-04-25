import 'package:firestore_demo/pages/add_edit_record_page.dart';
import 'package:firestore_demo/pages/home_page.dart';
import 'package:firestore_demo/pages/login_page.dart';
import 'package:firestore_demo/pages/records_list.dart';
import 'package:firestore_demo/pages/records_tab_page.dart';
import 'package:firestore_demo/pages/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'URL Saver',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
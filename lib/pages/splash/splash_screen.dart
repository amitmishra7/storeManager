import 'package:firestore_demo/components/util/app_constants.dart';
import 'package:firestore_demo/components/util/global.dart';
import 'package:firestore_demo/components/widgets/custom_shape.dart';
import 'package:firestore_demo/components/widgets/textformfield.dart';
import 'package:firestore_demo/core/shared_preference/shared_preference.dart';
import 'package:firestore_demo/firestore/firestore.dart';
import 'package:firestore_demo/models/user.dart';
import 'package:firestore_demo/pages/home_page.dart';
import 'package:firestore_demo/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //logoutUser();
    loadUser();
    super.initState();
  }

  void logoutUser() {
    SharedPrefManager.instance.removeUser();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }

  loadUser() async {
    User user = await SharedPrefManager.instance.getUser();
    var screen;
    if (user != null) {
      Global().user = user;
      screen = HomePage();
    } else {
      screen = LoginPage();
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => screen,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                clipShape(),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/flutter.png',
                      width: 100,
                    ),
                  ),
                ),
                RotatedBox(
                  quarterTurns: 2,
                  child: clipShape(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

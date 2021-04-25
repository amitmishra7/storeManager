import 'package:firestore_demo/components/util/app_constants.dart';
import 'package:firestore_demo/components/widgets/custom_shape.dart';
import 'package:firestore_demo/components/widgets/textformfield.dart';
import 'package:firestore_demo/firestore/firestore.dart';
import 'package:firestore_demo/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool checkBoxValue = false;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailIdController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //Opacity(opacity: 0.88,child: CustomAppBar()),
                  clipShape(),
                  form(),
                  acceptTermsTextRow(),
                  signUpButton(),
                  signUpWithGoogle(),
                  infoTextRow(),
                  //signInTextRow(),
                ],
              ),
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

  Widget form() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Form(
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: 10),
            lastNameTextFormField(),
            SizedBox(height: 10),
            emailTextFormField(),
            SizedBox(height: 10),
            phoneTextFormField(),
            SizedBox(height: 10),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return TextInputField(
      textEditingController: _firstNameController,
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "First Name",
    );
  }

  Widget lastNameTextFormField() {
    return TextInputField(
      textEditingController: _lastNameController,
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "Last Name",
    );
  }

  Widget emailTextFormField() {
    return TextInputField(
      textEditingController: _emailIdController,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget phoneTextFormField() {
    return TextInputField(
      textEditingController: _phoneController,
      keyboardType: TextInputType.number,
      icon: Icons.phone,
      hint: "Mobile Number",
    );
  }

  Widget passwordTextFormField() {
    return TextInputField(
      textEditingController: _passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      icon: Icons.lock,
      hint: "Password",
    );
  }

  Widget acceptTermsTextRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
            activeColor: Colors.orange[200],
            value: checkBoxValue,
            onChanged: (bool newValue) {
              setState(() {
                checkBoxValue = newValue;
              });
            }),
        Text(
          "I accept all terms and conditions",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        ),
      ],
    );
  }

  Widget signUpButton() {
    return InkWell(
      onTap: () {
        print(
            'Amit details ${_firstNameController.text} ${_lastNameController.text} ${_emailIdController.text} ${_phoneController.text} ${_passwordController.text}');
        createNewUser();
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200], Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'Sign Up',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget signUpWithGoogle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(color: Colors.grey, width: 1),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/google_light.png',
              width: 14,
              height: 14,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Sign Up With Google',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoTextRow() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already a member? ",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
            },
            child: Text(
              "Sign In",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
  createNewUser() {
    DateTime now = DateTime.now();
    String id = DateFormat('ddMMyyyykkmmss').format(now);
    fireStoreDataBase.collection('users').document(id).setData({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailIdController.text,
      'mobileNo': _phoneController.text,
      'password': _passwordController.text,
      'isGoogleUser': false,
      'id': id,
      'lastSignOn': DateTime.now().millisecondsSinceEpoch
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_demo/components/util/global.dart';
import 'package:firestore_demo/components/widgets/custom_shape.dart';
import 'package:firestore_demo/components/widgets/textformfield.dart';
import 'package:firestore_demo/components/widgets/toast.dart';
import 'package:firestore_demo/core/shared_preference/shared_preference.dart';
import 'package:firestore_demo/firestore/firestore.dart';
import 'package:firestore_demo/models/user.dart';
import 'package:firestore_demo/pages/home_page.dart';
import 'package:firestore_demo/pages/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggedIn = false;
  bool checkBoxValue = false;
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailIdController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Opacity(opacity: 0.88,child: CustomAppBar()),
              clipShape(),
              SizedBox(
                height: 100,
              ),
              form(),
              SizedBox(
                height: 20,
              ),
              signInButton(),
              signUpWithGoogle(),
              infoTextRow(),
              //signInTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    try {
      await googleSignIn.signIn();
      setState(() {
        isLoggedIn = true;
        updateGoogleSignInData();
      });

    } catch (error) {
      print(error);
    }
  }

  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      setState(() {
        isLoggedIn = false;
      });
    } catch (error) {
      print(error);
    }
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
            emailTextFormField(),
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

  Widget signInButton() {
    return InkWell(
      onTap: () {
        print(
            'Amit details ${_firstNameController.text} ${_lastNameController.text} ${_emailIdController.text} ${_phoneController.text} ${_passwordController.text}');
        loginWithEmail();
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
          'Sign In',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget signUpWithGoogle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: signIn,
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
            "Don't have an account? ",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(),
                  ));
            },
            child: Text(
              "Sign Up",
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

  updateGoogleSignInData(){
    var lastSignInOn = DateTime.now().millisecondsSinceEpoch;
    var data = fetchUserDetails(googleSignIn.currentUser.email);

    User user;
    if(data!=null){
      user = User(
          id: data['id'],
          nickName: data['nickName'],
          photoUrl: data['photoUrl'],
          firstName: data['firstName'],
          lastName: data['lastName'],
          email: data['email'],
          mobileNo: data['mobileNo'],
          password: data['password'],
          isGoogleUser: true,
          lastSignOn: lastSignInOn);

    }else{
      user = User(
          id: googleSignIn.currentUser.id,
          email: googleSignIn.currentUser.email,
          nickName: googleSignIn.currentUser.displayName,
          photoUrl: googleSignIn.currentUser.photoUrl,
          isGoogleUser: true,
          lastSignOn: lastSignInOn);
    }

    fireStoreDataBase
        .collection('users')
        .document(googleSignIn.currentUser.id)
        .setData(User.toMap(user));

    SharedPrefManager.instance.saveUser(user: user);

    Global().user = user;

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
  }

  updateSignInData(dynamic data) {
    var lastSignInOn = DateTime.now().millisecondsSinceEpoch;
    User user = User(
        id: data['id'],
        nickName: data['nickName'],
        photoUrl: data['photoUrl'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        email: data['email'],
        mobileNo: data['mobileNo'],
        password: data['password'],
        isGoogleUser: false,
        lastSignOn: lastSignInOn);

    fireStoreDataBase
        .collection('users')
        .document(data['id'])
        .setData(User.toMap(user));

    SharedPrefManager.instance.saveUser(user: user);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
  }

  DocumentSnapshot fetchUserDetails(String email) {
    DocumentSnapshot documentData;
    fireStoreDataBase
        .collection('users')
        .where("email", isEqualTo: email)
        .snapshots()
        .listen((data) {
          print('Amit snapshots ${data}');
      if (data.documents.length > 0) {

        documentData =  data.documents[0];
      } else {
        /// no user found
        documentData = null;
      }
    });

    return documentData;
  }

  void loginWithEmail() {

    fireStoreDataBase
        .collection('users')
        .where("email", isEqualTo: _emailIdController.text)
        .snapshots()
        .listen((data) {
      if (data.documents.length > 0) {
        /// user found check with password
        if (data.documents[0]['password'] == _passwordController.text) {
          /// save data for future use and navigate to home

          updateSignInData(data.documents[0]);
        } else {
          /// invalid password
          ToastUtil.showToast('Invalid credentials');
        }
      } else {
        /// no user found
        ToastUtil.showToast('No user found with this email');
      }
    });
  }
}

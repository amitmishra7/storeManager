import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_demo/components/util/app_constants.dart';
import 'package:firestore_demo/components/util/global.dart';
import 'package:firestore_demo/components/widgets/text_widgets.dart';
import 'package:firestore_demo/components/widgets/textformfield.dart';
import 'package:firestore_demo/components/widgets/toast.dart';
import 'package:firestore_demo/core/shared_preference/shared_preference.dart';
import 'package:firestore_demo/firestore/firestore.dart';
import 'package:firestore_demo/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool visible = false;
  User profileDetails;
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      profileDetails = Global().user;
      _firstNameController.text = Global().user.firstName;
      _lastNameController.text = Global().user.lastName;
      _mobileNoController.text = Global().user.mobileNo;
      _emailController.text = Global().user.email;
      _passwordController.text = Global().user.password;
    });
    super.initState();
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    await _displayPickImageDialog(context, () async {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
        );
        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();

    super.dispose();
  }

  Widget buildProfileImage() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          _imageFile == null
              ? Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          image: new NetworkImage(profileDetails != null
                              ? (profileDetails.photoUrl != null
                                  ? profileDetails.photoUrl
                                  : 'https://www.koimoi.com/wp-content/new-galleries/2020/08/avengers-endgame-trivia-118-when-robert-downey-jr-called-tony-stark-an-ahole-001.jpg')
                              : 'https://www.koimoi.com/wp-content/new-galleries/2020/08/avengers-endgame-trivia-118-when-robert-downey-jr-called-tony-stark-an-ahole-001.jpg'))))
              : Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: new FileImage(File(_imageFile.path))))),
          Positioned(
            top: 5, right: 5, //give the values according to your requirement
            child: InkWell(
              onTap: () {
                showPickAction(context, 'Choose', 'My Message');
              },
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange[200],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(Icons.edit),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditImageButton() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        child: OutlineButton(
          onPressed: () {
            showPickAction(context, 'Pick Action', 'My Message');
          },
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              AppConstants.EDIT_PHOTO,
              style: TextStyle(
                fontSize: 16,
                fontFamily: "sfpro",
                color: Colors.black,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 2,
      title: TextWidgets(
        text: AppConstants.PROFILE,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: buildAppBar(),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  buildProfileImage(),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  form(),
                  isLoading ? buildProgressIndicator() : buildSubmitButtom(),
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildSubmitButtom() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          validateFields();
        },
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 1.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(
              colors: <Color>[Colors.orange[200], Colors.pinkAccent],
            ),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Text(
            AppConstants.UPDATE_PROFILE,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircularProgressIndicator(),
    );
  }

  validateFields() {
    if (_firstNameController.text.isEmpty) {
      ToastUtil.showToast('First Name cannot be empty');
      return;
    }
    if (_lastNameController.text.isEmpty) {
      ToastUtil.showToast('Last Name cannot be empty');
      return;
    }
    if (_emailController.text.isEmpty) {
      ToastUtil.showToast('Email cannot be empty');
      return;
    }
    if (_mobileNoController.text.isEmpty) {
      ToastUtil.showToast('Mobile No cannot be empty');
      return;
    }
    if (_passwordController.text.isEmpty) {
      ToastUtil.showToast('Password cannot be empty');
      return;
    }
    updateProfile();
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
      isEditable: _emailController.text.isNotEmpty ? false : true,
      textEditingController: _emailController,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget phoneTextFormField() {
    return TextInputField(
      isEditable: _mobileNoController.text.isNotEmpty ? false : true,
      textEditingController: _mobileNoController,
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

  updateProfile() {
    setState(() {
      isLoading = true;
    });
    if (_imageFile != null) {
      uploadImage();
    } else {
      updateProfileData();
    }
  }

  bool validation() {
    return true;
    /* if (nameValidate()) {
      return true;
    } else {
      return false;
    }*/
  }

  Future<void> _showMyDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(message)],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    onPick();
  }

  Future<void> showPickAction(
      BuildContext context, String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Row(
            children: <Widget>[
              Expanded(
                child: FloatingActionButton(
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery,
                        context: context);
                    Navigator.of(context).pop();
                  },
                  heroTag: 'image0',
                  tooltip: 'Pick Image from gallery',
                  child: const Icon(Icons.photo_library),
                ),
              ),
              Expanded(
                child: FloatingActionButton(
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.camera, context: context);
                    Navigator.of(context).pop();
                  },
                  heroTag: 'image1',
                  tooltip: 'Take a Photo',
                  child: const Icon(Icons.camera_alt),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  updateProfileData({String photoUrl}) {
    User user;
    if (profileDetails.isGoogleUser) {
      user = User(
          id: profileDetails.id,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          mobileNo: _mobileNoController.text,
          password: _passwordController.text,
          isGoogleUser: true,
          lastSignOn: profileDetails.lastSignOn,
          nickName: profileDetails.nickName,
          photoUrl: photoUrl != null ? photoUrl : profileDetails.photoUrl);
    } else {
      user = User(
          id: profileDetails.id,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          mobileNo: _mobileNoController.text,
          password: _passwordController.text,
          isGoogleUser: false,
          lastSignOn: profileDetails.lastSignOn,
          photoUrl: photoUrl != null ? photoUrl : profileDetails.photoUrl);
    }

    fireStoreDataBase.collection('users').document(user.id).setData(User.toMap(user));
    setState(() {
      isLoading = false;
    });

    SharedPrefManager.instance.saveUser(user: user);
    Global().user = user;
    ToastUtil.showToast('Profile Update Successfully!');

    Navigator.pop(context);
  }

  Future<void> uploadImage() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('${AppConstants.APP_NAME}/${(_imageFile.path)}}');
    StorageUploadTask uploadTask =
        storageReference.putFile(File(_imageFile.path));
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      updateProfileData(photoUrl: fileURL);
    });
  }
}

typedef void OnPickImageCallback();

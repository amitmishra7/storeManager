import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_demo/components/util/app_constants.dart';
import 'package:firestore_demo/components/util/global.dart';
import 'package:firestore_demo/core/shared_preference/shared_preference.dart';
import 'package:firestore_demo/pages/feedback/feedback_page.dart';
import 'package:firestore_demo/pages/login_page.dart';
import 'package:firestore_demo/pages/profile/profile_page.dart';
import 'package:firestore_demo/pages/records_list.dart';
import 'package:firestore_demo/pages/records_tab_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Firestore fireStoreDataBase = Firestore.instance;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<DocumentSnapshot> documents;

  String collectionName = "master";

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        title: Text('URL Manager'),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white10,
              ),
              currentAccountPicture: Global().user.photoUrl != null
                  ? Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: new NetworkImage(Global().user.photoUrl))))
                  : Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/flutter.png")))),
              accountName: Text(
                Global().user.firstName!=null?Global().user.firstName:Global().user.nickName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "sfpro",
                    fontSize: 18,
                    color: Colors.black),
              ),
              accountEmail: Text(
                Global().user.email,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: "sfpro",
                    fontSize: 14,
                    color: Colors.black54),
              ),
            ),
            ListTile(
              title: GestureDetector(
                child: Text(
                  "My Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: "sfpro",
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => ProfilePage()));
                },
              ),
              leading: Icon(Icons.person_outline, color: Color(0xff386EF9)),
            ),
            ListTile(
              title: GestureDetector(
                child: Text(
                  "Give Feedback",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: "sfpro",
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FeedbackPage()));
                },
              ),
              leading: Icon(
                Icons.thumb_up,
                color: Color(0xff386EF9),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: GestureDetector(
                    child: Text(
                      AppConstants.LOGOUT,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: "sfpro",
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      logoutUser();
                    },
                  ),
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Color(0xff386EF9),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStoreDataBase.collection(collectionName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            documents = snapshot.data.documents;
            return buildRecordList();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logoutUser();
          //addEditRecordDialog(context, null);
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildRecordList() {
    return ListView(
      children: documents.map((doc) {
        return Dismissible(
          key: Key(doc['title']),
          onDismissed: (direction) {
            //deleteRecord(doc.documentID);
          },
          confirmDismiss: (direction) {
            confirmDeleteDialog(context, doc.documentID);
          },
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RecordsTabPage(collectionName: doc['title']),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          doc['title'] != null
                              ? Text('${doc['title']}',
                                  style: (TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)))
                              : Container(),
                          doc['description'] != null
                              ? SizedBox(
                                  height: 5,
                                )
                              : Container(),
                          doc['description'] != null
                              ? Text('${doc['description']}',
                                  style: (TextStyle(
                                    fontSize: 16,
                                  )))
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void createRecord() async {
    await fireStoreDataBase.collection(collectionName).add({
      'title': titleController.text,
      'description': descriptionController.text,
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Record Created..!!")));
  }

  void updateRecord(String documentId) {
    try {
      fireStoreDataBase
          .collection(collectionName)
          .document(documentId)
          .updateData({
        'title': titleController.text,
        'description': descriptionController.text,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Record Updated..!!")));
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteRecord(String documentId) {
    try {
      fireStoreDataBase
          .collection(collectionName)
          .document(documentId)
          .delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Record Deleted..!!")));
    } catch (e) {
      print(e.toString());
    }
  }

  addEditRecordDialog(BuildContext context, DocumentSnapshot doc) async {
    if (doc != null) {
      /// extract text to update record
      titleController.text = doc['title'];
      descriptionController.text = doc['description'];
    } else {
      /// refresh texts add record
      titleController.text = "";
      descriptionController.text = "";
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(doc != null ? 'Edit Record' : 'Add Record'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(labelText: "Title"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: descriptionController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(labelText: "Description"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new TextButton(
                child: new Text('Save'),
                onPressed: () {
                  if (doc != null) {
                    /// update existing record
                    updateRecord(doc.documentID);
                  } else {
                    /// create new record
                    createRecord();
                  }
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void confirmDeleteDialog(BuildContext context, String documentID) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Record'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      'Are you sure you want to remove this record. All the data pertaining to this record will be lost. Continue?'),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new TextButton(
                child: new Text('Yes'),
                onPressed: () {
                  /// delete record
                  deleteRecord(documentID);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void logoutUser() {
    SharedPrefManager.instance.removeUser();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }

/*Future<void> uploadImage() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('${AppConstants.APP_NAME}/${(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }*/
}

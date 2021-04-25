import 'package:firestore_demo/components/util/app_constants.dart';
import 'package:firestore_demo/components/util/global.dart';
import 'package:firestore_demo/components/widgets/curve_app_button.dart';
import 'package:firestore_demo/components/widgets/text_widgets.dart';
import 'package:firestore_demo/components/widgets/toast.dart';
import 'package:firestore_demo/firestore/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String message;
  bool categoryValidation = false;
  bool messageValidation = false;

  List<String> feedbackArray = [
    'Appreciation',
    'Bug',
    'Enhancement',
    'Suggestion'
  ];

  String selectedFeedbackLabel;
  String selectedFeedbackValue;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 2,
          title: TextWidgets(
            text: AppConstants.FEEDBACK,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.grey),
        ),
        body: Stack(children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: TextWidgets(
                          text: AppConstants.GET_IN_TOUCH,
                          fontSize: 24,
                          fontFamily: "sfpro",
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Expanded(
                    child: Text(
                      'Hi '+Global().user.firstName + AppConstants.FEEDBACK_TITLE,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "sfpro",
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 40),
                  child: Row(
                    children: <Widget>[
                      TextWidgets(
                        text: AppConstants.CATEGORY,
                        fontSize: 12,
                        fontFamily: "sfpro",
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                Container(
                    height: 60,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Color(0xffF0F0F0),
                    ),
                    child: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: DropdownButton<String>(
                            underline: SizedBox(),
                            focusColor: Colors.red,
                            hint: Text("Select"),
                            value: selectedFeedbackLabel,
                            onChanged: (String Value) {
                              setState(() {
                                selectedFeedbackLabel = Value;
                              });
                            },
                            isExpanded: true,
                            items: feedbackArray.map((String user) {
                              return DropdownMenuItem<String>(
                                value: user,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      user,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 20),
                  child: Row(
                    children: <Widget>[
                      TextWidgets(
                        text: AppConstants.MESSAGE,
                        fontSize: 12,
                        fontFamily: "sfpro",
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Color(0xffF0F0F0),
                        ),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: TextField(
                                onChanged: (text) {
                                  setState(() {
                                    message = text;
                                  });
                                },
                                minLines: 5,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                )),
                          ),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 10.0, left: 10.0, bottom: 10.0, top: 30),
                    child: CurveButton(
                      text: AppConstants.SEND_FEEDBACK,
                    ),
                  ),
                  onTap: () {
                    onSendFeedbackClicked();
                  },
                ),
              ],
            ),
          ),
        ]));
  }

  onSendFeedbackClicked() {
    if (selectedFeedbackLabel == null || selectedFeedbackLabel.isEmpty) {
      ToastUtil.showToast("Select Category");
    }

    if (message == null || message.isEmpty) {
      ToastUtil.showToast("Message cannot be empty");
    }

    DateTime now = DateTime.now();
    String id = DateFormat('ddMMyyyykkmmss').format(now);

    fireStoreDataBase.collection('feedback').document(id).setData({
      'id': id,
      'category': selectedFeedbackLabel,
      'feedback': message,
      'by': Global().user.email,
    });
    Navigator.pop(context);
  }
}

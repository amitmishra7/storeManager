import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil{
  static showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        fontSize: 16.0
    );
  }
}
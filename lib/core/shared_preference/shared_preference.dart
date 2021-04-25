import 'dart:convert';

import 'package:firestore_demo/components/util/app_constants.dart';
import 'package:firestore_demo/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  SharedPreferences _manager;

  SharedPrefManager._privateConstructor();

  static final SharedPrefManager _instance =
      SharedPrefManager._privateConstructor();

  static SharedPrefManager get instance {
    return _instance;
  }

  Future<bool> saveUser({User user}) async {
    if (_manager == null) {
      _manager = await SharedPreferences.getInstance();
    }
    return _manager.setString(AppConstants.LOGGED_IN_USER, json.encode(user.toJson()));
  }

  Future<User> getUser() async {
    if (_manager == null) {
      _manager = await SharedPreferences.getInstance();
    }

    return ((_manager.getString(AppConstants.LOGGED_IN_USER) != null)
        ? User.fromJson(json.decode(_manager.getString(AppConstants.LOGGED_IN_USER)))
        : null);
  }

  Future<bool> removeUser() async {
    if (_manager == null) {
      _manager = await SharedPreferences.getInstance();
    }
    _manager.remove(AppConstants.LOGGED_IN_USER);
    return _manager.remove(AppConstants.LOGGED_IN_USER);
  }
}

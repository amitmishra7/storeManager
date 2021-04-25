
import 'package:firestore_demo/models/user.dart';

class Global {
  static final Global _global = Global.internal();

  factory Global() {
    return _global;
  }

  Global.internal();
  User user;
}

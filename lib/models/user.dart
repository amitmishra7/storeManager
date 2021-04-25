class User {
  ///mandatory
  String id;
  String email;
  bool isGoogleUser;
  num lastSignOn;

  ///from google sign in
  String nickName;
  String photoUrl;

  /// from signup
  String firstName;
  String lastName;
  String mobileNo;
  String password;

  User(
      {this.id,
      this.email,
      this.nickName,
      this.photoUrl,
      this.isGoogleUser,
      this.lastSignOn,
      this.firstName,
      this.lastName,
      this.mobileNo,
      this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User();
    user.id = json['id'];
    user.email = json['email'];
    user.isGoogleUser = json['isGoogleUser'];
    user.lastSignOn = json['lastSignOn'] != null ? json['lastSignOn'] : null;
    user.nickName = json['nickname'] != null ? json['nickname'] : null;
    user.photoUrl = json['photoUrl'] != null ? json['photoUrl'] : null;
    user.firstName = json['firstName'] != null ? json['firstName'] : null;
    user.lastName = json['lastName'] != null ? json['lastName'] : null;
    user.mobileNo = json['mobileNo'] != null ? json['mobileNo'] : null;
    user.password = json['password'] != null ? json['password'] : null;
    return user;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['isGoogleUser'] = this.isGoogleUser;
    data['lastSignOn'] = this.lastSignOn;
    data['nickName'] = this.nickName;
    data['photoUrl'] = this.photoUrl;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['mobileNo'] = this.mobileNo;
    data['password'] = this.password;
    return data;
  }

  static Map<String, dynamic> toMap(User user) {
    return {
      'id': user.id,
      'email': user.email,
      'isGoogleUser': user.isGoogleUser,
      'lastSignOn': user.lastSignOn,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'mobileNo': user.mobileNo,
      'password': user.password,
      'photoUrl': user.photoUrl,
      'nickName': user.nickName,
    };
  }
}

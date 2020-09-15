import 'package:construct/model/organization.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Status {
  static const String BUY = 'buy';
  static const String MAINTENANCE = 'maintenance';
  static const String HELP = 'help';
}

class User {
  String uid;
  String name;
  String email;
  String number;
  String imgProfile;
  Organization organization;

  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String NUMBER = 'number';
  static const String STATUS = 'status';
  static const String IMAGE = 'imgProfile';
  static const String ORG = 'organization';

  User();

  User.fromFirebase(FirebaseUser user) {
    if(user == null) return;

    this.uid = user.uid;
    this.email = user.email;
    this.name = user.displayName;
    this.number = user.phoneNumber;
    this.imgProfile = user.photoUrl;
  }

  User.fromFirestore({String uid, Map<String, dynamic> map, Organization org}) {
    this.uid = uid;
    this.name = map[NAME];
    this.email = map[EMAIL];
    this.number = map[NUMBER];
    this.imgProfile = map[IMAGE];

    if(org != null) {
      this.organization = org;
    }
  }

  String getSubName() {
    if(name.length < 25) return name;
    String _n = name.substring(0, 22);
    _n += '...';
    return _n;
  }

  String getSubEmail() {
    if(email.length < 29) return email;
    String _e = email.substring(0, 27);
    _e += '...';
    return _e;
  }

  bool isEmpty() {
    return uid == null || uid.isEmpty
        || name == null || name.isEmpty
        || email == null || email.isEmpty;
  }

  bool isNotEmpty() {
    return !this.isEmpty();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              uid == other.uid &&
              name == other.name &&
              email == other.email &&
              number == other.number &&
              imgProfile == other.imgProfile;

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      number.hashCode ^
      imgProfile.hashCode;

  @override
  String toString() {
    return 'User{uid: $uid, _name: $name'
        ', _email: $email'
        ', _number: $number'
        ', _imgProfile: $imgProfile}';
  }
}

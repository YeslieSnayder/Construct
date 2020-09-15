import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construct/services/firestore.dart';

import 'user.dart';

class Room {
  String id;
  String name;
  List<User> users;

  static const String NAME = 'name';
  static const String USERS = 'users';

  Room.fromFirestore({this.id, this.users, this.name});

  getUser(String uid) async =>
      await DBService()
          .getUserData(uid)
          .then((user) => this.users.add(user), onError: (e) => print(e));

  Map<String, dynamic> toMap() {
    List<String> users = List();
    this.users.map((user) => users.add(user.uid));

    return {
      NAME: this.name,
      USERS: users
    };
  }
}

class Message {
  String text;
  Timestamp time;
  String senderUid;

  static const String TEXT = 'text';
  static const String TIME = 'time';
  static const String USER = 'user';

  Message({this.text, this.time, this.senderUid});

  Message.fromFirestore(Map<String, dynamic> map) {
    this.text = map[TEXT];
    this.time = map[TIME];
    this.senderUid = map[USER];
  }

  Map<String, dynamic> toMap() {
    return {
      TEXT: text,
      TIME: time,
      USER: senderUid
    };
  }
}

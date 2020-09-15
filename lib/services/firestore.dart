import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construct/model/item.dart';
import 'package:construct/model/message.dart';
import 'package:construct/model/organization.dart';
import 'package:construct/model/user.dart';

class DBService {
  final CollectionReference users = Firestore.instance.collection('users');
  final CollectionReference rooms = Firestore.instance.collection('rooms');
  final CollectionReference products =
      Firestore.instance.collection('products');
  final CollectionReference organizations =
      Firestore.instance.collection('suppliers');

  Future<void> sendMessage(String roomId, String msgText, String sender) async {
    Message msg =
    Message(text: msgText, time: Timestamp.now(), senderUid: sender);
    await rooms.document(roomId).collection('messages').add(msg.toMap());
  }

  Future<User> addOrUpdateUser(User user) async {
    try {
      await users.document(user.uid).setData(<String, dynamic>{
        User.NAME: user.name,
        User.EMAIL: user.email,
        User.NUMBER: user.number,
        User.IMAGE: user.imgProfile,
        User.ORG: user.organization
      });

      return await getUserData(user.uid);
    } catch (e) {
      print('ERROR (firestore.dart/addOrUpdateUser): $e');
      return null;
    }
  }

  Future<User> getUserData(String uid) async {
    try {
      final DocumentSnapshot doc = await users.document(uid).get();
      final Organization org = await getOrganization(doc.data[User.ORG]);

      return User.fromFirestore(uid: uid, map: doc.data, org: org);
    } catch (e) {
      print('ERROR (firestore.dart/getUserData): $e');
      return null;
    }
  }

  Future<User> getManagerData(String org, String status) async {
    return await users
        .where(User.ORG, isEqualTo: org)
        .where(User.STATUS, isEqualTo: status)
        .getDocuments()
        .then((event) async {
      if (event.documents.isNotEmpty)
        return getUserData(event.documents.first.documentID);
      else {
        print('---------  User isn\'t found  -----------');
        return null;
      }
    }).catchError((e) => print('ERROR (firestore.dart/getManager): $e'));
  }

  Future<Room> addOrUpdateRoom(String user1, String user2, String name) async {
    try {
      await rooms.document().setData(<String, dynamic>{
        Room.NAME: name,
        Room.USERS: [user1, user2],
      });
      return await getRoom(user1, user2, name);
    } catch (e) {
      print('ERROR (firestore.dart/addOrUpdateRoom): $e');
      return null;
    }
  }

  Future<Room> getRoom(String user1, String user2, String org) async {
    try {
      final QuerySnapshot event = await rooms
          .where(Room.USERS, isEqualTo: [user1, user2]).getDocuments();

      if (event.documents.isEmpty)
        return addOrUpdateRoom(user1, user2, org);
      else {
        final DocumentSnapshot doc = event.documents.single;

        List<User> users = List();
        for (String uid in doc.data[Room.USERS]) {
          users.add(await getUserData(uid));
        }

        return Room.fromFirestore(
            id: doc.documentID, users: users, name: doc.data[Room.NAME]);
      }
    } catch (e) {
      print('ERROR (firestore.dart/getRoom): $e');
      return null;
    }
  }

  Future<Organization> getOrganization(String name) async {
    return await organizations
        .where(Organization.NAME, isEqualTo: name)
        .getDocuments()
        .then((event) {
      if (event.documents.isNotEmpty)
        return Organization.fromFirestore(event.documents.single.data);
      else {
        print('---------  Organization isn\'t found  -----------');
        return null;
      }
    }).catchError((e) => print('ERROR (firestore.dart/getOrganization): $e'));
  }

  Stream<List<Item>> getProducts(
      {int minPrice, int maxPrice, List<String> orgs}) {
    Query query = products;
    if (minPrice != null)
      query = query.where(Item.PRICE, isGreaterThanOrEqualTo: minPrice);
    if (maxPrice != null)
      query = query.where(Item.PRICE, isLessThanOrEqualTo: maxPrice);
    if (orgs != null) query = query.where(Item.ORG, whereIn: orgs);

    return query.snapshots().map((data)
          => data.documents.map((doc)
            => Item.fromFirestore(doc.data)).toList());
  }

  Stream<List<Future<Room>>> getRooms(User user) {
    Query query = rooms.where(Room.USERS, arrayContainsAny: [user.uid]);
    return query
        .snapshots()
        .map((QuerySnapshot data) => data.documents.map((doc) async {
              List<User> users = List();
              for (String uid in doc.data[Room.USERS]) {
                users.add(await getUserData(uid));
              }
              return Room.fromFirestore(
                  id: doc.documentID, name: doc.data[Room.NAME], users: users);
            }).toList());
  }

  Stream<List<Message>> getMessages(String roomID) {
    return rooms
        .document(roomID)
        .collection('messages')
        .snapshots()
        .map((data) {
      if (data.documents.isEmpty) {
        print('Messages isn\'t found');
      }
      return data.documents.map((d) => Message.fromFirestore(d.data)).toList();
    });
  }
}

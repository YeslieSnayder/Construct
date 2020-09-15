import 'package:construct/constant.dart';
import 'package:construct/model/message.dart';
import 'package:construct/model/user.dart';
import 'file:///D:/AndroidStudioProjects/construction/lib/pages/chat/chatPage.dart';
import 'package:construct/services/auth.dart';
import 'package:construct/services/firestore.dart';
import 'package:flutter/material.dart';

class ListRoomsPage extends StatefulWidget {
  @override
  _ListRoomsPageState createState() => _ListRoomsPageState();
}

class _ListRoomsPageState extends State<ListRoomsPage> {
  List<Room> rooms;
  User _user;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Сообщения'),
      ),
      body: (rooms == null)
          ? Center(child: CircularProgressIndicator())
          : (rooms.length == 0)
              ? Center(
                  child: Text(
                  'Здесь пока нет диалогов',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor),
                ))
              : ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    return _listItem(context, rooms[index]);
                  }),
    );
  }

  Widget _listItem(BuildContext context, Room room) {
    User partner;
    for (User u in room.users) {
      if (u.uid != _user.uid) {
        partner = u;
        break;
      }
    }

    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (ctx) => ChatPage(
                      room: room,
                      partner: partner,
                      isOrg: false,
                    )));
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.transparent,
                backgroundImage: (partner == null ||
                        partner.imgProfile == null ||
                        partner.imgProfile.isEmpty)
                    ? AssetImage('assets/images/profile.png')
                    : NetworkImage(partner.imgProfile),
              ),
            ),
            Flexible(
              child: Text(
                room.name,
                style: TextStyle(
                    fontFamily: 'Rubik', fontSize: 18.0, color: kPrimaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  getUser() async {
    await AuthService().user.then((val) {
      setState(() {
        _user = val;
      });
    });
  }

  loadData() async {
    if (_user == null) return;
    var stream = DBService().getRooms(_user);
    stream.listen((List<Future<Room>> futures) async {
      List<Room> rooms = List();
      for(Future<Room> future in futures) {
        rooms.add(await future);
      }
      setState(() {
        this.rooms = rooms;
      });
    });
  }
}

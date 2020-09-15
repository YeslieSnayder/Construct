import 'package:construct/constant.dart';
import 'package:construct/model/message.dart';
import 'package:construct/model/user.dart';
import 'package:construct/services/auth.dart';
import 'package:construct/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  User currentUser;
  User partner;
  Room room;
  String organization;
  String status;
  bool isOrg;
  ChatPage({this.room, this.partner, this.isOrg,
    this.organization, this.status});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<Message> messages;

  @override
  void initState() {
    getUser();
    loadRoom();
    loadData();
    super.initState();
  }

  loadRoom() async {
    if (!widget.isOrg) return;

    User partner = await DBService().getManagerData(widget.organization, widget.status);
    Room room = await DBService()
        .getRoom(widget.currentUser.uid, partner.uid, widget.organization);
    setState(() {
      widget.partner = partner;
      widget.room = room;
      widget.isOrg = false;
    });
  }

  loadData() async {
    if (widget.isOrg) return;

    var stream = DBService().getMessages(widget.room.id);
    stream.listen((List<Message> messages) {
      setState(() {
        this.messages = messages;
        this.messages.sort((a, b) => a.time.compareTo(b.time));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: (widget.room == null || widget.partner == null)
                  ? Center(child: CircularProgressIndicator())
                  : (messages == null || messages.isEmpty)
                      ? Center(
                          child: Text(
                            'Здесь пока нет сообщений',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: kPrimaryColor),
                          ),
                        )
                      : ListView(
                          controller: scrollController,
                          children: _messages(),
                        ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      onFieldSubmitted: (val) => callback(),
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: 'Enter your message',
                          border: const OutlineInputBorder()),
                    ),
                  ),
                  SendButton(
                    icon: Icon(Icons.send),
                    callback: callback,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      title: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
                radius: 24.0,
                backgroundColor: Colors.transparent,
                backgroundImage: (widget.partner == null ||
                        widget.partner.imgProfile == null ||
                        widget.partner.imgProfile.isEmpty)
                    ? AssetImage('assets/images/profile.png')
                    : NetworkImage(widget.partner.imgProfile)),
          ),
          Text(
            (widget.room == null || widget.room.name == null)
                ? 'Loading...'
                : widget.partner.name,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 18.0,
            ),
          )
        ],
      ),
    );
  }

  _messages() {
    List<Widget> list = List();
    for (Message msg in messages) {
      bool me = msg.senderUid != null &&
          msg.senderUid.contains(widget.currentUser.uid);
      list.add(MessageWidget(
        text: msg.text,
        isMe: me,
        isCollapse: false,
        from: me
            ? widget.currentUser.imgProfile != null &&
                    widget.currentUser.imgProfile.isNotEmpty
                ? NetworkImage(widget.currentUser.imgProfile)
                : AssetImage('assets/images/profile.png')
            : widget.partner != null &&
                    widget.partner.imgProfile != null &&
                    widget.partner.isNotEmpty()
                ? NetworkImage(widget.partner.imgProfile)
                : AssetImage('assets/images/profile.png'),
      ));
    }
    return list;
  }

  Future<void> callback() async {
    if (messageController.text.length > 0) {
      await DBService().sendMessage(
          widget.room.id, messageController.text, widget.currentUser.uid);
      messageController.clear();
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(microseconds: 300), curve: Curves.easeOut);
    }
  }

  getUser() async {
    await AuthService().user.then((val) {
      setState(() {
        widget.currentUser = val;
      });
    });
  }
}

class SendButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback callback;
  SendButton({this.icon, this.callback});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.white,
      onPressed: callback,
      child: icon,
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final ImageProvider from;
  final bool isMe;
  final bool isCollapse;

  MessageWidget({this.text, this.from, this.isMe, this.isCollapse});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          isMe ? _messages(context) : _picture(),
          isMe ? _picture() : _messages(context),
        ],
      ),
    );
  }

  _messages(BuildContext context) {
    var _width = MediaQuery.of(context).size.width / 3 * 2;
    return Container(
      width: _width,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Material(
              color: isMe ? kPrimaryColor : Colors.white,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                      bottomLeft: isMe ? Radius.circular(16.0) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : Radius.circular(16.0)),
                  side: BorderSide()),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Text(
                  text,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 17.0,
                      color: isMe ? Colors.white : kPrimaryColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _picture() {
    return CircleAvatar(
      radius: 24.0,
      backgroundColor: kExtraColor,
      backgroundImage: from,
    );
  }
}

import 'package:construct/constant.dart';
import 'package:construct/model/user.dart';
import 'file:///D:/AndroidStudioProjects/construction/lib/pages/chat/chatPage.dart';
import 'package:construct/pages/details/Description.dart';
import 'package:construct/pages/details/Features.dart';
import 'package:construct/pages/details/Purchase.dart';
import 'package:construct/model/item.dart';
import 'package:construct/widgets/CollapsedAppBar.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  Item item;

  DetailPage({this.item});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _currentIndex = 0;
  bool _showFab = true;
  List<Widget> tabs = [];

  @override
  void initState() {
    tabs = [
      Description(widget.item.getFullDescription()),
      Features(widget.item.mainFeatures, widget.item.extraFeatures,
          widget.item.hasMainFeatures(), widget.item.hasExtraFeatures()),
      Purchase(widget.item)
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body: CollapsedAppBar(
          bodyWidget: tabs[_currentIndex],
          fab: fab(context),
          showFab: _showFab,
          imageUrl: widget.item.imgUrl,
        ),
        bottomNavigationBar: _bottomNavigationBar());
  }

  _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      backgroundColor: kAppBarColor,
      selectedItemColor: kSelectedTabColor,
      selectedIconTheme: IconThemeData(color: kSelectedTabColor),
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.description,
          ),
          title: Text('Описание'),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.assessment,
          ),
          title: Text('Характеристики'),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_cart,
          ),
          title: Text('Заказ'),
        ),
      ],
      onTap: (index) {
        setState(() {
          if (index == 2)
            _showFab = false;
          else
            _showFab = true;

          _currentIndex = index;
        });
      },
    );
  }

  fab(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.chat,
        color: Colors.white,
      ),
      backgroundColor: kPrimaryColor,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) =>
                    ChatPage(
                      organization: widget.item.organization,
                      status: Status.HELP,
                      isOrg: true,
                    )));
      },
    );
  }
}

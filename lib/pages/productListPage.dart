import 'package:construct/constant.dart';
import 'package:construct/model/user.dart';
import 'package:construct/pages/details/DetailsItem.dart';
import 'package:construct/model/item.dart';
import 'package:construct/pages/filter.dart';
import 'package:construct/services/auth.dart';
import 'package:construct/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../widgets/DiamondFab.dart';
import 'chat/roomListPage.dart';
import 'login/LoginPage.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Item> items;

  Stream<List<Item>> _stream;
  FilterPage _filterPage;
  User _user;

  @override
  void initState() {
    items = List<Item>();
    _getUser();
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_filterPage == null)
      _filterPage = FilterPage(
          context: context, stream: _stream, items: items, setState: setState);
    else
      loadData();

    return Scaffold(
      body: _body(),
      bottomNavigationBar: _buildBottomAppBar(),
      floatingActionButton: DiamondFab(
        child: Icon(
          Icons.filter_list,
          color: Colors.white,
        ),
        backgroundColor: kButtonColor,
        onPressed: () {
          _filterPage.build();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _body() {
    ListView listView = ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return listItem(items[index]);
        });

    if (items.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return listView;
  }

  Widget listItem(Item item) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: width / 360 * 133,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(16.0),
                width: width / 360 * 100,
                height: width / 360 * 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(19)),
                    image: DecorationImage(
                      image: (item.imgUrl == null ||
                              item.imgUrl.isEmpty ||
                              item.imgUrl == 'null')
                          ? AssetImage('assets/images/solar_panel.png')
                          : NetworkImage(item.imgUrl),
                    )),
              ),
              Container(
                width: width / 360 * 156,
                height: width / 360 * 108,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.productName,
                      maxLines: 3,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                          color: kPrimaryColor),
                    ),
                    SizedBox(height: 2),
                    Text(
                      item.organization,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 14,
                          color: kPrimaryColor),
                    )
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    height: width / 360 * 68,
                    width: width / 360 * 60,
                    margin: EdgeInsets.only(
                        right: width / 360 * 12, top: width / 360 * 12),
                    alignment: Alignment.topRight,
                    child: Text(
                      item.getPriceString() + ' руб.',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: kPrimaryColor),
                    ),
                  ),
                  Container(
                    child: RawMaterialButton(
                      constraints: BoxConstraints.expand(
                          width: width / 360 * 52, height: width / 360 * 26),
                      fillColor: Colors.white,
                      child: Align(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'OPEN',
                              maxLines: 1,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(item: item)));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        side: BorderSide(),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: width / 360 * 344,
              height: 1,
              color: kExtraColor,
            ),
          )
        ],
      ),
    );
  }

  _buildBottomAppBar() {
    return BottomAppBar(
      color: kAppBarColor,
      shape: DiamondFab.notchedShape,
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  color: kPrimaryColor,
                  icon: Icon(Icons.sort),
                  onPressed: () => _showProfileInfo(context))
            ],
          ),
          SizedBox(width: 1),
          Row(
            children: <Widget>[
              IconButton(
                color: kPrimaryColor,
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _showSearchView(context);
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  _showProfileInfo(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Drawer(
              child: Column(
                children: <Widget>[
                  (_user != null && _user.isNotEmpty())
                      ? Container(
                          height: 80.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  (_user.imgProfile == null ||
                                          _user.imgProfile.isEmpty)
                                      ? FadeInImage.assetNetwork(
                                          placeholder: 'assets/images/profile.png',
                                          image: 'assets/images/profile.png',
                                          height: 50.0,
                                          width: 50.0,
                                        )
                                      : FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: _user.imgProfile,
                                          width: 50.0,
                                          height: 50.0,
                                        ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(_user.getSubName(),
                                          style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontSize: 20.0)),
                                      SizedBox(height: 4.0),
                                      Text(
                                        _user.getSubEmail(),
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18.0),
                                      )
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, size: 30.0),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Container(
                                height: 4.0,
                                decoration:
                                    BoxDecoration(color: Colors.grey[400]),
                              )
                            ],
                          ),
                        )
                      : Container(),
                  Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.message),
                        title: Text('Сообщения'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListRoomsPage()));
                        },
                      ),
                      ListTile(
                        enabled: false,
                        leading: Icon(Icons.settings),
                        title: Text('Настройки'),
                        onTap: () {
                          print('Settings');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.sync),
                        title: Text('Сменить пользователя'),
                        onTap: () {
                          AuthService().logOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ));
  }

  _showSearchView(BuildContext context) {
    var subList = items;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15.0),
                          hintText: 'Filter at name'),
                      onChanged: (text) {
                        setState(() {
                          if (text.length > 0) {
                            subList = items
                                .where((item) => (item.productName
                                    .toLowerCase()
                                    .contains(text.toLowerCase())))
                                .toList();
                          } else {
                            subList = items;
                          }
                        });
                      },
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: subList.length,
                            itemBuilder: (context, index) {
                              return listItem(subList[index]);
                            })),
                  ],
                );
              },
            ));
  }

  _getUser() async {
    await AuthService().user.then((val) {
      setState(() {
        _user = val;
      });
    });
  }

  loadData() async {
    if (_filterPage != null) {
      _stream = DBService().getProducts(
          minPrice: _filterPage.priceFilterValue.start > FilterPage.MIN_PRICE
              ? _filterPage.priceFilterValue.start.toInt()
              : null,
          maxPrice: _filterPage.priceFilterValue.end < FilterPage.MAX_PRICE
              ? _filterPage.priceFilterValue.end.toInt()
              : null,
          orgs: _filterPage.filterCompanies.isNotEmpty
              ? _filterPage.filterCompanies
              : null);
    } else
      _stream = DBService().getProducts();

    _stream.listen((List<Item> data) {
      setState(() {
        items = data;
      });
    });
  }
}

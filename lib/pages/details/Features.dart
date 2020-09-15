import 'package:construct/constant.dart';
import 'package:flutter/material.dart';

class Features extends StatelessWidget {
  BuildContext _context;
  Map<String, dynamic> main;
  Map<String, dynamic> extra;
  bool hasMainFeatures;
  bool hasExtraFeatures;

  Features(this.main, this.extra, this.hasMainFeatures, this.hasExtraFeatures);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 50, left: 16, right: 5),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (hasMainFeatures)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _features(main, 'Главные')
            )
          : Container(
              padding: EdgeInsets.only(top: 20, bottom: 8, left: 10),
              child: Text(
                'Характеристики отсутствуют',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24.0,
                  color: kPrimaryColor
                ),
              ),
          ),
          (hasExtraFeatures && hasMainFeatures)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _features(extra, 'Дополнительно')
            )
          : Container()
        ],
      )
    );
  }

  _features(Map<String, dynamic> map, String text) {
    List<Widget> list = [
      Container(
        padding: EdgeInsets.only(top: 10, bottom: 8, left: 10),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24.0,
            color: kPrimaryColor
          ),
        ),
      ),
    ];
    map.forEach((key, value) {
      print('key = $key, value = $value');
      list.add(_listItem(key, value));
    });
    return list;
  }

  _listItem(String key, dynamic value) {
    print('key = $key, value = $value');
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  key,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontFamily: 'Roboto',
                    fontSize: 16,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(top: 2),
              width: MediaQuery.of(_context).size.width,
              height: 1,
              color: kExtraColor,
            ),
          )
        ],
      ),
    );
  }
}

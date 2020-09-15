import 'package:construct/constant.dart';
import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  String description;

  Description(this.description);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: 18.0, left: 26.0),
            child: Text(
              'Описание',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24.0,
                color: kPrimaryColor
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0, left: 16.0, right: 12.0),
            child: Text(
                description,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 18.0
              ),
            ),
          )
        ],
      )
    );
  }
}

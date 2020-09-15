import 'package:flutter/material.dart';

import '../constant.dart';

class PurchaseButton extends StatelessWidget {
  String text;
  double width;
  bool isDark;

  PurchaseButton({this.text, this.isDark, this.width, @required this.onPressed()});
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    double heightB = MediaQuery.of(context).size.height / 640 * 45;
    double widthB = MediaQuery.of(context).size.width / 360 + width;

    return RawMaterialButton(
      constraints: BoxConstraints.expand(width: widthB, height: heightB),
      fillColor: isDark
          ? Theme.of(context).buttonColor
          : Colors.white,
      child: Align(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              text,
              maxLines: 1,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  color: isDark
                      ? Colors.white
                      : Colors.black),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero),
        side: BorderSide(
          color: kButtonColor,
          width: 1.5,
        ),
      ),
    );
  }
}

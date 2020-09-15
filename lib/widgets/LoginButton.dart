import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  String text;
  bool isDark;

  LoginButton({this.text, this.isDark, @required this.onPressed()});
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.expand(width: 180, height: 48),
      fillColor: isDark
          ? Theme.of(context).buttonColor
          : Theme.of(context).backgroundColor,
      child: Align(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              text,
              maxLines: 1,
              style: TextStyle(fontSize: 23,
                  color: isDark
                      ? Colors.white
                      : Colors.black),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(26)),
          side: BorderSide()
      ),
    );
  }
}
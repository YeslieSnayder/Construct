import 'package:construct/constant.dart';
import 'package:construct/model/item.dart';
import 'package:construct/model/user.dart';
import 'package:construct/pages/chat/chatPage.dart';
import 'package:construct/widgets/PurchaseButton.dart';
import 'package:flutter/material.dart';

class Purchase extends StatelessWidget {
  Item item;

  Purchase(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 18),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: _AngleBorder(context)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Text(
                  item.productName,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 24.0,
                    color: kPrimaryColor
                  ),
                ),
              ),
              Text(
                '${item.count} pcs',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                  color: kPrimaryColor
                ),
              )
            ],
          ),
          SizedBox(height: 4),
          Text(
            '${item.getPriceString()} руб.',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w300,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 45),
          PurchaseButton(
            text: 'Тех. обслуживание',
            isDark: false,
            width: MediaQuery.of(context).size.width / 360.0 * 331.0,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          ChatPage(
                            organization: item.organization,
                            status: Status.MAINTENANCE,
                            isOrg: true,
                          )));
            },
          ),
          SizedBox(height: 8),
          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
//              PurchaseButton(
//                text: 'В корзину',
//                isDark: true,
//                width: MediaQuery.of(context).size.width / 360.0 * 120.0,
//                onPressed: () {
//                  print('в корзину');
//                },
//              ),
              PurchaseButton(
                text: 'Купить',
                isDark: true,
                width: MediaQuery.of(context).size.width / 360.0 * 100.0,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) =>
                              ChatPage(
                                organization: item.organization,
                                status: Status.BUY,
                                isOrg: true,
                              )));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _AngleBorder extends ShapeBorder {
  _AngleBorder(this._ctx);

  BuildContext _ctx;

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection textDirection }) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection textDirection }) {
    double rectHeight = MediaQuery.of(_ctx).size.height / 640.0 * 280.0;
    double heightAngle = rectHeight / 10.0;
    double widthAngle = rect.width / 16.0;
    return Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.left, rect.top + rectHeight - heightAngle)
      ..lineTo(rect.left + widthAngle, rect.top + rectHeight)
      ..lineTo(rect.left + widthAngle * 2, rect.top + rectHeight - heightAngle)
      ..lineTo(rect.left + widthAngle * 3, rect.top + rectHeight)
      ..lineTo(rect.left + widthAngle * 4, rect.top + rectHeight - heightAngle)
      ..lineTo(rect.left + widthAngle * 5, rect.top + rectHeight)
      ..lineTo(rect.left + widthAngle * 6, rect.top + rectHeight - heightAngle)
      ..lineTo(rect.left + widthAngle * 7, rect.top + rectHeight)
      ..lineTo(rect.left + widthAngle * 8, rect.top + rectHeight - heightAngle)
      ..lineTo(rect.left + widthAngle * 9, rect.top + rectHeight)
      ..lineTo(rect.left + widthAngle * 10, rect.top + rectHeight - heightAngle)
      ..lineTo(rect.left + widthAngle * 11, rect.top + rectHeight)
      ..lineTo(rect.left + widthAngle * 12, rect.top + rectHeight - heightAngle)
      ..lineTo(rect.left + widthAngle * 13, rect.top + rectHeight)
      ..lineTo(rect.left + widthAngle * 14, rect.top + rectHeight - heightAngle)
      ..lineTo(rect.left + widthAngle * 15, rect.top + rectHeight)
      ..lineTo(rect.right, rect.top + rectHeight - heightAngle)
      ..lineTo(rect.right, rect.top)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection textDirection }) {}

  // This border doesn't support scaling.
  @override
  ShapeBorder scale(double t) {
    return null;
  }
}

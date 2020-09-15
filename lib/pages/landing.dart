import 'package:construct/model/user.dart';
import 'package:construct/pages/productListPage.dart';
import 'package:construct/pages/login/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of(context);
    return user == null ? LoginPage() : ProductsPage();
  }
}

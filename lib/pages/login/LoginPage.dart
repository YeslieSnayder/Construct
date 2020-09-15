import 'package:construct/model/user.dart';
import 'package:construct/pages/productListPage.dart';
import 'package:construct/pages/login/RegisterPage.dart';
import 'package:construct/services/auth.dart';
import 'package:construct/widgets/InputField.dart';
import 'package:construct/widgets/LoginButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constant.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  BuildContext _context;
  AuthService _authService;
  Scaffold _scaffold;
  bool isLoading = false;

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _context = context;
    _authService = AuthService();
    _scaffold = Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Align(
            child: Column(
              children: <Widget>[
                _logo(),
                _loadingCircle(),
                _inputFields(),
                _buttons(),
                SizedBox(height: 30),
                Container(
                  width: 145,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border(
                      top: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _googleButton(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ));
    return _scaffold;
  }

  Widget _logo() {
    return Container(
      padding: EdgeInsets.only(top: 120),
      child: Text(
        'WELCOME',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 26,
        ),
      ),
    );
  }

  _loadingCircle() {
    return isLoading
        ? Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                SizedBox(height: 35),
                CircularProgressIndicator(),
              ],
            ))
        : SizedBox(height: 71);
  }

  Widget _inputFields() {
    return Container(
      padding: EdgeInsets.only(top: 9, left: 68, right: 68),
      child: Column(
        children: <Widget>[
          InputField(
            controller: _emailController,
            hint: 'Email',
            type: TextInputType.emailAddress,
            style: fieldStyle,
            isHidden: false,
          ),
          InputField(
            controller: _passwordController,
            hint: 'Password',
            style: fieldStyle,
            isHidden: true,
          )
        ],
      ),
    );
  }

  Widget _buttons() {
    return Container(
      padding: EdgeInsets.only(top: 37),
      child: Column(
        children: <Widget>[
          LoginButton(
            text: 'LOGIN',
            isDark: true,
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              signInUser();
            },
          ),
          SizedBox(
            height: 16,
          ),
          LoginButton(
            text: 'REGISTER',
            isDark: false,
            onPressed: () {
              Navigator.push(
                  _context, CustomRoute(builder: (context) => RegisterPage()));
            },
          )
        ],
      ),
    );
  }

  Widget _googleButton() {
    return SignInButton(
      Buttons.Google,
      text: 'Sign in with Google',
      onPressed: () {
        signInWithGoogle();
      },
    );
  }

  signInWithGoogle() async =>
      _authService.signInWithGoogle().whenComplete(() => updateUI());

  signInUser() async {
    String errEmail = checkEmail();
    String errPassword = checkPassword();
    if (errEmail.isNotEmpty || errPassword.isNotEmpty) {
      //TODO: Выписывать ошибку в поле для пользователя
      print(errEmail);
      print(errPassword);
      showSnackbar('Ошибка ввода данных');
      return;
    }

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    User user = await _authService
        .signInWithEmailAndPassword(email, password)
        .catchError((e) {
      showSnackbar('Ошибка входа: $e');
    });

    setState(() {
      isLoading = false;
    });
    if (user == null) {
      showSnackbar('Неверные данные:\nПроверьте правильность введенных данных');
    } else {
      _emailController.clear();
      _passwordController.clear();
      updateUI();
    }
  }

  showSnackbar(String text) {
//    Scaffold.of(_context).showSnackBar(SnackBar(
//      content: Text(text),
//    ));
    print('Show snackbar: $text');
    setState(() {
      isLoading = false;
    });
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  updateUI() {
    Navigator.push(
        _context, MaterialPageRoute(builder: (context) => ProductsPage()));
  }

  /// Возвращает ошибку ввода email, в случае неправильного email.
  /// Возвращает пустую строку [''] в случае правильного email.
  String checkEmail() {
    final String email = _emailController.text;
    if (email.isEmpty) return 'Введите email';

    if (!email.contains('@') || email.indexOf('@') + 1 == email.length)
      return 'Email должен содержать доменное имя';

    final String domen = email.substring(email.indexOf('@') + 1);
    if (!domen.contains('.'))
      return 'Email должен содержать правильное доменное имя';

    return '';
  }

  /// Возвращает ошибку ввода пароля, в случае неправильного ввода пароля.
  /// Возвращает пустую строку [''] в случае правильного ввода пароля.
  String checkPassword() {
    String pass = _passwordController.text;
    if (pass.isEmpty) return 'Введите пароль';

    if (pass.length < 6) return 'Пароль должен состоять минимум из 6 символов';
//    if (!pass.contains(RegExp(r"^[a-z]+")) ||
//        !pass.contains(RegExp(r"^[A-Z]+")) ||
//        !pass.contains(RegExp(r"^[0-9]+"))) {
//      return 'Пароль должен содержать минимум 1 загланую и строчную буквы и цифры';
//    }

    return '';
  }
}

class CustomRoute extends MaterialPageRoute {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final tween = Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.ease));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}

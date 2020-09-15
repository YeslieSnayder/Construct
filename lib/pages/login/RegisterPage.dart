import 'package:construct/model/user.dart';
import 'package:construct/services/auth.dart';
import 'package:construct/widgets/InputField.dart';
import 'package:construct/widgets/LoginButton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constant.dart';
import '../productListPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<RegisterPage> {
  BuildContext _context;

  final AuthService _authService = AuthService();
  var _formKey = GlobalKey<FormState>();
  bool _showExtra = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  TextEditingController _numberController = TextEditingController();
  TextEditingController _organizationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Create new account',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.only(top: 80, left: 68, right: 68),
          child: Align(
            child: Column(
              children: <Widget>[
                _inputFields(),
                _extraButton(),
                _extraFields(),
                _registerButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputFields() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InputField(
              controller: _emailController,
              hint: "Email",
              type: TextInputType.emailAddress,
              isHidden: false,
              style: fieldStyle,
            ),
            InputField(
              controller: _nicknameController,
              hint: "Nickname",
              type: TextInputType.text,
              isHidden: false,
              style: fieldStyle,
            ),
            InputField(
              controller: _passwordController,
              hint: "Password",
              isHidden: true,
              style: fieldStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _extraButton() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: InkWell(
        onTap: () {
          setState(() {
            _showExtra = !_showExtra;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Дополнительно",
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            Icon(_showExtra
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down
            )
          ],
        ),
      ),
    );
  }

  Widget _extraFields() {
    if(!_showExtra) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Column(
        children: <Widget>[
          InputField(
            controller: _numberController,
            hint: "Номер телефона",
            type: TextInputType.number,
            isHidden: false,
            style: fieldStyle,
          ),
          InputField(
            controller: _organizationController,
            hint: "Организация",
            isHidden: false,
            style: fieldStyle,
          ),
        ],
      ),
    );
  }

  Widget _registerButton() {
    return Padding(
      padding: _showExtra
          ? EdgeInsets.only(top: 26, bottom: 20)
          : EdgeInsets.only(top: 140, bottom: 20),
      child: LoginButton(
        text: 'REGISTER',
        isDark: false,
        onPressed: () {
          setState(() {
            if(_formKey.currentState.validate()) {
              register();
            }
          });
        },
      ),
    );
  }

  register() async {
    String errEmail = checkEmail();
    String errPass = checkPassword();
    String errName = checkNickname();
    if(errEmail.isNotEmpty || errPass.isNotEmpty || errName.isNotEmpty) {
      showSnackbar(errEmail ?? errPass ?? errName);
      return;
    }
    String errNumber = checkNumber();
    String errOrg = checkOrganization();
    if(_showExtra && (errNumber.isNotEmpty || errOrg.isNotEmpty)) {
      showSnackbar(errNumber ?? errOrg);
      return;
    }

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String userName = _nicknameController.text.trim();
    String org = _organizationController.text.trim();
    String phoneNumber = _numberController.text.trim();

    User user = await _authService.registerWithEmailAndPassword(
        email, password, userName, phoneNumber, org)
    .catchError((e) => showSnackbar('Ошибка регистрации: $e'));

    if(user == null) {
      showSnackbar('Неизвестная ошибка');
    } else {
      _emailController.clear();
      _passwordController.clear();
      _nicknameController.clear();
      _numberController.clear();
      _organizationController.clear();

      updateUI();
    }
  }

  showSnackbar(String text) {
//    Scaffold.of(_context).showSnackBar(SnackBar(
//      content: Text(text),
//    ));
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
    Navigator.pushReplacement(
        _context, MaterialPageRoute(builder: (context) => ProductsPage()));
  }

  String checkEmail() {
    String email = _emailController.text;
    if (email.isEmpty) return 'Введите email';

    if (!email.contains('@') || email.indexOf('@') + 1 == email.length)
      return 'Email должен содержать доменное имя';

    String domen = email.substring(email.indexOf('@') + 1);
    if (!domen.contains('.'))
      return 'Email должен содержать правильное доменное имя';

    return '';
  }

  String checkPassword() {
    String pass = _passwordController.text;
    if (pass.isEmpty) return 'Введите пароль';

    if (pass.length < 6) return 'Пароль должен состоять минимум из 6 символов';
//    if (pass.contains(RegExp(r"^[a-z]+")) ||
//        pass.contains(RegExp(r"^[A-Z]+")) ||
//        pass.contains(RegExp(r"^[0-9]+"))) {
//      return 'Пароль должен содержать минимум 1 загланую и строчную буквы и цифры';
//    }

    return '';
  }

  String checkNickname() {
    String nick = _nicknameController.text;
    if(nick.isEmpty) return 'Введите nickname';
    if(nick.length < 4) return 'Имя должно содержать минимум 4 символа';
    return '';
  }

  String checkNumber() {
    String number = _numberController.text;
    if(number.isEmpty) return 'Введите номер телефона';
    // TODO: Check phone number
    return '';
  }

  String checkOrganization() {
    String org = _organizationController.text;
    return '';
  }
}
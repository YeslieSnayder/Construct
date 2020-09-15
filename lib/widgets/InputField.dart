import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final TextStyle style;
  final String hint;

  TextInputType type = TextInputType.text;
  bool isHidden = false;
  dynamic validator;

  InputField({
      this.controller,
      this.hint,
      this.type,
      this.style,
      this.isHidden,
      this.validator});

  @override
  State<StatefulWidget> createState() => InputFieldState(isHidden);
}

class InputFieldState extends State<InputField> {

  bool _isVisible;

  InputFieldState(bool isHidden) {
    _isVisible = isHidden ?? false;
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: widget.controller,
      style: widget.style,
      obscureText: _isVisible,
      keyboardType: widget.type,
      decoration: new InputDecoration(
        labelText: widget.hint,
        suffixIcon: widget.isHidden
            ? IconButton(
                icon: Icon(_isVisible ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                   _toggleVisibility();
                },
          ) : null
      ),
      validator: (val) => widget.validator,
      onSaved: (val) => widget.controller.text = val,
    );
  }
}
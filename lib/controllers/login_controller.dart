import 'package:flutter/material.dart';

class LoginController {
  final _crtlEmail = TextEditingController();
  final _crtlPassword = TextEditingController();

  TextEditingController get crtlEmail => _crtlEmail;
  TextEditingController get crtlPassword => _crtlPassword;
}

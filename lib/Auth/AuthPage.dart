import 'package:audio_call/Auth/LoginPage.dart';
import 'package:flutter/material.dart';

import 'SignUpPage.dart';
class AuthPage extends StatefulWidget{

  _AuthPageState createState() => _AuthPageState();

}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) =>
    isLogin ? LoginPage(onClickedSignUp: toggle) : SignUpPage(
        onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);

}
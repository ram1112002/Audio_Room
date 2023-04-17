import 'dart:async';

import 'package:audio_call/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Utils.dart';

class VerifyEmailPage extends StatefulWidget{
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {


  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  @override
  void initState(){
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
          (_) => checkEmailVerified(),
      );
      if(isEmailVerified) timer?.cancel();
    }
  }
  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }
  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState((){
      isEmailVerified  =FirebaseAuth.instance.currentUser!.emailVerified;

    });
  }
  Future sendVerificationEmail() async{
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);

    }catch(e){
      Utils.showSnackBar(e.toString(),Colors.red);
    }
  }
  @override
  Widget build(BuildContext context) => isEmailVerified? HomePage():
      Scaffold(

        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(child: Image.asset('assets/images/verify.png'),height: 300,alignment: Alignment.topCenter,),
              SizedBox(height: 50,),
              Text(
                "A verification email is sent to your email id",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: GoogleFonts.aladin().fontFamily,
                  fontWeight: FontWeight.bold,

                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50,),
              ElevatedButton.icon(onPressed: canResendEmail? sendVerificationEmail:null, icon: Icon(Icons.email,size: 32,), label: Text("Resent Email", style: TextStyle(fontSize: 20),),style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),),
              SizedBox(height: 20,),
              TextButton(onPressed: () => FirebaseAuth.instance.signOut(), child: Text("Cancel",style: TextStyle(fontSize: 24),))
            ],
          ),
        ),
      );
}
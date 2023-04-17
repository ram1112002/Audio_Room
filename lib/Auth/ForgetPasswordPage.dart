import 'package:audio_call/Auth/Utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordPage extends StatefulWidget{
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>{
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context)=>Scaffold(
    resizeToAvoidBottomInset: false,
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(child:Image.asset('assets/images/forget.png'),height: 300,alignment: Alignment.topCenter,),
              Text("Receive an email to\n reset your Password.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontFamily: GoogleFonts.aladin().fontFamily,
                fontWeight: FontWeight.bold,
                
              ),),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                  email != null && !EmailValidator.validate(email)? 'Enter a valid email':null,

                ),
              ),
              SizedBox(height: 50,),
              ElevatedButton.icon(onPressed: resetPassword, icon: Icon(Icons.email_outlined), label: Text('Reset Password'),style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),),
            ],
          ),
        ),
      ),
    ),

  );
  Future resetPassword() async{
    showDialog(context: context,barrierDismissible: false, builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());
      Utils.showSnackBar('Password Reset Email Sent',Colors.red);
      Navigator.of(context).popUntil((route) => route.isFirst);
    }on FirebaseAuthException catch(e){
      print(e);
      Utils.showSnackBar(e.message,Colors.red);
      Navigator.of(context).pop();
    }
  }
}
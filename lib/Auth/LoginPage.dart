
import 'package:audio_call/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'ForgetPasswordPage.dart';
import 'Utils.dart';

class LoginPage extends StatefulWidget{
  final VoidCallback onClickedSignUp;
  const LoginPage({
    Key? key,
    required this.onClickedSignUp,
}
) :super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool empt = false;

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context)=> Scaffold(

    resizeToAvoidBottomInset: false,
    body: SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
            ),
            Container(child: Image.asset("assets/images/Login.png",height: 200,alignment: Alignment.topCenter,),),


              Padding(
                padding: EdgeInsets.fromLTRB(28, 50, 28, 5),
                child: SizedBox(
                  width: 350,

                  child: TextFormField(

                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0)
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                    email != null && !EmailValidator.validate(email)? 'Enter a valid email':null,

                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(28, 10, 28, 0),
                child: SizedBox(
                  width: 350,
                  child: TextFormField(

                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0)
                    )
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                  value != null && value.length < 6 ? 'Enter min. 6 characters': null,

                  obscureText: true,
                ),
                ),
              ),

          Padding(
            padding: EdgeInsets.fromLTRB(230, 5, 10, 0),
            child: GestureDetector(
              child: Text("Forgot Password?",
              style: TextStyle(
                color: Colors.blue,
                fontSize:15,
                decoration: TextDecoration.underline
              ),),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgetPasswordPage(),
              )),
            ),
          ),
            Padding(padding:EdgeInsets.fromLTRB(50, 40, 50, 0),child: ElevatedButton.icon(onPressed: signIn, icon: Icon(Icons.lock_open), label: Text('LogIn'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50)
            ),)),

            SizedBox(height: 150,),
          RichText(
              text: TextSpan(text: "No Account? ",
          style: TextStyle(
            color: Colors.black ,fontSize: 20
          ),children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                  ..onTap = widget.onClickedSignUp,
              text: "Sign Up",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue
              )
            )
                  ]
          ))
        ],
      ),
  ),
    ));
  Future signIn() async{
    showDialog(context: context,barrierDismissible: false, builder: (context) => Center(child: CircularProgressIndicator(),));
    final isValid = formKey.currentState!.validate();
    if(!isValid) return;
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),

        );
      } on FirebaseAuthException catch(e){
        print(e);
        Utils.showSnackBar(e.message,Colors.red);

      }
      navigatorKey.currentState!.popUntil((route) => route.isFirst);


  }
}
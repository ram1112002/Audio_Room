
import 'package:audio_call/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'Utils.dart';

class SignUpPage extends StatefulWidget{
  final Function() onClickedSignIn;
  const SignUpPage({
    Key? key,
    required this.onClickedSignIn,
}) : super(key: key);
  _SignUpPageState createState() => _SignUpPageState();

}

class _SignUpPageState extends State<SignUpPage> {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
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
                height: 100,
              ),
              Container(child:Image.asset("assets/images/S.png",height: 250,alignment: Alignment.topCenter,),),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 40, 28, 5),
                child: SizedBox(width:350,child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(

                      labelText: "Email",
                    prefixIcon: Icon(Icons.account_circle_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0)
                    )
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email)=>
                  email != null && !EmailValidator.validate(email) ? "Enter a Valid Email" : null,
                ),),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 10, 28, 0),
                child: SizedBox(width: 350,child:TextFormField(
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
                ),),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 15, 28, 0),
                child: SizedBox(width: 350,child:TextFormField(
                  controller: confirmController,
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0)
                      )

                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value1){
                    if(value1 != null && value1.length < 6 ){
                      return 'Enter min. 6 characters';
                    }
                    if(value1 != passwordController.text){
                      return 'Password do not matched';
                    }
                    return null;
                  },
                  obscureText: true,
                ),),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(50, 40, 50, 0),
                child: ElevatedButton.icon(onPressed: signUp, icon: Icon(Icons.lock_open), label: Text('SignUp'),style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50)
              ),),
              ),
              SizedBox(height:110),
              RichText(
                  text: TextSpan(text: "Already Have an Account? ",
                      style: TextStyle(
                          color: Colors.black ,fontSize: 20
                      ),children: [
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignIn,
                            text: "Log In",
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
      ),
    );
    Future signUp() async{
      showDialog(context: context,barrierDismissible: false, builder: (context) => Center(child: CircularProgressIndicator(),));
      final isValid = formKey.currentState!.validate();
      if(!isValid) return;
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),

          );
        }on FirebaseAuthException catch(e){
          print(e);
          Utils.showSnackBar(e.message,Colors.red);
        }
        navigatorKey.currentState!.popUntil((route) => route.isFirst);




    }
  }

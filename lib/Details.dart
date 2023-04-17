
import 'package:audio_call/AudioPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Details extends StatefulWidget{

  _DetailsState createState() => _DetailsState();

}
class _DetailsState extends State<Details>{
  final String roomId = math.Random().nextInt(10000).toString();
  String? email = FirebaseAuth.instance.currentUser?.email;
  bool _validateTitle = false;
  bool _validateDes = false;
  DateTime now = DateTime.now();
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 330),
                  child: Text("Title",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,

                    ),),
                ),
                SizedBox(height: 15,),
                SizedBox(
                  width: 390,
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      errorText: _validateTitle? "Please fill Title": null,
                      labelText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0)
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 230),
                  child: Text("Description",style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,

                  )),
                ),
                SizedBox(height: 15,),
                Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: descriptionController,
                        maxLines: 8, //or null
                        decoration: InputDecoration(hintText: "Enter your text here",
                            errorText: _validateDes ? "Enter Description": null
                        ),
                      ),
                    )
                ),
                SizedBox(height: 30,),

                Padding(
                  padding: const EdgeInsets.only(right: 270),
                  child: Text("Room ID",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,

                    ),),
                ),
                SizedBox(height: 15,),
                SizedBox(
                  width: 390,
                  child: TextFormField(
                    enabled: false,
                    initialValue: roomId,
                    decoration: InputDecoration(
                      labelText: "Room ID",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                InkWell(
                  onTap: (){SendData();    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>AudioPage(roomID: roomId,isHost: true,)));},
                  child: Container(
                    height: 70,
                    width: 300,
                    child: Center(
                      child: Text("Confirm",style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue,

                        borderRadius: BorderRadius.circular(10.0)
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  SendData() async{
    setState(() {
      titleController.text.isEmpty ? _validateTitle = true : _validateTitle = false;
      descriptionController.text.isEmpty ? _validateDes = true : _validateDes = false;
    });
    if(_validateTitle == false && _validateDes == false) {
      showDialog(context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator(),));
      await FirebaseFirestore.instance.collection("Rooms").doc(titleController.text).set(
          {
            "Title": titleController.text,
            "Description": descriptionController.text,
            "DateCreated": now,
            "RoomId": roomId,
            "CreatedBy": email
          }
      );
    }

  }

}

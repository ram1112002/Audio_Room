import 'package:audio_call/AudioPage.dart';
import 'package:audio_call/Details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget{
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  String? email = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 760,
              child: StreamBuilder<dynamic>(stream: FirebaseFirestore.instance.collection("Rooms").snapshots(),builder: (context,snapshot){
                if(!snapshot.hasData) return Text("Currently no Audio Call");
                return SizedBox(
                  height: 500,
                  child: ListView.builder(itemCount: snapshot.data.docs.length ,itemBuilder:(context,index) {
                    var data = snapshot.data.docs[index];
                    DateTime date = DateTime.parse(data["DateCreated"].toDate().toString());
                    String StartedDate = DateFormat('dd-MMM-yyy').format(date);

                    return InkWell(
                      onTap: (){
                        print( data["RoomId"]);
                        if(data["CreatedBy"] == email){
                          Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=> AudioPage(roomID: data["RoomId"],isHost: true)));

                        }
                        else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) =>
                                  AudioPage(roomID: data["RoomId"])));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(20.0),
                            color: Color(0xFFF4F6F7),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFA5A5A5),
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Container(
                                width: 250,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFF6789CA).withOpacity(0.4),
                                  borderRadius:
                                  BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Text(
                                    data["Title"],
                                    style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 10.0,
                            ),
                              AssignmentDetailRow(
                                title: 'Started Date',
                                statusValue: StartedDate,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),

                              Text(data["Description"],style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey
                              ),),
                              SizedBox(
                                height: 20.0,
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> Details()));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  width: 250,
                  alignment: Alignment.center,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.orange,
                  ),
                  child: Text(
                      "Create Room",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF0D1333),
                        // fontWeight: FontWeight.bold,
                      ).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
            ),
              )
            ),
            InkWell(
              onTap: (){
                FirebaseAuth.instance.signOut();
              },
                child: Padding(
                  padding: const EdgeInsets.only(left: 360),
                  child: Icon(Icons.logout,color: Colors.red,),
                ))
          ],
        ),
      ),
    );
  }

}
class AssignmentDetailRow extends StatelessWidget {
  const AssignmentDetailRow(
      {Key? key, required this.title, required this.statusValue})
      : super(key: key);
  final String title;
  final String statusValue;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Color(0xFF313131), fontWeight: FontWeight.w900,fontSize: 18),
        ),
        Text(
          statusValue,
          style: Theme.of(context).textTheme.caption
              ?.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
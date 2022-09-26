import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:glud_test/doctor_pages/doctor_report.dart';
import 'package:glud_test/models/user_model.dart';
import 'package:glud_test/universal_pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({ Key? key }) : super(key: key);

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  
  //current date
  String formattedDate = DateFormat.yMMMMd('en_US').format(DateTime.now());

  final CollectionReference _users = FirebaseFirestore.instance.collection("users");
  //firebase auth
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  
  void initState() {
    //fetching user fullname
    super.initState();
    FirebaseFirestore.instance
    .collection("users")
    .doc(user?.uid)
    .get()
    .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {
      });
    });  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff273248),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () {
                logout(context);
              }, 
              child: Text("Log out",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "SpaceGrotesk",
                color: Colors.white
              ),
              )),
            ],
          )
        ],
        title: Text("Hello! ${loggedInUser.fullName}",
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
          fontFamily: "SpaceGrotesk",
        ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            formattedDate,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: "SpaceGrotesk",
            ),
          ),
          SizedBox(height: 20,),
          Center(
            child: StreamBuilder(
              stream: _users.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if(streamSnapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChartPage()));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          child: ClipPath(
                            clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                            )),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors:[
                                  Color(0xff6A7DA1),
                                  Color(0xff556D9D),
                                  Color(0xff334974)
                                ])
                              ),
                              child: ListTile(
                                title: Text(documentSnapshot['fullName'],
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold
                                ),),
                                subtitle: Text(documentSnapshot['status'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),),
                              ),
                            ),
                          ),
                        ),
                      );
                    },);
                }
                 return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),

    );
}

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
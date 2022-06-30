
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glud_test/doctor_pages/doctor_report.dart';
import 'package:glud_test/models/user_model.dart';
import 'package:glud_test/universal_pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({ Key? key }) : super(key: key);

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
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
              IconButton(onPressed: () {
                logout(context);
              }, 
              icon: Icon(Icons.exit_to_app_rounded, size: 30,))
            ],
          )
        ],
        title: Text("Hello! ${loggedInUser.fullName}",
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Color(0xffFC7643),
          fontSize: 25,
          fontWeight: FontWeight.bold
        ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: StreamBuilder(
          stream: _users.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if(streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                  return InkWell(
                       onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorReport()));
                      },

                    child: Card(
                      margin: const EdgeInsets.all(6),
                      child: ListTile(
                        title: Text(documentSnapshot['fullName']),
                        subtitle: Text(documentSnapshot['status']),
                      ),
                    ),
                  );
                },);
            }
             return CircularProgressIndicator();
          },
        ),
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
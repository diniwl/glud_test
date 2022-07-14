import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glud_test/doctor_pages/doctor_navi.dart';
import 'package:glud_test/patient_pages/bottom_navi.dart';
import 'package:glud_test/universal_pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _username = TextEditingController();

  static const String keyEmail = "prefKeyEmail";
  static const String keyPassword = "prefKeyPassword";
  static const String keyUsername = "prefKeyUsername";

  saveData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(keyEmail, _email.text.toString());
    pref.setString(keyPassword, _password.text.toString());
    pref.setString(keyUsername, _username.text.toString());
    Fluttertoast.showToast(msg: "Saved to local");
    print("Data has been saved to local storage");
  }

  final _auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
      autofocus: false,
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if(value!.isEmpty) {
          return("Please Enter Your Email");
        }
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },

      onSaved: (value) {
        _email.text = value!;

      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email_rounded),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: 
        BorderRadius.circular(30),)
      ),
      );

    final usernameField = TextFormField(
      autofocus: false,
      controller: _username,
      onSaved: (value) {
        _username.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Username",
        border: OutlineInputBorder(borderRadius: 
        BorderRadius.circular(30),)
      ),
    );
    
    final passwordField = TextFormField(
      autofocus: false,
      controller: _password,
      obscureText: true,

      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if(value!.isEmpty) {
          return("Please Enter Your Password");
        }
        if(!regex.hasMatch(value))
        {
          return("Please Enter Valid Password");
        }
      },

      onSaved: (value) {
        _password.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: 
        BorderRadius.circular(30),)
      ),
    );
    
    final PatientButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffFFEDB2),
      child: MaterialButton (
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,

        onPressed: () async {
          saveData();
          patientSignIn(_email.text, _password.text);
        },
        child: Text("Patient", textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20,
        color:Color(0xff273248),
        fontWeight: FontWeight.bold),)
      ),
    );

    final DoctorButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffFFA364),
      child: MaterialButton (
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,

        onPressed: () {
          saveData();
          doctorSignIn(_email.text, _password.text);
        },
        child: Text("Doctor", textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20,
        color:Color(0xff273248),
        fontWeight: FontWeight.bold),)
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xff273248),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xff273248),
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Center(child: Text("Selamat", 
                    style: TextStyle(color: Color(0xffFFA364), fontSize: 40, fontWeight: FontWeight.bold),)),
                    Center(child: Text("Datang!",
                    style: TextStyle(color: Color(0xffFFEDB2), fontSize: 40, fontWeight: FontWeight.bold),)),

                    SizedBox(height: 40),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(child: emailField, color: Colors.white,)),
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(child: usernameField, color: Colors.white,)),
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(child: passwordField, color: Colors.white)),

                    SizedBox(height: 60,
                      child: Center(child: Text("Login sebagai:",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)),
                    ),


                    PatientButton,

                    SizedBox(height: 20),

                    DoctorButton,

                    SizedBox(height: 20),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text("Tidak punya akun? ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),),
                        GestureDetector(onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegistPage()));
                        },
                        child: Text("SignUp", 
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xffFFEDB2), fontSize: 18),),)
                      ],
                    )

                  ],
                )),
            ),
          )),
      ),
    );
  }

  void patientSignIn(String email, String password) async {
    if(_formKey.currentState!.validate()) {
      await _auth
      .signInWithEmailAndPassword(email: email, password: password)
      .then((uid) => {
        Fluttertoast.showToast(msg: "Login Successful"),
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BottomNavi())),

      }).catchError((e)
      {
        Fluttertoast.showToast(msg: e!.message);
      });

    }
  }

  void doctorSignIn(String email, String password) async {
    if(_formKey.currentState!.validate()) {
      await _auth
      .signInWithEmailAndPassword(email: email, password: password)
      .then((uid) => {
        Fluttertoast.showToast(msg: "Login Successful"),
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DoctorNavi())),

      }).catchError((e)
      {
        Fluttertoast.showToast(msg: e!.message);
      });

    }
  }
}

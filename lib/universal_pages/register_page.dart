import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glud_test/models/user_model.dart';
import 'package:glud_test/universal_pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistPage extends StatefulWidget {
  const RegistPage({ Key? key }) : super(key: key);
  

  @override
  State<RegistPage> createState() => _RegistPageState();
  
}

class _RegistPageState extends State<RegistPage> {

  final _auth = FirebaseAuth.instance;
  
  final _formKey = GlobalKey<FormState>();

  final _fullName = new TextEditingController();
  final _email = new TextEditingController();
  final _username = new TextEditingController();
  final _password = new TextEditingController();
  final _confirmPassword = new TextEditingController();
  final _status = new TextEditingController();

  static const String keyFullName = "prefKeyFullName";
  static const String keyEmail = "prefKeyEmail";
  static const String keyUsername = "prefKeyUsername";
  static const String keyStatus= "prefKeyStatus";


  saveData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(keyFullName, _fullName.text.toString());
    pref.setString(keyEmail, _email.text.toString());
    pref.setString(keyUsername, _username.text.toString());
    pref.setString(keyStatus, _status.text.toString());
    Fluttertoast.showToast(msg: "Saved to local");

    print("Data has been saved to local storage");
  }

  @override
  Widget build(BuildContext context) {

    final fullNameField = TextFormField(
      autofocus: false,
      controller: _fullName,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if(value!.isEmpty) {
          return("Please Enter Your Full Name");
        }
        if(!regex.hasMatch(value))
        {
          return("Please Enter Valid Name");
        }
        return null;
      },

      onSaved: (value) {
        _fullName.text = value!;

      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Full Name",
        border: OutlineInputBorder(borderRadius: 
        BorderRadius.circular(30),)
      ),
      );

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
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if(value!.isEmpty) {
          return("Please Enter Your Username");
        }
        if(!regex.hasMatch(value))
        {
          return("Please Enter Valid Username");
        }
        return null;
      },

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
      controller:_password,
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
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: 
        BorderRadius.circular(30),)
      ),
      );

    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: _confirmPassword,
      obscureText: true,

      validator: (value) {
        if(_confirmPassword.text != _password.text){
          return "Password don't match";
        }
        return null;
      },

      onSaved: (value) {
        _confirmPassword.text = value!;

      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        border: OutlineInputBorder(borderRadius: 
        BorderRadius.circular(30),)
      ),
      );

    final statusField = TextFormField(
      autofocus: false,
      controller: _status,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if(value!.isEmpty) {
          return("Patient/Doctor");
        }
        if(!regex.hasMatch(value))
        {
          return("Please Enter Valid Status");
        }
        return null;
      },

      onSaved: (value) {
        _status.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Patient/Doctor",
        border: OutlineInputBorder(borderRadius: 
        BorderRadius.circular(30),)
      ),
      );


    final SignUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffFFEDB2),
      child: MaterialButton (
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,

        onPressed: () async {
          saveData();
          signUp(_email.text, _password.text);
        } ,
        child: Text("Sign Up", textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20,
        color:Color(0xff273248),
        fontWeight: FontWeight.bold),)
      ),
    );


    return Scaffold(
      backgroundColor: Color(0xff273248),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          ),
      ),
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
                    Text("Buat akun",
                    style: TextStyle(color: Color(0xffFFEDB2), fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    
                    SizedBox(height: 20),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(child: fullNameField, color: Colors.white,)),

                    SizedBox(height: 20),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(child: emailField, color: Colors.white,)),

                    SizedBox(height: 20),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(child: usernameField, color: Colors.white)),

                    SizedBox(height: 20),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(child: passwordField, color: Colors.white)),

                    SizedBox(height: 20),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(child: confirmPasswordField, color: Colors.white,)),

                    SizedBox(height: 20),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(child: statusField, color: Colors.white,)),

                    SizedBox(height: 20),

                    SignUpButton,
                    
                  ],

                ),),
            )
          )),
      ),
    );
  }

  void signUp(String email, String password) async {
    if(_formKey.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
      .then((value) => {
        postDetailsToFirestore()

      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
  postDetailsToFirestore() async {

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.fullName = _fullName.text;
    userModel.username = _username.text;
    userModel.status = _status.text;

    await firebaseFirestore.collection("users")
    .doc(user.uid)
    .set(userModel
    .toMap());
    Fluttertoast.showToast(msg: "Account created successfully :)");

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) => LoginPage())), (route) => false);

    
  }


}
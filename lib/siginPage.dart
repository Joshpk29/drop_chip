import 'package:drop_chip/menu_layout.dart';
import 'package:drop_chip/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class signinPage extends StatefulWidget{
  final onMenuTap;
  signinPage({Key key, this.onMenuTap}) : super(key:key);

  @override
  _signinPageState createState() => _signinPageState();
}

class _signinPageState extends State<signinPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  FirebaseUser _userFromFirebaseUser(FirebaseUser user){
     if(user != null)
       return  user;
     else
       return null;
  }
  Future<FirebaseUser> signInWithEmailAndPassword() async{
      try{
        if(email.text.isEmpty || password.text.isEmpty){
          return null;
        }
        AuthResult result = await _auth.signInWithEmailAndPassword(email: email.text, password: password.text);
        FirebaseUser user = result.user;
        Navigator.push(context, MaterialPageRoute(builder: (context) => MenuDashboardLayout(email: email.text,password: password.text,uid: user.uid,)),);
        return _userFromFirebaseUser(user);
      }catch(e){
        print(e.toString());
        return null;
      }
  }
  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        dynamic result = register();
        if(result==null)
        {
          print("User not created");
        }
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            controller: password,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
            ),
          ),
        ),
      ],
    );
  }

  Future<FirebaseUser> register() async{
    try{
      if(email.text.isEmpty || password.text.isEmpty){
        return null;
      }
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email.text, password: password.text);
      FirebaseUser user = result.user;
      final databaseReference = Firestore.instance.collection('UserProfiles');
      String userUID = user.uid;
      databaseReference.document(userUID).setData({
        'photoImage':"https://firebasestorage.googleapis.com/v0/b/dropchip.appspot.com/o/2020-05-23%2009%3A23%3A54.162735.png?alt=media&token=b93b9c1e-c1f4-4dcd-9d51-6b2d435a36c3",
        'UserName': email.text,
        'uid':userUID,
      });
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){
          dynamic result = signInWithEmailAndPassword();
          if(result == null){
            print("login Error");
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color.fromRGBO(227, 212, 212, 1.0),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(227, 212, 212, 1.0),
                      Color.fromRGBO(206,185,185,1.0),
                      Color.fromRGBO(175, 155, 155, 1.0)
                    ],
                    stops: [0.3, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      _buildLoginBtn(),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
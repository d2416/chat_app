import 'package:flash_chat_app/components/round_button.dart';
import 'package:flash_chat_app/constants.dart';
import 'package:flash_chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  String email;
  String password;
  bool modalProgress = false;
  String messageErrorLogin = '.';
  bool hasMessageErrorLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: modalProgress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 200.0,
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              Visibility(
                visible: hasMessageErrorLogin,
                child: Column(
                  children: [
                    Text(
                      '$messageErrorLogin Please, try again.',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
              ),
              TextField(
                controller: emailTextController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: passwordTextController,
                textAlign: TextAlign.center,
                obscuringCharacter: '.',
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundButton(
                color: Colors.blueAccent,
                label: 'Log In',
                onPressed: () async {
                  setState(() {
                    modalProgress = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    if (user != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    emailTextController.clear();
                    passwordTextController.clear();
                  } on FirebaseAuthException catch (e) {
                    if (e.code == "user-not-found") {
                      messageErrorLogin = "User or password incorrect";
                    } else {
                      messageErrorLogin = e.message;
                    }
                    hasMessageErrorLogin = true;
                    print("you are here ${e.code}");
                  } finally {
                    setState(() {
                      modalProgress = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flash_chat_app/screens/login_screen.dart';
import 'package:flash_chat_app/screens/register_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Image(
                  height: 60.0,
                  image: AssetImage('images/logo.png'),
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 45.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                child: MaterialButton(
                  height: 42.0,
                  minWidth: 200.0,
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  child: Text('Log In'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.blueAccent,
                elevation: 5.0,
                child: MaterialButton(
                  height: 42.0,
                  minWidth: 200.0,
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterScreen.id);
                  },
                  child: Text('Register'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

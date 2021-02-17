import 'package:flash_chat_app/screens/login_screen.dart';
import 'package:flash_chat_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat_app/components/round_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

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
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: controller.value * 100,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 200),
                  text: [
                    'Flash Chat',
                  ],
                  textStyle: TextStyle(
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
            RoundButton(
              label: 'Log In',
              color: Colors.lightBlueAccent,
              onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
            ),
            RoundButton(
              label: 'Register',
              color: Colors.blueAccent,
              onPressed: () => Navigator.pushNamed(context, RegisterScreen.id),
            ),
          ],
        ),
      ),
    );
  }
}

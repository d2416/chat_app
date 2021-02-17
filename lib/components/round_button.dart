import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  RoundButton(
      {@required this.label, @required this.color, @required this.onPressed});

  final String label;
  final Color color;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        color: color,
        elevation: 5.0,
        child: MaterialButton(
          height: 42.0,
          minWidth: 200.0,
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

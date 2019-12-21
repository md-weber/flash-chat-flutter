import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final Function onPressed;
  final String displayText;
  final Color color;

  const NavigationButton({
    Key key,
    @required this.onPressed,
    @required this.color,
    this.displayText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            displayText,
          ),
        ),
      ),
    );
  }
}

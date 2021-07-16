import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({Key key, this.child, this.color, this.onPressed}) : super(key: key);

  final Widget child;
  final Color color;
  final double height = 40.0;
  final double borderRadius = 35.0;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        child: child,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(borderRadius)
                )
            ))
        ),
        onPressed: onPressed,
      ),
    );
  }
}

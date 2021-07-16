import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_photo_gallery/common_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    @required String text,
    @required String assetImageSVG,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        assert(assetImageSVG != null),
        super(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  assetImageSVG,
                  height: 28,
                ),
                Text(
                  text,
                  style: TextStyle(color: Colors.black87),
                ),
                Text('')
              ],
            ),
            color: color,
            borderRadius: 35,
            height: 40,
            onPressed: onPressed);
}

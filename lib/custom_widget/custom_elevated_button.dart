import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final Color buttonColor;
  final Color textColor;
  final double buttonRadius;
  final double buttonHeight;
  final Widget? buttonIcon;

  const CustomElevatedButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.buttonColor = Colors.purple,
    this.textColor = Colors.white,
    this.buttonRadius = 16,
    this.buttonHeight = 40,
    this.buttonIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: buttonColor,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(buttonRadius)),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //Spreads, Collection-if, Collection-For
              if (buttonIcon != null) ...[
                buttonIcon!,
                Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor),
                ),
                Opacity(opacity: 0, child: buttonIcon)
              ],
              if (buttonIcon == null) ...[
                Container(),
                Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor),
                ),
                Container(),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

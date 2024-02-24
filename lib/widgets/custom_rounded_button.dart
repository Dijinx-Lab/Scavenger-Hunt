import 'package:flutter/material.dart';
import 'package:scavenger_hunt/styles/color_style.dart';

class CustomRoundedButton extends StatelessWidget {
  final String buttonText;
  final Function onTap;
  final Color textColor;
  final double textSize;
  final FontWeight textWeight;
  final Color buttonBackgroundColor;
  final double roundedCorners;
  final double elevation;
  final bool isEnabled;
  final double leftPadding;
  final double rightPadding;
  final Color borderColor;
  final Color waterColor;
  final Widget? widgetButton;

  const CustomRoundedButton(this.buttonText, this.onTap,
      {Key? key,
      this.textColor = Colors.white,
      this.textSize = 16.0,
      this.textWeight = FontWeight.w500,
      this.buttonBackgroundColor = ColorStyle.primaryColor,
      this.roundedCorners = 6,
      this.elevation = 0.0,
      this.isEnabled = true,
      this.leftPadding = 16,
      this.rightPadding = 16,
      this.borderColor = ColorStyle.primaryColor,
      this.waterColor = Colors.white12,
      this.widgetButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.resolveWith<EdgeInsets>(
            (Set<MaterialState> states) {
              return EdgeInsets.only(left: leftPadding, right: rightPadding);
            },
          ),
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return 0;
              }
              return elevation;
            },
          ),
          overlayColor: MaterialStateProperty.all<Color>(
              isEnabled ? waterColor : Colors.transparent),
          backgroundColor: MaterialStateProperty.all<Color>(isEnabled
              ? buttonBackgroundColor
              : buttonBackgroundColor.withOpacity(0.3)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  side: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(roundedCorners)))),
      onPressed: () {
        if (isEnabled) onTap();
      },
      child: widgetButton ??
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              buttonText,
              maxLines: 1,
              style: TextStyle(
                  height: 1.2,
                  fontSize: textSize,
                  color: textColor,
                  fontWeight: textWeight),
            ),
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scavenger_hunt/styles/color_style.dart';

class ToastUtils {
  static showSnackBar(BuildContext context, String text, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              type == "fail" ? ColorStyle.red100Color : ColorStyle.primaryColor,
          content: type == "text"
              ? Text(text)
              : Row(
                  children: [
                    Icon(
                      type == "success"
                          ? Icons.check_circle_outline
                          : type == "fail"
                              ? Icons.error_outline
                              : Icons.info_outline,
                      color: ColorStyle.whiteColor,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      text,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    )
                  ],
                )),
    );
  }

  static showCustomSnackbar({
    required BuildContext context,
    required String contentText,
    Icon? icon,
    String? subText,
    int millisecond = 4000,
    Color background = ColorStyle.primaryColor,
    bool isCenteredText = false,
  }) {
    bool isExecute = true;
    final snackbar = SnackBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? const SizedBox(
                  width: 0,
                  height: 0,
                ),
          icon != null
              ? const SizedBox(
                  width: 10,
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
          Expanded(
            child: Text(
              contentText,
              textAlign: isCenteredText ? TextAlign.center : TextAlign.start,
              style: const TextStyle(
                  color: ColorStyle.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor: background,
      duration: Duration(milliseconds: millisecond),
      behavior: SnackBarBehavior.fixed,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);

    /*Timer(Duration(seconds: second), () {
      if (isExecute) afterExecuteMethod();
    });*/
  }
}

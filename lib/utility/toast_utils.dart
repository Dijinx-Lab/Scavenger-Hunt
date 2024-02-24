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
}

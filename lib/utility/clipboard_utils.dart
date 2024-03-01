import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:scavenger_hunt/utility/toast_utils.dart';

class ClipboardUtils {
  static copyToClipboard(BuildContext context,
    String text
  ) {
    FlutterClipboard.copy(text).then((value) => ToastUtils.showSnackBar(
        context, "Code copied to clipboard", "success"));
  }
}

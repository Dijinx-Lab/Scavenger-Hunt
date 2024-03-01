import 'package:flutter/material.dart';

class AvatarUtils {
  static String getEmoji(String codePoint) {
    if (codePoint.startsWith('U+')) {
      codePoint = codePoint.substring(2);
    }
    int emoji = int.parse(codePoint, radix: 16);
    return String.fromCharCode(emoji);
  }

  static String getUnicode(String emoji) {
    int codePoint = emoji.runes.first;
    return 'U+${codePoint.toRadixString(16).toUpperCase()}';
  }

  static Color hexToColor(String code) {
    if (code.startsWith('#')) {
      code = code.substring(1);
    }

    return Color(int.parse(code, radix: 16) + 0xFF000000);
  }
}

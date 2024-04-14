import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PickerUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<List<String>?> pickMultipleImages() async {
    List<String> imagePaths = [];
    if (Platform.isAndroid) {
      await Permission.storage.request();
    } else {
      await Permission.photos.request();
    }
    List<XFile>? xfile = await _picker.pickMultiImage(
      imageQuality: 100,
    );
    if (xfile.isNotEmpty) {
      for (var file in xfile) {
        if (await File(file.path).exists()) {
          imagePaths.add(file.path);
        }
      }
    }
    return imagePaths;
  }

  static Future<String?> pickImage() async {
    String imagePath = '';
    if (Platform.isAndroid) {
      await Permission.storage.request();
    } else {
      await Permission.photos.request();
    }
    XFile? xfile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    if (xfile != null) {
      if (await File(xfile.path).exists()) {
        imagePath = xfile.path;
      }
    }
    return imagePath;
  }

  static Future<String?> captureImage() async {
    String imagePath = '';

    await Permission.camera.request();

    XFile? xfile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    if (xfile != null) {
      if (await File(xfile.path).exists()) {
        imagePath = xfile.path;
      }
    }
    return imagePath;
  }
}

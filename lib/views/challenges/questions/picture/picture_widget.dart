import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/models/api/question/question/question.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/picker_utils.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class PictureWidget extends StatefulWidget {
  static final eventBus = EventBus();
  final Question question;
  final Function(dynamic, bool) onDataFilled;
  const PictureWidget(
      {super.key, required this.question, required this.onDataFilled});

  @override
  State<PictureWidget> createState() => _PictureWidgetState();
}

class _PictureWidgetState extends State<PictureWidget> {
  String? image;
  bool showAnswer = false;

  _openImagePicker() async {
    String? newImage;
    ValueKey<String>? result = await showModalActionSheet(
        context: context,
        actions: [
          const SheetAction(key: ValueKey('gallery'), label: 'Photo Gallery'),
          const SheetAction(key: ValueKey('camera'), label: 'Camera')
        ],
        cancelLabel: 'Cancel');
    if (result != null) {
      if (result.value == 'gallery') {
        newImage = await PickerUtils.pickImage();
      } else if (result.value == 'camera') {
        newImage = await PickerUtils.captureImage();
      }
      image = newImage;
      widget.onDataFilled(image, true);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AbsorbPointer(
        absorbing: showAnswer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _openImagePicker(),
              child: Container(
                height: 300,
                width: double.maxFinite,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorStyle.blackColor,
                  ),
                ),
                child: image == null || image == ''
                    ? SizedBox(
                        height: 40,
                        width: 40,
                        child: SvgPicture.asset(
                          'assets/svgs/ic_upload_image.svg',
                          fit: BoxFit.scaleDown,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(children: [
                          SizedBox(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            child: Image.file(
                              File(image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: SizedBox(
                              height: 30,
                              child: CustomRoundedButton(
                                "Retake",
                                () => _openImagePicker(),
                                roundedCorners: 40,
                                textSize: 12,
                                leftPadding: 20,
                                rightPadding: 20,
                              ),
                            ),
                          ),
                        ]),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.question.question ?? '',
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: ColorStyle.primaryTextColor),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:scavenger_hunt/models/api/question/question/question.dart';
import 'package:scavenger_hunt/models/events/answer_submitted/answer_submitted.dart';
import 'package:scavenger_hunt/styles/color_style.dart';

class BinaryWidget extends StatefulWidget {
  static final eventBus = EventBus();
  final Question question;
  final Function(dynamic, bool) onDataFilled;
  const BinaryWidget(
      {super.key, required this.question, required this.onDataFilled});

  @override
  State<BinaryWidget> createState() => _BinaryWidgetState();
}

class _BinaryWidgetState extends State<BinaryWidget> {
  bool? _selectedAnswer;
  bool showAnswer = false;

  @override
  initState() {
    super.initState();
    BinaryWidget.eventBus.on<AnswerSubmitted>().listen((event) {
      setState(() {
        showAnswer = true;
      });
    });
  }

  _selectAnswer(answer) {
    setState(() {
      _selectedAnswer = answer;
    });
    widget.onDataFilled(answer, true);
  }

  _getCellColor(bool forTrue) {
    if (forTrue) {
      if (!showAnswer && _selectedAnswer != null && _selectedAnswer!) {
        return ColorStyle.outline100Color;
      } else if (showAnswer &&
          _selectedAnswer != null &&
          _selectedAnswer! &&
          _selectedAnswer == widget.question.answer) {
        return ColorStyle.green100Color;
      } else if (showAnswer &&
          _selectedAnswer != null &&
          _selectedAnswer! &&
          _selectedAnswer != widget.question.answer) {
        return ColorStyle.red100Color;
      } else {
        return ColorStyle.cardColor;
      }
    } else {
      if (!showAnswer && _selectedAnswer != null && !_selectedAnswer!) {
        return ColorStyle.outline100Color;
      } else if (showAnswer &&
          _selectedAnswer != null &&
          !_selectedAnswer! &&
          _selectedAnswer == widget.question.answer) {
        return ColorStyle.green100Color;
      } else if (showAnswer &&
          _selectedAnswer != null &&
          !_selectedAnswer! &&
          _selectedAnswer != widget.question.answer) {
        return ColorStyle.red100Color;
      } else {
        return ColorStyle.cardColor;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: showAnswer,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.question.picture != null &&
                  widget.question.picture != "",
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 300,
                  ),
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    // border: Border.all(
                    //   color: ColorStyle.blackColor,
                    // ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.question.picture!,
                      fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Container(
                            color: ColorStyle.grey100Color,
                            child: const Center(
                              child: Text("Loading..."),
                            ),
                          );
                        },
                    ),
                  ),
                ),
              ),
            ),
            Text(
              widget.question.question ?? '',
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: ColorStyle.primaryTextColor),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectAnswer(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: _getCellColor(true),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColorStyle.blackColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "True",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color:
                                  (_selectedAnswer != null && _selectedAnswer!)
                                      ? ColorStyle.whiteColor
                                      : ColorStyle.primaryTextColor),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectAnswer(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: _getCellColor(false),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColorStyle.blackColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "False",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color:
                                  (_selectedAnswer != null && !_selectedAnswer!)
                                      ? ColorStyle.whiteColor
                                      : ColorStyle.primaryTextColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

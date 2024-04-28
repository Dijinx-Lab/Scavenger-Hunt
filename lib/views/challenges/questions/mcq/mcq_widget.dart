import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:scavenger_hunt/models/api/question/question/question.dart';
import 'package:scavenger_hunt/models/events/answer_submitted/answer_submitted.dart';
import 'package:scavenger_hunt/styles/color_style.dart';

class McqWidget extends StatefulWidget {
  static final eventBus = EventBus();
  final Question question;
  final Function(dynamic, bool) onDataFilled;
  const McqWidget(
      {super.key, required this.question, required this.onDataFilled});

  @override
  State<McqWidget> createState() => _McqWidgetState();
}

class _McqWidgetState extends State<McqWidget> {
  late String _selectedAnswer;
  bool showAnswer = false;

  @override
  initState() {
    _selectedAnswer = "";
    super.initState();
    McqWidget.eventBus.on<AnswerSubmitted>().listen((event) {
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

  _getCellColor(index) {
    return !showAnswer && _selectedAnswer == widget.question.options![index]
        ? ColorStyle.outline100Color
        : (showAnswer &&
                _selectedAnswer == widget.question.options![index] &&
                _selectedAnswer == widget.question.answer)
            ? ColorStyle.green100Color
            : (showAnswer &&
                    _selectedAnswer == widget.question.options![index] &&
                    _selectedAnswer != widget.question.answer)
                ? ColorStyle.red100Color
                : ColorStyle.cardColor;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AbsorbPointer(
        absorbing: showAnswer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.question.picture != null &&
                  widget.question.picture != "",
              child: Container(
                height: 300,
                width: double.maxFinite,
                //padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorStyle.blackColor,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.question.picture!,
                    fit: BoxFit.cover,
                  ),
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
            const SizedBox(height: 15),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectAnswer(widget.question.options![0]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 5),
                        decoration: BoxDecoration(
                          color: _getCellColor(0),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ColorStyle.blackColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.question.options![0],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: _selectedAnswer ==
                                        widget.question.options![0]
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
                      onTap: () => _selectAnswer(widget.question.options![1]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 5),
                        decoration: BoxDecoration(
                          color: _getCellColor(1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ColorStyle.blackColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.question.options![1],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: _selectedAnswer ==
                                        widget.question.options![1]
                                    ? ColorStyle.whiteColor
                                    : ColorStyle.primaryTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectAnswer(widget.question.options![2]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 5),
                        decoration: BoxDecoration(
                          color: _getCellColor(2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ColorStyle.blackColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.question.options![2],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: _selectedAnswer ==
                                        widget.question.options![2]
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
                      onTap: () => _selectAnswer(widget.question.options![3]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 5),
                        decoration: BoxDecoration(
                          color: _getCellColor(3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ColorStyle.blackColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.question.options![3],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: _selectedAnswer ==
                                        widget.question.options![3]
                                    ? ColorStyle.whiteColor
                                    : ColorStyle.primaryTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

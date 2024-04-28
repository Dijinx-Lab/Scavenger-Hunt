import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:scavenger_hunt/models/api/question/question/question.dart';
import 'package:scavenger_hunt/models/events/answer_submitted/answer_submitted.dart';
import 'package:scavenger_hunt/styles/color_style.dart';

class SliderWidget extends StatefulWidget {
  static final eventBus = EventBus();
  final Question question;
  final Function(dynamic, bool) onDataFilled;
  const SliderWidget(
      {super.key, required this.question, required this.onDataFilled});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late int _selectedAnswer;
  bool showAnswer = false;

  @override
  initState() {
    super.initState();
    _selectedAnswer = widget.question.sliderMin!;
    Future.delayed(const Duration(milliseconds: 500)).then(
      (value) => _selectAnswer(_selectedAnswer),
    );
    SliderWidget.eventBus.on<AnswerSubmitted>().listen((event) {
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

  _getCellColor() {
    return (showAnswer && _selectedAnswer == widget.question.answer)
        ? ColorStyle.green100Color
        : (showAnswer && _selectedAnswer != widget.question.answer)
            ? ColorStyle.red100Color
            : ColorStyle.outline100Color;
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
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
          Text(
            widget.question.question ?? '',
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                color: ColorStyle.primaryTextColor),
          ),

          const SizedBox(height: 25),
          Center(
            child: SizedBox(
              width: double.maxFinite,
              child: FlutterSlider(
                values: [
                  _selectedAnswer.toDouble(),
                ],
                min: (widget.question.sliderMin!).toDouble(),
                max: (widget.question.sliderMax!).toDouble(),
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  setState(() {
                    _selectedAnswer = lowerValue.toInt();
                  });
                  _selectAnswer(_selectedAnswer);
                },
                handlerHeight: 40,
                handlerWidth: 60,
                tooltip: FlutterSliderTooltip(disabled: true),
                handler: FlutterSliderHandler(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(-1.28, 0),
                            blurRadius: 2.57,
                            color: ColorStyle.shadowColor)
                      ],
                      borderRadius: BorderRadius.circular(4),
                      color: _getCellColor()),
                  child: Text(
                    _selectedAnswer.toString(),
                    style: const TextStyle(
                        fontSize: 18,
                        color: ColorStyle.whiteColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                trackBar: FlutterSliderTrackBar(
                  activeTrackBarHeight: 30,
                  inactiveTrackBarHeight: 30,
                  inactiveTrackBar: BoxDecoration(
                      color: ColorStyle.secondaryTextColor.withOpacity(0.3)),
                  activeTrackBar: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                        ColorStyle.primaryColor,
                        ColorStyle.jumbleColor.withOpacity(0.4)
                      ])),
                ),
              ),
            ),
          )
          // Slider(
          //     min: (widget.question.sliderMin!).toDouble(),
          //     max: (widget.question.sliderMax!).toDouble(),
          //     value: _selectedAnswer.toDouble(),
          //     thumbColor: ColorStyle.primaryColor,
          //     activeColor: ColorStyle.primaryColor,
          //     inactiveColor: ColorStyle.greyTextColor,
          //     onChanged: (value) {
          //       setState(() {
          //         _selectedAnswer = value.round();
          //         controller.text = '$_selectedAnswer';
          //       });
          //       _selectAnswer(_selectedAnswer);
          //     }),
        ],
      ),
    );
  }
}

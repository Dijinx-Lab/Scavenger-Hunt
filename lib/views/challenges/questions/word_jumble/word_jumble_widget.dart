import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:scavenger_hunt/models/api/question/question/question.dart';
import 'package:scavenger_hunt/models/events/answer_submitted/answer_submitted.dart';
import 'package:scavenger_hunt/styles/color_style.dart';

class WordJumbleWidget extends StatefulWidget {
  static final eventBus = EventBus();
  final Question question;
  final Function(dynamic, bool) onDataFilled;
  const WordJumbleWidget(
      {super.key, required this.question, required this.onDataFilled});

  @override
  State<WordJumbleWidget> createState() => _WordJumbleWidgetState();
}

class _WordJumbleWidgetState extends State<WordJumbleWidget> {
  late String _selectedAnswer;
  bool showAnswer = false;

  late List<Map<String, dynamic>?> selectedLetters;
  List<Map<String, dynamic>> jumble = [];
  TextEditingController controller = TextEditingController();
  @override
  initState() {
    _selectedAnswer = "";

    initializeJumble();
    WordJumbleWidget.eventBus.on<AnswerSubmitted>().listen((event) {
      setState(() {
        showAnswer = true;
      });
    });
    super.initState();
  }

  void initializeJumble() {
    String initialWord = widget.question.answer;

    List<String> initialLetters = initialWord.split('');
    selectedLetters = List<Map<String, dynamic>?>.filled(
      initialLetters.length,
      null,
      growable: false,
    );
    initialLetters.shuffle();

    List<Map<String, dynamic>> randomizedLetters = [];
    final random = Random();

    for (int i = 0; i < initialLetters.length; i++) {
      randomizedLetters.add({
        'letter': initialLetters[i].toUpperCase(),
        'initialIndex': i,
      });
    }

    while (randomizedLetters.length != widget.question.jumbledWord) {
      randomizedLetters.add({
        'letter': String.fromCharCode(random.nextInt(26) + 'A'.codeUnitAt(0)),
        'initialIndex': randomizedLetters.length,
      });
    }
    jumble = randomizedLetters;
  }

  void moveLetterToSelected(int index) {
    setState(() {
      if (selectedLetters.contains(null)) {
        Map<String, dynamic> selected = jumble.removeAt(index);
        int firstNullIndex =
            selectedLetters.indexWhere((element) => element == null);
        if (firstNullIndex != -1) {
          selectedLetters[firstNullIndex] = selected;
        } else {}
      }
    });
    _selectAnswer();
  }

  void moveLetterBackToJumble(int index) {
    setState(() {
      if (selectedLetters[index] != null) {
        Map<String, dynamic> removed = selectedLetters[index]!;
        if (index < jumble.length) {
          jumble.insert(index, removed);
        } else {
          jumble.add(removed);
        }
        selectedLetters[index] = null;
      }
    });
    _selectAnswer();
  }

  _selectAnswer() {
    String result = '';
    for (var letterMap in selectedLetters) {
      if (letterMap != null) {
        result += letterMap['letter'];
      }
    }
    _selectedAnswer = result.toUpperCase();
    if (selectedLetters.contains(null)) {
      widget.onDataFilled(result, false);
    } else {
      widget.onDataFilled(result, true);
    }
  }

  _getCellColor() {
    return (showAnswer &&
            _selectedAnswer.toLowerCase() ==
                widget.question.answer.toLowerCase())
        ? ColorStyle.green100Color
        : (showAnswer &&
                _selectedAnswer.toLowerCase() !=
                    widget.question.answer.toLowerCase())
            ? ColorStyle.red100Color
            : ColorStyle.outline100Color;
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: showAnswer,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * .15,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: selectedLetters.map((letter) {
                  return GestureDetector(
                    onTap: () =>
                        moveLetterBackToJumble(selectedLetters.indexOf(letter)),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 3,
                            color: _getCellColor(),
                          )),
                      child: Text(
                        letter?['letter'] ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: _getCellColor()),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              width: double.maxFinite,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: jumble.map((letter) {
                  return GestureDetector(
                    onTap: () => moveLetterToSelected(jumble.indexOf(letter)),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ColorStyle.jumbleColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        letter['letter'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20.0, color: ColorStyle.whiteColor),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

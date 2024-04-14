import 'package:scavenger_hunt/models/api/challenge/challenge.dart';
import 'package:scavenger_hunt/models/api/question/question/question.dart';

class QuestionArgs {
  final Challenge challenge;
  final List<Question>? questions;
  final int selectedIndex;

  QuestionArgs({
    required this.challenge,
    this.questions,
    this.selectedIndex = 0,
  });
}

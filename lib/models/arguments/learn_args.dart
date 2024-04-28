import 'package:scavenger_hunt/models/api/challenge/challenge.dart';

class LearnArgs {
  final bool isForFinish;
  final Challenge? challenge;

  LearnArgs({
    required this.isForFinish,
    this.challenge,
  });
}

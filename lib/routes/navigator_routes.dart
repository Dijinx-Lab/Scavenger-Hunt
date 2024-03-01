import 'package:flutter/material.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/arguments/learn_args.dart';
import 'package:scavenger_hunt/views/base/base_screen.dart';
import 'package:scavenger_hunt/views/challenges/details/challenges_detail_screen.dart';
import 'package:scavenger_hunt/views/challenges/finished/finished_screen.dart';
import 'package:scavenger_hunt/views/challenges/points/points_screen.dart';
import 'package:scavenger_hunt/views/challenges/questions/question_screen.dart';
import 'package:scavenger_hunt/views/learn/learn_route_screen.dart';
import 'package:scavenger_hunt/views/team/create_team/create_team_screen.dart';
import 'package:scavenger_hunt/views/team/create_team/team_code_screen.dart';
import 'package:scavenger_hunt/views/team/join_team/join_team_screen.dart';
import 'package:scavenger_hunt/views/team/processing/processing_screen.dart';
import 'package:scavenger_hunt/views/terms/terms_screen.dart';
import 'package:scavenger_hunt/views/welcome/welcome_screen.dart';

class NavigatorRoutes {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case welcomeRoute:
        page = const WelcomeScreen();
        break;
      case termsRoute:
        page = const TermsScreen();
        break;
      case joinTeamRoute:
        page = const JoinTeamScreen();
        break;
      case createTeamRoute:
        page = const CreateTeamScreen();
        break;
      case teamCodeRoute:
        page = const TeamCodeScreen();
        break;
      case processingRoute:
        page = const ProcessingScreen();
        break;
      case learnRouteRoute:
        page = LearnRouteScreen(
          args: settings.arguments as LearnArgs,
        );
        break;
      case baseRoute:
        page = const BaseScreen();
        break;
      case challengesRoute:
        page = const ChallengesDetailScreen();
        break;
      case questionsRoute:
        page = const QuestionScreen();
        break;
      case pointsRoute:
        page = const PointsScreen();
        break;
      case finishedRoute:
        page = const FinishedScreen();
        break;

      default:
        page = const WelcomeScreen();
        break;
    }

    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }
}

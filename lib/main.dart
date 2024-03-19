import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/routes/navigator_routes.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await PrefUtil().init();
  await dotenv.load(fileName: "assets/config/.env");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarDividerColor: ColorStyle.whiteColor,
      systemNavigationBarColor: ColorStyle.whiteColor,
    ));
    return MaterialApp(
      title: 'Scavenger Hunt',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: ColorStyle.primaryColor,
        fontFamily: "Helvetica Now Display",
        canvasColor: ColorStyle.backgroundColor,
        colorScheme: ColorStyle.appScheme,
        primarySwatch: ColorStyle.primaryMaterialColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: welcomeRoute,
      onGenerateRoute: NavigatorRoutes.allRoutes,
    );
  }
}

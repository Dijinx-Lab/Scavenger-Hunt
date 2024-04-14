import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:scavenger_hunt/firebase_options.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/events/notification_recieved/notification_recieved.dart';
import 'package:scavenger_hunt/routes/navigation_observer.dart';
import 'package:scavenger_hunt/routes/navigator_routes.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/notification_utils.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/views/base/base_screen.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  if (message != null) {
    NotificationUtils.showNotification(message);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
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
  StreamSubscription<RemoteMessage>? remoteMessageStream;
  StreamSubscription<RemoteMessage>? onMessageOpenedStream;

  @override
  void initState() {
    super.initState();
    NotificationUtils.initializeFirebase(context);

    remoteMessageStream = FirebaseMessaging.onMessage.listen((event) {
      // NotificationUtils.showNotification(event);
      if (NavigatorRoutes.isRouteInStack(baseRoute)) {
        // 'fired');
        BaseScreen.eventBus.fire(NotificationRecieved(
            action: event.data['action'], id: event.data['id']));
      }
    });

    onMessageOpenedStream =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // NotificationUtils.showNotification(message);
      NotificationUtils.handleInitialMessage(message);
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((message) => NotificationUtils.handleInitialMessage(message));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scavenger Hunt',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        NavigationObserver.instance,
        FlutterSmartDialog.observer
      ],
      builder: FlutterSmartDialog.init(),
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: ColorStyle.primaryColor,
        fontFamily: "Helvetica Now Display",
        canvasColor: ColorStyle.backgroundColor,
        colorScheme: ColorStyle.appScheme,
        primarySwatch: ColorStyle.primaryMaterialColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          side: const BorderSide(width: 2, color: ColorStyle.primaryColor),
        ),
        cupertinoOverrideTheme: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(),
        ),
      ),
      initialRoute: splashRoute,
      onGenerateRoute: NavigatorRoutes.allRoutes,
    );
  }
}

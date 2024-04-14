import 'package:flutter/material.dart';

class NavigationObserver extends NavigatorObserver {
  final List<String> _routeStack = [];

  List<String> get routeStack => _routeStack;

  // Private constructor
  NavigationObserver._();

  // Singleton instance
  static final NavigationObserver _instance = NavigationObserver._();

  // Getter for the singleton instance
  static NavigationObserver get instance => _instance;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name == null) return;
    _routeStack.add(route.settings.name!);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute?.settings.name == null || oldRoute?.settings.name == null) {
      return;
    }
    if (newRoute != null) {
      _routeStack.removeLast();
      _routeStack.add(newRoute.settings.name!);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name == null) return;
    _routeStack.remove(route.settings.name);
  }

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    if (route?.settings.name == null) return;
    if (previousRoute?.settings.name == null) return;
    if (route != null) {
      _routeStack.remove(route.settings.name);
    }
  }
}

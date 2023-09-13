import 'package:BB_navigation/navigation.dart';
import 'package:flutter/material.dart';

abstract class NavigatorManagerHandlers {
  void setDefaultHandler(GenerateRoute handler);
  void addHandler(String path, GenerateRoute handler);
  void removeHandler(String path);
}

abstract class NavigatorManager implements NavigatorManagerHandlers {
  String get name;
  NavigatorObserver get observer;
  NavigationInfo get info;
  GlobalKey<NavigatorState> get navigatorKey;
  Route onGenerateRoute(RouteSettings settings);
  bool get debug;
  set debug(bool v);

  factory NavigatorManager(String name, GenerateRoute defaultHandler,
      {Map<String, GenerateRoute>? handlers}) {
    return BasicNavigatorManager(name, defaultHandler, handlers: handlers);
  }
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      String path,
      {TO? result,
      Object? arguments});
  Future<T?> pushNamed<T extends Object?>(String path, {Object? arguments});
  Future<T?> pushNamedAndRemoveUntil<T>(
      String name, bool Function(Route<dynamic>) predicate,
      {Object? arguments});
  void pop<T extends Object?>([T? result]);
  void popUntil(bool Function(Route<dynamic>) predicate);
}

class BasicNavigatorManager implements NavigatorManager {
  @override
  final String name;
  GenerateRoute _defaultHandler;

  late final Map<String, GenerateRoute> _handlers;
  BasicNavigatorManager(this.name, this._defaultHandler,
      {Map<String, GenerateRoute>? handlers})
      : _handlers = handlers ?? {} {
    _observer = BasicNavigatorObserver(name);
    NavigationMaster().addNavManager(this);
  }

  late final BasicNavigatorObserver _observer;
  @override
  NavigationInfo get info => _observer;
  @override
  NavigatorObserver get observer => _observer;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  bool _debug = false;
  @override
  bool get debug => _debug;
  @override
  set debug(bool v) {
    _debug = v;
    _observer.debug = v;
  }

  @override
  Route onGenerateRoute(RouteSettings settings) {
    if (_handlers.containsKey(settings.name)) {
      return _handlers[settings.name]!.call(settings, info);
    }
    return _defaultHandler(settings, info);
  }

  @override
  void setDefaultHandler(GenerateRoute handler) {
    _defaultHandler = handler;
  }

  @override
  void addHandler(String path, GenerateRoute handler) {
    _handlers[path] = handler;
  }

  @override
  void removeHandler(String path) {
    _handlers.remove(path);
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      String path,
      {TO? result,
      Object? arguments}) async {
    return navigatorKey.currentState?.pushReplacementNamed<T, TO>(path,
        result: result, arguments: arguments);
  }

  @override
  Future<T?> pushNamed<T extends Object?>(String path,
      {Object? arguments}) async {
    return navigatorKey.currentState?.pushNamed<T>(path, arguments: arguments);
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T>(
      String name, bool Function(Route<dynamic>) predicate,
      {Object? arguments}) async {
    return navigatorKey.currentState
        ?.pushNamedAndRemoveUntil<T>(name, predicate, arguments: arguments);
  }

  @override
  void pop<T extends Object?>([T? result]) {
    navigatorKey.currentState?.pop<T>(result);
  }

  @override
  void popUntil(
    bool Function(Route<dynamic>) predicate,
  ) {
    navigatorKey.currentState?.popUntil(predicate);
  }
}

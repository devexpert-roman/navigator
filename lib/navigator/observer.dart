import 'package:flutter/material.dart';

abstract class NavigationInfo implements ChangeNotifier {
  String getPath({String separator = "/"});
  List<String> get navigationQuery;

  ///[getPath] but clear '/null'
  String getFullClearPath({String separator = "/"});
  String get current;
  String? get last;
  bool get debug;
  set debug(bool v);
}

class BasicNavigatorObserver extends NavigatorObserver
    with ChangeNotifier
    implements NavigationInfo {
  String name;
  final List<String> _pathsList = List<String>.empty(growable: true);
  @override
  List<String> get navigationQuery => List.from(_pathsList);
  @override
  String get current => _pathsList.last;
  @override
  String? get last => _pathsList.isEmpty
      ? null
      : _pathsList.length == 1
          ? null
          : _pathsList[_pathsList.length - 2];

  BasicNavigatorObserver(this.name, {bool debug = false}) : _debug = debug;

  bool _debug = false;
  @override
  bool get debug => _debug;
  @override
  set debug(bool v) {
    _debug = v;
  }

  @override
  String getPath({String separator = "/"}) {
    return _pathsList.join(separator);
  }

  @override
  String getFullClearPath({String separator = "/"}) {
    var str = _pathsList.join(separator);
    str.replaceAll('${separator}null', '');
    return str;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    String str = '';
    if (_pathsList.isNotEmpty) {
      str = _pathsList.removeLast();
    }
    if (_debug) {
      print(
          '$name: didPop: ${previousRoute?.settings.name ?? 'null'} <- ${route.settings.name} pop:$str');
    }

    super.didPop(route, previousRoute);
    notifyListeners();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (_debug) {
      print(
          '$name: didPush: ${previousRoute?.settings.name ?? 'null'} -> ${route.settings.name}');
    }
    _pathsList.add(route.settings.name ?? 'null');

    super.didPush(route, previousRoute);
    notifyListeners();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    String str = '';
    if (_pathsList.isNotEmpty) {
      // str = _pathsList.removeLast();
      str = route.settings.name ?? 'null';
      var i = _pathsList.lastIndexOf(str);
      if (i >= 0) _pathsList.removeAt(i);
      // _pathsList.remove(route.settings.name!);
    }
    if (_debug) {
      print(
          '$name: didRemove: ${previousRoute?.settings.name ?? 'null'} <- ${route.settings.name} remove:$str');
    }

    super.didRemove(route, previousRoute);
    notifyListeners();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (_pathsList.isNotEmpty) {
      _pathsList.removeLast();
    }
    _pathsList.add(newRoute?.settings.name ?? 'null');
    if (_debug) {
      print(
          '$name: didReplace: ${oldRoute?.settings.name ?? 'null'} -> ${newRoute?.settings.name ?? 'null'}');
    }

    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    notifyListeners();
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    if (_debug) {
      print(
          '$name: didStartUserGesture: ${previousRoute?.settings.name ?? 'null'} -> ${route.settings.name}');
    }
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    if (_debug) {
      print('$name: didStopUserGesture');
    }
    super.didStopUserGesture();
  }
}

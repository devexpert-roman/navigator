import 'package:BB_navigation/navigation.dart';

class NavigationMaster {
  static final NavigationMaster instance = NavigationMaster._();

  NavigationMaster._() {}

  factory NavigationMaster() {
    return instance;
  }
  NavigatorManager? _defaultNavigator;
  NavigatorManager? get defaultNavigator => _defaultNavigator;
  set defaultNavigator(NavigatorManager? man) {
    _defaultNavigator = man;
  }

  Map<String, NavigatorManager> _map = {};
  NavigatorManager? getNavManagerByName(String name) {
    return _map[name];
  }

  List<NavigatorManager> getNavManagers() {
    return _map.values.toList();
  }

  void addNavManager(NavigatorManager manager) {
    _map[manager.name] = manager;
  }

  void removeNavManager(NavigatorManager manager) {
    _map.remove(manager.name);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:ocean_builder/route_info/route_info_parser.dart';
import 'package:ocean_builder/route_info/router_manager.dart';
import 'package:provider/provider.dart';
import 'package:ocean_builder/router.dart' as obRoute;

class RouterDelegateOB extends RouterDelegate<TheAppPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TheAppPath> {
  RouterDelegateOB() {
    // This part is important because we pass the notification
    // from RoutePageManager to RouterDelegate. This way our navigation
    // changes (e.g. pushes) will be reflected in the address bar
    pageManager.addListener(notifyListeners);
  }
  final RoutePageManager pageManager = RoutePageManager();

  /// In the build method we need to return Navigator using [navigatorKey]
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RoutePageManager>.value(
      value: pageManager,
      child: Consumer<RoutePageManager>(
        builder: (context, pageManager, child) {
          return Navigator(
            key: navigatorKey,
            onPopPage: _onPopPage,
            pages: List.of(pageManager.pages),
            initialRoute: obRoute.initialRoute,
            onGenerateRoute: obRoute.Router.generateRoute,
          );
        },
      ),
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }

    /// Notify the PageManager that page was popped
    pageManager.didPop(route.settings);

    return true;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => pageManager.navigatorKey;

  @override
  TheAppPath get currentConfiguration => pageManager.currentPath;

  @override
  Future<void> setNewRoutePath(TheAppPath configuration) async {
    await pageManager.setNewRoutePath(configuration);
  }
}

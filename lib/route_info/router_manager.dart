import 'package:flutter/material.dart';
import 'package:ocean_builder/route_info/route_info_parser.dart';
import 'package:ocean_builder/splash/splash_screen.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/screens/rooms/room_details.dart';
import 'package:provider/provider.dart';

class RoutePageManager extends ChangeNotifier {
  static RoutePageManager of(BuildContext context) {
    return Provider.of<RoutePageManager>(context, listen: false);
  }

  /// Here we are storing the current list of pages
  List<Page> get pages => List.unmodifiable(_pages);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final List<Page> _pages = [
    MaterialPage(
      child: SplashScreen(), // MainScreen(),
      key: const Key('MainScreen'),
      name: SplashScreen.routeName,
    ),
  ];

  TheAppPath get currentPath {
    return parseRoute(Uri.parse(_pages.last.name));
  }

  void didPop(Page page) {
    // _pages.remove(page);
    // notifyListeners();
    if (_pages.isNotEmpty) {
      if (_pages.last == page) {
        _pages.remove(page);
        notifyListeners();
      }
    }
  }

  /// This is where we handle new route information and manage the pages list
  Future<void> setNewRoutePath(TheAppPath configuration) async {
    if (configuration.isMainMenu) {
      _pages.add(
        MaterialPage(
          child: LandingScreen(),
          key: UniqueKey(),
          name: LandingScreen.routeName,
        ),
      );
    } else if (configuration.isUnknown) {
      // Handling 404
      _pages.add(
        MaterialPage(
          child: SplashScreen(),
          key: UniqueKey(),
          name: '/404',
        ),
      );
    } else if (configuration.isRoomDashboard) {
      // Handling details screens
      _pages.insert(
        0,
        MaterialPage(
          child: RoomDetails(),
          key: UniqueKey(),
          name: "/",
        ),
      );
    } else if (configuration.isHomePage) {
      // Restoring to MainScreen
      _pages.removeWhere(
        (element) => element.key != const Key('MainScreen'),
      );
    }
    notifyListeners();
    return;
  }

  void openDetails() {
    setNewRoutePath(TheAppPath.details(_pages.length));
  }

  void openMainMenu() {
    setNewRoutePath(TheAppPath.mainMenu());
  }

  void openRoomsDashboard() {
    setNewRoutePath(TheAppPath.roomDashboard());
  }

  void resetToHome() {
    setNewRoutePath(TheAppPath.home());
  }

  void addDetailsBelow() {
    // _pages.insert(
    //   _pages.length - 1,
    //   MaterialPage(
    //     child: DetailsScreen(id: _pages.length),
    //     key: UniqueKey(),
    //     name: '/details/${_pages.length}',
    //   ),
    // );
    notifyListeners();
  }
}

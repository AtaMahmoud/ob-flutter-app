import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ocean_builder/route_info/result_screen.dart';
import 'package:ocean_builder/splash/splash_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/design_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/spar_design_screen.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/screens/rooms/room_details.dart';
import 'package:ocean_builder/ui/screens/rooms/rooms.dart';
import 'package:provider/provider.dart';

import 'custom_page.dart';

class PageManager extends ChangeNotifier {
  /// it's important to provide new list for Navigator each time
  /// because it compares previous list with the next one on each [NavigatorState didUpdateWidget]
  List<Page> get pages => List.unmodifiable(_pages);

  final List<Page> _pages = [
    MaterialPage(
      child: SplashScreen(),
      key: Key('MainPage'),
      name: 'MainScreen',
    ),
  ];

  final _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// This completer is used to handle returning values
  /// from [ResultablePage]. In this case it's a single
  /// completer field because we assume that only 1 page
  /// in the entire lifetime of the app can return a value.
  Completer<bool> _boolResultCompleter;

  static PageManager of(BuildContext context) {
    return Provider.of<PageManager>(context, listen: false);
  }

  void openDetails() {
    _pages.add(
      MaterialPage(
        child: LandingScreen(),
        key: LandingScreen.pageKey,
        name: LandingScreen.routeName,
      ),
    );
    notifyListeners();
  }

  void openMainMenu() {
    _pages.add(
      MaterialPage(
        child: Rooms(),
        key: Rooms.pageKey,
        name: Rooms.routeName,
      ),
    );
    makeRootPage();
  }

  /// Simple method to use instead of `await Navigator.push(context, ...)`
  ///
  /// This way you can handle pushing pages that are
  /// expetected to return some value.
  ///
  /// Here I'm using single completer to wait for the result.
  ///
  /// The result can be set either by [returnWith] or by popping the page
  /// as you would normally do with old Navigator ([didPop] and [_setResult]).
  Future<bool> waitForResult() async {
    _boolResultCompleter = Completer<bool>();
    _pages.add(
      ResultablePage(
        child: ResultScreen(),
        key: ResultScreen.pageKey,
        name: 'ResultScreen',
      ),
    );
    notifyListeners();
    return _boolResultCompleter.future;
  }

  /// This is custom method to pass returning value
  /// while popping the page. It can be considered as an example
  /// alternative to returning value with `Navigator.pop(context, value)`.
  void returnWith(bool value) {
    if (_boolResultCompleter != null) {
      _pages.removeLast();
      _boolResultCompleter.complete(value);
      notifyListeners();
    }
  }

  void addOtherPageBeneath({Widget child}) {
    final inserted = child != null
        ? MaterialPage(
            child: child,
            key: UniqueKey(),
            name: '${child.runtimeType}',
          )
        : MaterialPage(
            child: LandingScreen(),
            key: Key('LandingScreen${_pages.length - 1}'),
            name: 'OtherScreen',
          );
    _pages.insert(
      _pages.length - 1,
      inserted,
    );
    notifyListeners();
  }

  void pushTwoPages() {
    _pages.addAll(
      [
        // You can also use CustomPage instead of MaterialPage
        CustomPage(
          builder: (_) => DesignScreen(),
          key: UniqueKey(),
          name: 'DesignScreen',
        ),
        CustomPage(
          builder: (_) => SparDesignScreen(),
          key: SparDesignScreen.pageKey,
          name: 'SparDesignScreen',
        ),
      ],
    );
    notifyListeners();
  }

  void makeRootPage() {
    _pages.removeRange(0, _pages.length - 1);
    notifyListeners();
  }

  bool isRootPage(Key key) {
    final value = _pages.elementAt(0).key == key;

    return value;
  }

  void replaceTopWith(Widget child) {
    _pages.removeAt(_pages.length - 1);
    _pages.add(
      MaterialPage(
        child: child,
        key: UniqueKey(),
        name: '${child.runtimeType}',
      ),
    );
    notifyListeners();
  }

  void _setResult(dynamic result) {
    if (result is bool && _boolResultCompleter != null) {
      _boolResultCompleter.complete(result);
    }
    if (result == null) {
      print('Result was null');
    }
  }

  void didPop(Page page, dynamic result) {
    _pages.remove(page);
    if (page is ResultablePage) {
      _setResult(result);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _boolResultCompleter?.complete();
  }
}

/// MaterialPage that is expected to return a result
class ResultablePage extends MaterialPage {
  const ResultablePage({
    @required Widget child,
    LocalKey key,
    String name,
  }) : super(
          key: key,
          name: name,
          child: child,
        );
}

import 'package:flutter/material.dart';

class RouteInformationParserOB extends RouteInformationParser<TheAppPath> {
  @override
  Future<TheAppPath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    return parseRoute(uri);
  }

  @override
  RouteInformation restoreRouteInformation(TheAppPath path) {
    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isDetailsPage) {
      return RouteInformation(location: '/details/${path.id}');
    }
    return null;
  }
}

TheAppPath parseRoute(Uri uri) {
  // Handle '/'
  if (uri.pathSegments.isEmpty) {
    return TheAppPath.home();
  }

  // Handle '/details/:id'
  if (uri.pathSegments.length == 2) {
    if (uri.pathSegments[0] != 'details') return TheAppPath.unknown();
    var remaining = uri.pathSegments[1];
    var id = int.tryParse(remaining);
    if (id == null) return TheAppPath.unknown();
    return TheAppPath.details(id);
  }

  // Handle unknown routes
  return TheAppPath.unknown();
}

class TheAppPath {
  final int id;

  TheAppPath.home() : id = null;

  TheAppPath.details(this.id);

  TheAppPath.unknown() : id = -1;

  bool get isHomePage => id == null;

  bool get isDetailsPage => id != null;

  bool get isUnknown => id == -1;
}

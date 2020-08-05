import 'package:flutter/material.dart';

class ConnectionStatusProvider extends ChangeNotifier {
  bool _isConnectedToInternet = false;
  bool get isConnectedToInternet {
    return _isConnectedToInternet;
  }

  void toogleInternetConnectionStatus(bool newStatus) {
    _isConnectedToInternet = newStatus;
    notifyListeners();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class BaseProvider extends ChangeNotifier {
  bool isLoading = false;
  User authenticatedUser;
  // final Firestore firestore = Firestore.instance;
}

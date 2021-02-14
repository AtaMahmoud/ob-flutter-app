import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SearchHistoryProvider with ChangeNotifier {
  String _searchHistory = 'searchHistory';

  List _searchList = <String>[];

  List get searchList => _searchList;

  addSearchItem(String searchItem) async {
    var box = await Hive.openBox<String>(_searchHistory);

    box.add(searchItem);

    print('search item added');

    notifyListeners();
  }

  getSearchItem() async {
    final box = await Hive.openBox<String>(_searchHistory);

    _searchList = box.values.toList();

    notifyListeners();
  }

  updateSearchItem(int index, String searchItem) {
    final box = Hive.box<String>(_searchHistory);

    box.putAt(index, searchItem);

    notifyListeners();
  }

  deleteSearchItem(int index) {
    final box = Hive.box<String>(_searchHistory);

    box.deleteAt(index);

    getSearchItem();

    notifyListeners();
  }
}

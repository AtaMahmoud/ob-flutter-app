import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SearchHistoryProvider with ChangeNotifier {
  String _searchHistory = 'searchHistory';
  int _maxSearchHistoryLength = 5;

  List _searchList = <String>[];

  List get searchList => _searchList;

  addSearchItem(String searchItem) async {
    var box = await Hive.openBox<String>(_searchHistory);

    // check for maximum length and if repeat then put first

    if (searchItem != null && searchItem.isEmpty) return;
    if (box.values.contains(searchItem)) {
      print('adding duplciate searchItem history ${searchItem}');
      _putSearchItemFirst(searchItem);
      return;
    } else {
      print('no match for $searchItem');
    }

    box.add(searchItem);

    print('search item added');

    if (box.values.length > _maxSearchHistoryLength) {
      int activeLength = box.length - _maxSearchHistoryLength;
      for (var i = 0; i < activeLength; i++) {
        box.deleteAt(i);
      }
    }

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

  _putSearchItemFirst(String searchItem) {
    print('push $searchItem first');
    final box = Hive.box<String>(_searchHistory);
    int deletIndex = 0;
    for (var i = 0; i < box.length; i++) {
      String s = box.getAt(i);
      if (s.compareTo(searchItem) == 0) {
        deletIndex = i;
      }
    }
    deleteSearchItem(deletIndex);
    addSearchItem(searchItem);
    // box.add(searchItem);
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ocean_builder/core/models/search_item.dart';

class SelectedHistoryProvider with ChangeNotifier {
  String _selectedHistory = 'selectedHistory';
  int _maxSelectedHistoryLength = 5;

  List _selctedList = <SearchItem>[];

  List get selctedList => _selctedList.reversed.toList();

  addSelectedItem(SearchItem selectedItem) async {
    var box = await Hive.openBox<SearchItem>(_selectedHistory);

    if (selectedItem != null && selectedItem.routeName.isEmpty) return;
    if (box.values.contains(selectedItem)) {
      _putSelectedItemFirst(selectedItem);
      return;
    }

    box.add(selectedItem);

    print('selected item added');

    if (box.values.length > _maxSelectedHistoryLength) {
      int activeLength = box.length - _maxSelectedHistoryLength;
      for (var i = 0; i < activeLength; i++) {
        deleteSelectedItem(i);
      }
    }

    notifyListeners();
  }

  getSelectedItem() async {
    final box = await Hive.openBox<SearchItem>(_selectedHistory);

    _selctedList = box.values.toList();

    notifyListeners();
  }

  updateSelectedItem(int index, SearchItem selectedItem) {
    final box = Hive.box<SearchItem>(_selectedHistory);

    box.putAt(index, selectedItem);

    notifyListeners();
  }

  deleteSelectedItem(int index) {
    final box = Hive.box<SearchItem>(_selectedHistory);

    box.deleteAt(index);

    getSelectedItem();

    notifyListeners();
  }

  _putSelectedItemFirst(SearchItem searchItem) {
    final box = Hive.box<SearchItem>(_selectedHistory);
    addSelectedItem(searchItem);
    int deletIndex = 0;
    for (var i = 0; i < box.length; i++) {
      SearchItem s = box.getAt(i);
      if (s.routeName.compareTo(searchItem.routeName) == 0) {
        deletIndex = i;
      }
    }
    deleteSelectedItem(deletIndex);
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ocean_builder/core/models/search_item.dart';

class SelectedHistoryProvider with ChangeNotifier {
  String _selectedHistory = 'selectedHistory';

  List _selctedList = <SearchItem>[];

  List get selctedList => _selctedList;

  addSelectedItem(SearchItem selectedItem) async {
    var box = await Hive.openBox<SearchItem>(_selectedHistory);

    box.add(selectedItem);

    print('selected item added');

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
}

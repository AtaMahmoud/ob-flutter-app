import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ocean_builder/core/models/search_item.dart';

class SelectedAppItemProvider with ChangeNotifier {
  String _selectedHistory = 'selectedHistory';

  List _selctedList = <SearchItem>[];

  List get selctedList => _selctedList;

  addItem(SearchItem selectedItem) async {
    var box = await Hive.openBox<SearchItem>(_selectedHistory);

    box.add(selectedItem);

    print('added');

    notifyListeners();
  }

  getItem() async {
    final box = await Hive.openBox<SearchItem>(_selectedHistory);

    _selctedList = box.values.toList();

    notifyListeners();
  }

  updateItem(int index, SearchItem selectedItem) {
    final box = Hive.box<SearchItem>(_selectedHistory);

    box.putAt(index, selectedItem);

    notifyListeners();
  }

  deleteItem(int index) {
    final box = Hive.box<SearchItem>(_selectedHistory);

    box.deleteAt(index);

    getItem();

    notifyListeners();
  }
}

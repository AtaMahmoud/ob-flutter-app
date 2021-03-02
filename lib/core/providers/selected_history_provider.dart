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
    // box.values.map((selectItem) {
    //   print(
    //       '====================================${selectItem.routeName}-------- ${selectedItem.routeName}');
    //   if (selectItem.routeName
    //           .toLowerCase()
    //           .compareTo(selectedItem.routeName.toLowerCase()) ==
    //       0) {
    //     print('adding duplciate select history ${selectedItem.routeName}');
    //     _putSelectedItemFirst(selectedItem);
    //     return;
    //   } else {
    //     print('no match');
    //   }
    // }).toList();

    bool _pushedToFirst = box.values.any((selectItem) {
      if (selectItem.routeName.compareTo(selectedItem.routeName) == 0) {
        // print('adding duplciate select history ${selectedItem.routeName}');
        _putSelectedItemFirst(selectedItem);
        return true;
      } else {
        // print('no match');
        return false;
      }
    });

    if (_pushedToFirst) return;

    box.add(selectedItem);

    print('selected item added');

    if (box.values.length > _maxSelectedHistoryLength) {
      int activeLength = box.length - _maxSelectedHistoryLength;
      for (var i = 0; i < activeLength; i++) {
        box.deleteAt(i);
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
    // print('delete selected item');
    final box = Hive.box<SearchItem>(_selectedHistory);

    box.deleteAt(index);

    getSelectedItem();

    notifyListeners();
  }

  _putSelectedItemFirst(SearchItem selectedItem) {
    // print('push selected item first');
    final box = Hive.box<SearchItem>(_selectedHistory);

    int deletIndex = 0;
    for (var i = 0; i < box.length; i++) {
      SearchItem s = box.getAt(i);
      if (s.routeName.compareTo(selectedItem.routeName) == 0) {
        deletIndex = i;
      }
    }
    // print('delete index ----- $deletIndex');
    deleteSelectedItem(deletIndex);
    addSelectedItem(selectedItem);
    // box.add(selectedItem);
  }
}

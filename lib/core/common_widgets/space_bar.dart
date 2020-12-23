import 'package:flutter/material.dart';
import 'package:ocean_builder/core/common_widgets/select_button.dart';
import 'package:ocean_builder/core/common_widgets/space_item.dart';
import 'package:rxdart/rxdart.dart';

class SpaceBar extends StatefulWidget {
  SpaceBar({this.stream, this.changed, this.spaceItems, Key key})
      : super(key: key);
  final List<SpaceItemData> spaceItems;
  final Observable<int> stream;
  final Function changed;
  @override
  _SpaceBarState createState() => _SpaceBarState();
}

class _SpaceBarState extends State<SpaceBar> {
  List<SpaceItemData> spaceItems = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    spaceItems = widget.spaceItems;
  }

  _validateItem(int selctedIndex) {
    debugPrint('check for selected item $selctedIndex');
    for (var i = 0; i < spaceItems.length; i++) {
      SpaceItemData item = spaceItems[i];
      if (item.index == selctedIndex) {
        item.isSelected = true;
      } else {
        item.isSelected = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getSpaceBar(),
    );
  }

  _getSpaceBar() {
    return StreamBuilder<int>(
      stream: widget.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _validateItem(_selectedIndex);
        }
        return SingleChildScrollView(
          clipBehavior: Clip.antiAlias,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              ...spaceItems.map((sp) {
                print('creating item -- ${sp.label} -- ${sp.isSelected}');
                Widget spaceItem = 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SpaceItem(
                    label: sp.label,
                    hasWarning: sp.hasWarning,
                    isSelected: sp.isSelected,
                    onPressed: () {
                      // on item pressed
                      _selectedIndex = sp.index;
                      widget.changed.call(_selectedIndex);
                      if (sp.label.compareTo('Livingroom') == 0) {
                        debugPrint('Navigate to living room details');
                      } else {
                        debugPrint('Navigate to another room details');
                      }
                    },
                  ),
                );
                return spaceItem;
              }).toList()
            ],
          ),
        );
      },
    );
  }
}

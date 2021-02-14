import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/search_item.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/search/search_utils.dart';
import 'package:provider/provider.dart' as provider;
import 'package:ocean_builder/core/providers/selected_search_history_provider.dart';
import 'package:provider/provider.dart';

class SelectHistory extends StatelessWidget {
  SearchItem selectedChoice;

  // ScreenUtil _util = ScreenUtil();
  BuildContext _context;
  // List<SearchItem> items = [];
  SelectHistory();

  _buildChoiceList(items) {
    return List<Widget>.generate(
      items.length,
      (int index) {
        return _buildChoiceChip(items[index], index);
      },
    ).toList();
  }

  _buildChoiceChip(SearchItem item, index) {
    return Padding(
      padding: EdgeInsets.only(left: 4, right: 4),
      child: ActionChip(
        label: Text(item.name),
        labelStyle: TextStyle(
            fontSize: AppTheme.subtitle.fontSize,
            // fontWeight: FontWeight.w800,
            // letterSpacing: util.setSp(2),
            color: ColorConstants.COLOR_NOTIFICATION_DIVIDER),
        autofocus: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64.w),
            side: BorderSide(
                color: ColorConstants.COLOR_NOTIFICATION_DIVIDER, width: 1)),
        elevation: 8.w,
        backgroundColor: AppTheme.nearlyWhite,
        onPressed: () {
          navigateTo(_context, item);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _selectedAppItemProvider =
        Provider.of<SelectedAppItemProvider>(context, listen: false);
    _context = context;
    List<SearchItem> _list = _selectedAppItemProvider.selctedList;
    print('---------------------- ${_list.length}');
    return Center(
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            children: _buildChoiceList(_list),
          ),
        ],
      ),
    );
    ;
  }
}

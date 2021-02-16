import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/search_item.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/search/search_utils.dart';
import 'package:provider/provider.dart' as provider;
import 'package:ocean_builder/core/providers/selected_history_provider.dart';
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
        padding: EdgeInsets.all(0),
        labelStyle: Theme.of(_context).textTheme.bodyText1.apply(
              color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
            ),
        // TextStyle(
        //     fontSize: 12,
        //     // fontWeight: FontWeight.w800,
        //     // letterSpacing: util.setSp(2),
        //     color: ColorConstants.COLOR_NOTIFICATION_DIVIDER),
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

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _context = context;
    var _selectedAppItemProvider =
        Provider.of<SelectedHistoryProvider>(context, listen: false);
    _context = context;
    List<SearchItem> _list = _selectedAppItemProvider.selctedList;
    return Stack(
      children: [
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 2),
        //   child: SingleChildScrollView(
        //     controller: _scrollController,
        //     scrollDirection: Axis.horizontal,
        //     child: Row(
        //       children: [
        //         Wrap(
        //           alignment: WrapAlignment.center,
        //           children: _buildChoiceList(_list),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(16, 16),
                  bottomLeft: Radius.elliptical(16, 16)),
              splashColor: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: SvgPicture.asset(
                  ImagePaths.svgBack,
                  color: ColorConstants.TOP_CLIPPER_END_DARK,
                ),
              ),
              // Icon(Icons.arrow_left,
              //     size: 48, color: ColorConstants.TOP_CLIPPER_END_DARK),
              onTap: () {
                _scrollController.animateTo(
                    _scrollController.position.minScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: _buildChoiceList(_list),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.only(
                  topRight: Radius.elliptical(16, 16),
                  bottomRight: Radius.elliptical(16, 16)),
              splashColor: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: SvgPicture.asset(
                  ImagePaths.svgNext,
                  color: ColorConstants.TOP_CLIPPER_END_DARK,
                  // width: 24,
                  // height: 24,
                ),
              ),
              // Icon(Icons.arrow_right,
              // size: 48, color: ColorConstants.TOP_CLIPPER_END_DARK),
              onTap: () {
                _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
            ),
          ],
        )
      ],
    );
  }
}

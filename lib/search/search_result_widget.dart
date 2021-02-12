import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/search_item.dart';
import 'package:ocean_builder/search/appSearchScreen.dart';
import 'package:ocean_builder/search/search_utils.dart';
import 'package:ocean_builder/search/selected_items.dart';

class SearchResultsListView extends StatelessWidget {
  final String searchTerm;

  // final List<SearchItem> appItems;

  final List<SearchItem> suggestedItems;

  final List<SearchItem> resutlItems;

  final double paddingTop;

  SearchResultsListView(
      {Key key,
      @required this.searchTerm,
      // @required this.appItems,
      this.suggestedItems,
      this.resutlItems,
      this.paddingTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fsb = FloatingSearchBar.of(context);

    // debugPrint('padding applied to reasult result ---------- {$paddingTop }');

    // if (searchTerm == null) {
    return Container(
      margin:
          EdgeInsets.only(top: fsb.height + fsb.margins.vertical + paddingTop),
      child: Stack(
        children: [
          resutlItems.length < 2 ? _wdgt_startSearching(context) : Container(),
          suggestedItems != null && suggestedItems.length > 0
              ? SelectHistory(suggestedItems)
              : Container(),
          _searchResultList(fsb, context)
        ],
      ),
    );
  }

  Center _wdgt_startSearching(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
          ),
          Text(
            'Start searching',
            style: Theme.of(context)
                .textTheme
                .headline5
                .apply(color: ColorConstants.COLOR_NOTIFICATION_DIVIDER),
          )
        ],
      ),
    );
  }

  Container _searchResultList(
      FloatingSearchBarState fsb, BuildContext context) {
    double _top = 64.0 * (suggestedItems.length ~/ 3);

    if (suggestedItems.length > 0 && suggestedItems.length < 3) {
      _top = 72;
    } else {
      _top = 0.0;
    }
    return Container(
      padding: EdgeInsets.only(top: _top),
      child: ListView(
        shrinkWrap: true,
        //     EdgeInsets.only(top: fsb.height + fsb.margins.vertical + paddingTop),
        children: List.generate(
          resutlItems.length,
          (index) {
            return _resultWidget(context, index);
          },
        ),
      ),
    );
  }

  Card _resultWidget(BuildContext context, int index) {
    return Card(
      elevation: 8.0,
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(64.w),
      //     side:
      //         BorderSide(color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER)),
      child: Center(
        child: ListTile(
          onTap: () {
            searchedItems.add(resutlItems[
                index]); // write add suggested items, push to first and remove searched items methods
            navigateTo(context, resutlItems[index]);
          },
          title: Text('${resutlItems[index].name}'),
          subtitle: Text('${resutlItems[index].shortDesc}'),
        ),
      ),
    );
  }
}

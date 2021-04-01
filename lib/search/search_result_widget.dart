import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/search_item.dart';
import 'package:ocean_builder/core/providers/selected_history_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/search/appSearchScreen.dart';
import 'package:ocean_builder/search/search_utils.dart';
import 'package:ocean_builder/search/selected_items.dart';
import 'package:provider/provider.dart';

class SearchResultsListView extends StatelessWidget {
  final String searchTerm;

  List<SearchItem> suggestedItems;

  final List<SearchItem> resutlItems;

  final double paddingTop;

  SelectedHistoryProvider _selectedAppItemProvider;

  SearchResultsListView(
      {Key key, @required this.searchTerm, this.resutlItems, this.paddingTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _selectedAppItemProvider =
        Provider.of<SelectedHistoryProvider>(context, listen: false);
    suggestedItems = _selectedAppItemProvider.selctedList;

    final fsb = FloatingSearchBar.of(context);

    // print('------suggestedItems---------------- ${suggestedItems.length}');

    return Container(
      margin: EdgeInsets.only(
          top: fsb.widget.height + fsb.widget.margins.vertical + paddingTop),
      child: Stack(
        children: [
          resutlItems.length == 0 ? _wdgtStartSearching(context) : Container(),
          suggestedItems != null && suggestedItems.length > 0
              ? SelectHistory()
              : Container(),
          _searchResultList(fsb, context)
        ],
      ),
    );
  }

  SingleChildScrollView _wdgtStartSearching(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
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
      ),
    );
  }

  Container _searchResultList(
      FloatingSearchBarState fsb, BuildContext context) {
    double _top = 72.0;
    if (suggestedItems != null && suggestedItems.length == 0) {
      _top = 0.0;
    }
    return Container(
      padding: EdgeInsets.only(top: _top),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 0),
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
            // searchedItems.add(resutlItems[
            //     index]); // write add suggested items, push to first and remove searched items methods
            _selectedAppItemProvider.addSelectedItem(resutlItems[index]);
            _selectedAppItemProvider.getSelectedItem();
            navigateTo(context, resutlItems[index]);
          },
          title: Text(
            '${resutlItems[index].name}',
            style: AppTheme.title.apply(
                color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
                fontWeightDelta: 0),
          ),
          subtitle: Text('${resutlItems[index].shortDesc}',
              style: AppTheme.subtitle.apply(
                  color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
                  fontWeightDelta: 0)),
        ),
      ),
    );
  }
}

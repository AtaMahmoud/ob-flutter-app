import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/search_history_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/search/search_result_widget.dart';
import 'package:ocean_builder/core/models/search_item.dart';
import 'package:provider/provider.dart';

const historyLength = 5;
const selectHistoryLength = 5;

class AppSearchScreen extends StatefulWidget {
  static const String routeName = '/appSearch';
  AppSearchScreen({Key key}) : super(key: key);

  @override
  _AppSearchScreenState createState() => _AppSearchScreenState();
}

class _AppSearchScreenState extends State<AppSearchScreen> {
  List<SearchItem> _appItems = [];

  // List<String> _searchHistory = [];

  List<String> _filteredSearchHistory;

  String selectedTerm;

  List<SearchItem> resutlItems = [];

  double paddingTop = 0;

  var k = 0;

  SearchHistoryProvider _searchHistoryProvider;

  List<String> filterSearchTerms({
    @required String filter,
  }) {
    List<String> _searchHistory = _searchHistoryProvider.searchList;
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed.where((term) {
        return term.toLowerCase().startsWith(filter.toLowerCase());
      }).toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (term != null && term.isEmpty) return;
    _searchHistoryProvider.addSearchItem(term);
    _filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    if (term != null && term.isEmpty) return;
    int deletIndex = 0;
    for (var i = 0; i < _searchHistoryProvider.searchList.length; i++) {
      String s = _searchHistoryProvider.searchList[i];
      if (s.compareTo(term) == 0) {
        deletIndex = i;
      }
    }
    _searchHistoryProvider.deleteSearchItem(deletIndex);
    _filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController controller;

  // GenericBloc<double> _blocPadding = GenericBloc(null);

  bool _isSearchBarActive = false;

  // var _futureSearchHistoryBox;

  @override
  void initState() {
    super.initState();
    // _blocPadding.sink.add(10.0);
    _appItems = GlobalContext.appItems;
    _searchHistoryProvider =
        Provider.of<SearchHistoryProvider>(context, listen: false);
    controller = FloatingSearchBarController();
  }

  @override
  void didChangeDependencies() {
    _filteredSearchHistory = filterSearchTerms(filter: null);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _processSearchResult() {
    if (selectedTerm != null && selectedTerm.isNotEmpty) {
      resutlItems = _appItems
          .where((term) =>
              term.name.toLowerCase().startsWith(selectedTerm.toLowerCase()))
          .toList();
    } else {
      resutlItems = _appItems.toList();
    }

    if (_isSearchBarActive) {
      if (_filteredSearchHistory != null && _filteredSearchHistory.length > 0) {
        paddingTop = _filteredSearchHistory.length * 64.0;
      } else {
        paddingTop = 72.0;
      }
    } else {
      paddingTop = 0.0;
    }
  }

  Key _keyScaffold2 = Key('scaffold2');

  @override
  Widget build(BuildContext context) {
    context.watch<SearchHistoryProvider>().getSearchItem();
    return Consumer<SearchHistoryProvider>(builder: (context, model, widget) {
      if (model.searchList != null) {
        return _buildSearchScreenScaffold(context, _keyScaffold2);
      }
      return _buildSearchScreenScaffold(context, _keyScaffold2);
    });
  }

  Scaffold _buildSearchScreenScaffold(BuildContext context, Key scaffoldKey) {
    _processSearchResult();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white, //AppTheme.notWhite,
      body: FloatingSearchBar(
        backdropColor: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        margins: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top + 12.h,
            left: 8.w,
            right: 8.w),
        // AppTheme.notWhite, // ColorConstants.COLOR_NOTIFICATION_DIVIDER,
        controller: controller,
        height: 40,

        insets: EdgeInsets.symmetric(horizontal: 4.0),
        body: SearchResultsListView(
          searchTerm: selectedTerm,
          // appItems: _appItems,
          resutlItems: resutlItems,
          paddingTop: paddingTop,
        ),
        backgroundColor: AppTheme.nearlyWhite,
        iconColor: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
        borderRadius: BorderRadius.circular(8),
        border: BorderSide(
            color: ColorConstants.COLOR_NOTIFICATION_DIVIDER, width: 1),
        transition: CircularFloatingSearchBarTransition(),
        // debounceDelay: Duration(milliseconds: 5),
        // progress: 0.5,
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm ?? 'Search within app',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .apply(color: ColorConstants.COLOR_NOTIFICATION_DIVIDER),
        ),
        scrollPadding: EdgeInsets.all(0),
        hint: 'Search and find out...',
        hintStyle: Theme.of(context).textTheme.bodyText1.apply(
              color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
            ),
        queryStyle: Theme.of(context).textTheme.bodyText1.apply(
              color: ColorConstants.TOP_CLIPPER_END_DARK,
            ),
        // height: 32,
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onFocusChanged: (status) {
          // print('on focus changed status-- $status');
          setState(() {
            _isSearchBarActive = status;
          });
        },
        onQueryChanged: (query) {
          setState(() {
            selectedTerm = query;
            _filteredSearchHistory = filterSearchTerms(filter: query);
          });
        },
        clearQueryOnClose: false,
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
          });
          controller.close();
        },
        isScrollControlled: false,
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8)),
            child: Material(
              borderOnForeground: true,
              // borderRadius: BorderRadius.circular(8),
              shadowColor: ColorConstants.TOP_CLIPPER_END_DARK,
              color: ColorConstants.AVATAR_BKG,
              // elevation: 4,
              child: Builder(
                builder: (context) {
                  if (_filteredSearchHistory.isEmpty &&
                      controller.query.isEmpty) {
                    return //Container(width: double.infinity);
                        Container(
                      height: 54,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption.apply(
                            color: ColorConstants.COLOR_NOTIFICATION_DIVIDER),
                      ),
                    );
                  } else if (_filteredSearchHistory.isEmpty) {
                    return ListTile(
                      title: Text(
                        controller.query,
                        style: AppTheme.body1.apply(
                            color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
                            fontWeightDelta: 0),
                      ),
                      leading: const Icon(Icons.search,
                          color: ColorConstants.COLOR_NOTIFICATION_DIVIDER),
                      onTap: () {
                        setState(() {
                          addSearchTerm(controller.query);
                          selectedTerm = controller.query;
                        });
                        controller.close();
                      },
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: _filteredSearchHistory
                          .map(
                            (term) => ListTile(
                              contentPadding: EdgeInsets.only(left: 8),
                              title: Text(
                                term,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.body1.apply(
                                    color: ColorConstants
                                        .COLOR_NOTIFICATION_DIVIDER,
                                    fontWeightDelta: 0),
                              ),
                              leading: const Icon(Icons.history,
                                  color: ColorConstants
                                      .COLOR_NOTIFICATION_DIVIDER),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear,
                                    color: ColorConstants
                                        .COLOR_NOTIFICATION_DIVIDER),
                                onPressed: () {
                                  setState(() {
                                    deleteSearchTerm(term);
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  // putSearchTermFirst(term);
                                  addSearchTerm(term);
                                  selectedTerm = term;
                                });
                                controller.close();
                              },
                            ),
                          )
                          .toList(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

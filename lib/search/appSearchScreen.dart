import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/services/locator.dart';
import 'package:ocean_builder/core/services/navigation_service.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/search/search_result_widget.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/accessManagement/access_event_screen.dart';
import 'package:ocean_builder/ui/screens/accessManagement/access_management_screen.dart';
import 'package:ocean_builder/ui/screens/accessManagement/admin_access_screen.dart';
import 'package:ocean_builder/ui/screens/accessManagement/guest_access_screen.dart';
import 'package:ocean_builder/ui/screens/accessManagement/ob_access_req_events_screen.dart';
import 'package:ocean_builder/ui/screens/accessManagement/ob_events_screen.dart';
import 'package:ocean_builder/ui/screens/accessManagement/visitor_access_screen.dart';
import 'package:ocean_builder/core/models/access_request.dart';
import 'package:ocean_builder/ui/screens/controls/camera_screen.dart';
import 'package:ocean_builder/ui/screens/controls/control_screen.dart';
import 'package:ocean_builder/ui/screens/controls/lighting_scene_list_screen.dart';
import 'package:ocean_builder/ui/screens/controls/lighting_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/bed_living_room_enclosure_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/bedroom_wall_color_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/clean_water_level_indicator_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/deck_enclosure_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/deck_floor_finish_material_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/design_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/entry_stairs_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/exterior_color_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/exterior_finish_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/fathometer_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/kitchen_floor_finishing_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/kitchen_wall_color_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/living_room_floor_finishing_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/livingroom_wall_color_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/master_bedroom_floor_finishing_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/master_bedroom_wall_color_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/power_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/sound_system_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/spar_design_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/spar_finishing_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/underwater_room_finishing_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/underwater_windows_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/weather_station_screen.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/marine/marine_screen.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/screens/misc/earth_station_screen.dart';
import 'package:ocean_builder/ui/screens/notification/guest_request_response_screen.dart';
import 'package:ocean_builder/ui/screens/notification/invitation_response_screen.dart';
import 'package:ocean_builder/ui/screens/notification/noti_history_screen.dart';
import 'package:ocean_builder/ui/screens/notification/noti_history_screen_with_drawer.dart';
import 'package:ocean_builder/ui/screens/permission/create_permission_screen.dart';
import 'package:ocean_builder/ui/screens/permission/custom_permission_screen.dart';
import 'package:ocean_builder/ui/screens/permission/edit_permission_screen.dart';
import 'package:ocean_builder/ui/screens/permission/manage_permission_screen.dart';
import 'package:ocean_builder/ui/screens/profile/profile_screen.dart';
import 'package:ocean_builder/ui/screens/seapod_selection/ob_selection_widget_screen.dart';
import 'package:ocean_builder/ui/screens/settings/notification_settings.dart';
import 'package:ocean_builder/ui/screens/settings/settings_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/accept_invitation_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/email_verification_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/forgot_password_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/login_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/qr_code_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/registration_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/registration_screen_accept_invitation.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/request_access_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/set_password_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/your_info_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/your_obs_screen.dart';
import 'package:ocean_builder/ui/screens/weather/weather_more_widget.dart';
import 'package:ocean_builder/ui/screens/weather/weather_screen.dart';
import 'package:ocean_builder/core/models/search_item.dart';
import 'package:ocean_builder/ui/screens/accessManagement/grant_access_screen.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';

const historyLength = 5;
const selectHistoryLength = 5;

List<SearchItem> searchedItems = [];

class AppSearchScreen extends StatefulWidget {
  static const String routeName = '/appSearch';
  AppSearchScreen({Key key}) : super(key: key);

  @override
  _AppSearchScreenState createState() => _AppSearchScreenState();
}

class _AppSearchScreenState extends State<AppSearchScreen> {
  List<SearchItem> _appItems = [];

  List<String> _searchHistory = [];

  List<String> _filteredSearchHistory;

  String selectedTerm;

  List<SearchItem> resutlItems = [];

  double paddingTop = 0;

  Box _box_searchHistory;

  List<String> filterSearchTerms({
    @required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed.where((term) {
        return term.toLowerCase().startsWith(filter.toLowerCase());
      }).toList();
    } else {
      // _box_searchHistory.
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (term != null && term.isEmpty) return;
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);

    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    _box_searchHistory.add(term);
    if (_box_searchHistory.length > historyLength) {
      int activeLength = _box_searchHistory.length - historyLength;
      for (var i = 0; i < activeLength; i++) {
        _box_searchHistory.deleteAt(i);
      }
    }

    print('${_box_searchHistory.length}');

    _filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    if (term != null && term.isEmpty) return;
    _searchHistory.removeWhere((t) => t == term);
    _filteredSearchHistory = filterSearchTerms(filter: null);
    int deletIndex = 0;
    for (var i = 0; i < _box_searchHistory.length; i++) {
      String s = _box_searchHistory.getAt(i);
      if (s.compareTo(term) == 0) {
        deletIndex = i;
      }
    }
    _box_searchHistory.deleteAt(deletIndex);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController controller;

  // GenericBloc<double> _blocPadding = GenericBloc(null);

  bool _isSearchBarActive = false;

  var _futureSearchHistoryBox;

  @override
  void initState() {
    super.initState();
    // _blocPadding.sink.add(10.0);
    // Hive.openBox('searchHistory').then((box) {
    //   // box.clear();
    //   _box_searchHistory = box;
    // });
    _futureSearchHistoryBox = Hive.openBox('searchHistory');
    _appItems = GlobalContext.appItems;
    _searchHistory = GlobalContext.searchItems;
    controller = FloatingSearchBarController();
    _filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    // _blocPadding.dispose();
    print(
        'search history length before disposing ------ ${_searchHistory.length}');
    print('_box_searchHistory length --- ${_box_searchHistory.length}');
    _box_searchHistory.close();
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
        paddingTop = 64.0;
      }
    } else {
      paddingTop = 0.0;
    }

    debugPrint(
        'after processing search result --- length is ${resutlItems.length}  --------filteredSearch result ---- ${_filteredSearchHistory.length} ---- padding top is ---$paddingTop');
  }

  Key _keyScaffold2 = Key('scaffold2');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Hive.openBox('searchHistory'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              _box_searchHistory = snapshot.data;
              _searchHistory.clear();
              for (var i = 0; i < _box_searchHistory.length; i++) {
                String s = _box_searchHistory.getAt(i);
                _searchHistory.add(s);
                // GlobalContext.searchItems.add(s);
              }
              return _buildSearchScreenScaffold(context, _keyScaffold2);
            }
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
        // AppTheme.notWhite, // ColorConstants.COLOR_NOTIFICATION_DIVIDER,
        controller: controller,
        body: SearchResultsListView(
          searchTerm: selectedTerm,
          // appItems: _appItems,
          resutlItems: resutlItems,
          suggestedItems: searchedItems,
          paddingTop: paddingTop,
        ),
        backgroundColor: AppTheme.nearlyWhite,
        iconColor: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
        borderRadius: BorderRadius.circular(64.w),
        border: BorderSide(
            color: ColorConstants.COLOR_NOTIFICATION_DIVIDER, width: 1),
        transition: CircularFloatingSearchBarTransition(),
        debounceDelay: Duration(milliseconds: 5),
        // progress: 0.5,
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm ?? 'Search within app',
          style: Theme.of(context).textTheme.headline6.apply(
              color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
              fontWeightDelta: 0),
        ),
        hint: 'Search and find out...',
        hintStyle: Theme.of(context).textTheme.headline6.apply(
            color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
            fontWeightDelta: 0),
        // height: 32,
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onFocusChanged: (status) {
          print('on focus changed status-- $status');
          setState(() {
            _isSearchBarActive = status;
          });
        },
        onQueryChanged: (query) {
          setState(() {
            selectedTerm = query;
            _filteredSearchHistory = filterSearchTerms(filter: query);
            // if (filteredSearchHistory != null &&
            //     filteredSearchHistory.length > 0) {
            //   paddingTop = filteredSearchHistory.length * 54.0;
            // } else {
            //   paddingTop = 54.0;
            // }
            // if(searchedItems != null){
            //   paddingTop = paddingTop + searchedItems.length % 4 * 32.0;
            // }
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
            borderRadius: BorderRadius.circular(8),
            child: Material(
              borderOnForeground: true,
              // borderRadius: BorderRadius.circular(8),
              shadowColor: ColorConstants.TOP_CLIPPER_END_DARK,
              color: ColorConstants.AVATAR_BKG,
              elevation: 4,
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
                          color: ColorConstants.TOP_CLIPPER_END_DARK),
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
                      mainAxisSize: MainAxisSize.min,
                      children: _filteredSearchHistory
                          .map(
                            (term) => ListTile(
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
                                  color: ColorConstants.TOP_CLIPPER_END_DARK),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear,
                                    color: ColorConstants.TOP_CLIPPER_END_DARK),
                                onPressed: () {
                                  setState(() {
                                    deleteSearchTerm(term);
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  putSearchTermFirst(term);
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

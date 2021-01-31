import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
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

class AppSearchScreen extends StatefulWidget {
  static const String routeName = '/appSearch';
  AppSearchScreen({Key key}) : super(key: key);

  @override
  _AppSearchScreenState createState() => _AppSearchScreenState();
}

class _AppSearchScreenState extends State<AppSearchScreen> {
  List<AppNavigationItem> _appItems = [
    AppNavigationItem(name: 'Home', routeName: HomeScreen.routeName),
    AppNavigationItem(name: 'Control', routeName: ControlScreen.routeName),
    AppNavigationItem(name: 'Weather', routeName: WeatherScreen.routeName),
    AppNavigationItem(name: 'Marine', routeName: MarineScreen.routeName),
    AppNavigationItem(
        name: 'Weather Details', routeName: WeatherMoreWidget.routeName),
    AppNavigationItem(name: 'Profile', routeName: ProfileScreen.routeName),
    AppNavigationItem(name: 'Settings', routeName: SettingsWidget.routeName),
    AppNavigationItem(
        name: 'Change Email', routeName: SettingsWidget.routeName),
  ];

  static const historyLength = 5;
  static const selectHistoryLength = 5;

  List<String> _searchHistory = [
    'Home',
    'Controll',
    'Weather',
    'Marine',
  ];

  List<String> _selectHistory = [
    'Profile',
    'Permission',
    'Lighting',
    'Design',
    'Change Password'
  ];

  List<String> filteredSearchHistory;

  String selectedTerm;

  List<String> filterSearchTerms({
    @required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();

    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //AppTheme.notWhite,
      body: FloatingSearchBar(
        backdropColor:
            AppTheme.notWhite, // ColorConstants.COLOR_NOTIFICATION_DIVIDER,
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListView(
            searchTerm: selectedTerm,
            appItems: _appItems,
          ),
        ),
        backgroundColor: AppTheme.nearlyWhite,
        iconColor: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
        borderRadius: BorderRadius.circular(64.w),
        border: BorderSide(
            color: ColorConstants.COLOR_NOTIFICATION_DIVIDER, width: 2),
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm ?? 'Search within app',
          style: Theme.of(context).textTheme.headline6.apply(
                color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
              ),
        ),
        hint: 'Search and find out...',
        // hintStyle: Theme.of(context).textTheme.headline6.apply(
        //                   color: ColorConstants.COLOR_NOTIFICATION_DIVIDER,
        //                 ),
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(filter: query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
          });
          controller.close();
        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (filteredSearchHistory.isEmpty &&
                      controller.query.isEmpty) {
                    return Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  } else if (filteredSearchHistory.isEmpty) {
                    return ListTile(
                      title: Text(controller.query),
                      leading: const Icon(Icons.search),
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
                      children: filteredSearchHistory
                          .map(
                            (term) => ListTile(
                              title: Text(
                                term,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: const Icon(Icons.history),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear),
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

class SearchResultsListView extends StatelessWidget {
  final String searchTerm;

  final List<AppNavigationItem> appItems;

  const SearchResultsListView(
      {Key key, @required this.searchTerm, @required this.appItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fsb = FloatingSearchBar.of(context);

    if (searchTerm == null) {
      return Padding(
        padding: EdgeInsets.only(top: fsb.height + fsb.margins.vertical),
        child: Stack(
          children: [
            Center(
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
                    style: Theme.of(context).textTheme.headline5.apply(
                        color: ColorConstants.COLOR_NOTIFICATION_DIVIDER),
                  )
                ],
              ),
            ),
            SelectHistory(appItems)
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.only(top: fsb.height + fsb.margins.vertical),
      children: List.generate(
        50,
        (index) => ListTile(
          title: Text('$searchTerm search result'),
          subtitle: Text(index.toString()),
        ),
      ),
    );
  }
}

class SelectHistory extends StatefulWidget {
  final List<AppNavigationItem> items;
  SelectHistory(this.items);
  @override
  _SelectHistoryState createState() => _SelectHistoryState();
}

class _SelectHistoryState extends State<SelectHistory> {
  AppNavigationItem selectedChoice;

  ScreenUtil _util = ScreenUtil();

  @override
  void initState() {
    // debugPrint('init stat4e called in multiselect chip state');
    super.initState();
    selectedIndex = 0;
    // selectedLight = widget.lights[selectedIndex];
  }

  // this function will build and return the choice list
  _buildChoiceList() {
    // print(widget.lights);
    // debugPrint('widget.lights in MultiSelectChip ----- ${widget.lights.length}');

    return List<Widget>.generate(
      widget.items.length,
      (int index) {
        return _buildChoiceChip(widget.items[index], index);
      },
    ).toList();
  }

  _buildChoiceChip(AppNavigationItem item, index) {
    return Padding(
      padding: EdgeInsets.all(_util.setSp(8)),
      child: ActionChip(
        label: Text(item.name),
        labelStyle: TextStyle(
            fontSize: _util.setSp(48),
            // fontWeight: FontWeight.w800,
            // letterSpacing: util.setSp(2),
            color: ColorConstants.COLOR_NOTIFICATION_DIVIDER),
        autofocus: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_util.setWidth(64)),
            side: BorderSide(
                color: ColorConstants.COLOR_NOTIFICATION_DIVIDER, width: 1)),
        elevation: _util.setWidth(8),
        backgroundColor: AppTheme.nearlyWhite,
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context)
            .pushReplacementNamed(HomeScreen.routeName, arguments: 0);
          Navigator.of(context).pushNamed(item.routeName);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            children: _buildChoiceList(),
          ),
        ],
      ),
    );
  }
}

class AppNavigationItem {
  String name;
  String routeName;
  AppNavigationItem({this.name, this.routeName});
}

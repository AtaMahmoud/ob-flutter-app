import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/services/locator.dart';
import 'package:ocean_builder/core/services/navigation_service.dart';
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
import 'package:ocean_builder/core/models/search_item.dart';
import 'package:ocean_builder/ui/screens/accessManagement/grant_access_screen.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';

const historyLength = 5;
const selectHistoryLength = 5;

List<String> searchHistory = [
  'Home',
  'Controll',
  'Weather',
  'Marine',
];

List<SearchItem> searchedItems = [];

class AppSearchScreen extends StatefulWidget {
  static const String routeName = '/appSearch';
  AppSearchScreen({Key key}) : super(key: key);

  @override
  _AppSearchScreenState createState() => _AppSearchScreenState();
}

class _AppSearchScreenState extends State<AppSearchScreen> {
  List<SearchItem> _appItems = [
    SearchItem(
        name: 'Home',
        routeName: HomeScreen.routeName,
        shortDesc: 'Application Dashboard'),
    SearchItem(
        name: 'Control',
        routeName: ControlScreen.routeName,
        shortDesc:
            'Lighting, camera, stair and tempertaure controls and other seapod device stats'),
    SearchItem(
        name: 'Weather',
        routeName: WeatherScreen.routeName,
        shortDesc: 'Check weather data, forcasts and history with graphs'),
    SearchItem(
        name: 'Marine',
        routeName: MarineScreen.routeName,
        shortDesc: 'Check weather data, forcasts and history with graphs'),
    SearchItem(
        name: 'Weather Details',
        routeName: WeatherMoreWidget.routeName,
        shortDesc: 'Check weather details for next 7 days'),
    SearchItem(
        name: 'Profile',
        routeName: ProfileScreen.routeName,
        shortDesc: 'Check or modifly profile information'),
    SearchItem(
        name: 'Settings',
        routeName: SettingsWidget.routeName,
        shortDesc: 'Check email, password and notification settings'),
    SearchItem(
        name: 'Change Email',
        routeName: SettingsWidget.routeName,
        shortDesc: 'Change current email address'),
    SearchItem(
        name: 'Change Password',
        routeName: SettingsWidget.routeName,
        shortDesc: 'Change current password'),
    SearchItem(
        name: 'Notification Settings',
        routeName: SettingsWidget.routeName,
        shortDesc:
            'Check to enable or disable to get notification about access request, access inviation and urgent alarms'),
    SearchItem(
        name: 'Notifications',
        routeName: NotificationHistoryScreenWidget.routeName,
        shortDesc: 'Check to see all notifications'),
    SearchItem(
        name: 'Access Management',
        routeName: AccessManagementScreen.routeName,
        shortDesc:
            'Check to see sent invitations, received invitaions, sent access requests, received access requests and options to manage permissions, reqeust or invite to seapod, check memebrs of seapod , remove memebr or cancel invitaions'),
    SearchItem(
        name: 'Request Access',
        routeName: RequestAccessScreen.routeName,
        shortDesc: 'Check to send request to access seapod'),
    SearchItem(
        name: 'Send Access Invitaion',
        routeName: GrantAccessScreenWidget.routeName,
        shortDesc: 'Check to send invitaion to grant seapod access'),
    SearchItem(
        name: 'Manage permission',
        routeName: ManagePermissionScreen.routeName,
        shortDesc: 'Check to create, manage permissions'),
    SearchItem(
        name: 'Sent Invitaion',
        routeName: AccessEventScreen.routeName,
        shortDesc: 'Check to ses sent invitaions and their details'),
    SearchItem(
        name: 'Received Invitaion',
        routeName: AccessEventScreen.routeName,
        shortDesc: 'Check to ses received invitaions and their details'),
    SearchItem(
        name: 'Sent Request',
        routeName: AccessEventScreen.routeName,
        shortDesc: 'Check to ses sent requests and their details'),
    SearchItem(
        name: 'Received Request',
        routeName: AccessEventScreen.routeName,
        shortDesc: 'Check to ses received requests and their details'),
    SearchItem(
        name: 'Lighting',
        routeName: LightingScreen.routeName,
        shortDesc: 'Check to create, manage lighting colors and light scenes'),
    SearchItem(
        name: 'Cameras',
        routeName: CameraScreen.routeName,
        shortDesc: 'Check to see cameras and movement detection sign'),
    SearchItem(
        name: 'New Permission',
        routeName: CreatePermissionScreen.routeName,
        shortDesc: 'Check to create new permission'),
  ];

  List<String> filteredSearchHistory;

  String selectedTerm;

  List<SearchItem> resutlItems = [];

  double paddingTop = 0;

  List<String> filterSearchTerms({
    @required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    searchHistory.add(term);
    if (searchHistory.length > historyLength) {
      searchHistory.removeRange(0, searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: null);

    // setState(() {
    //   filteredSearchHistory = filterSearchTerms(filter: null);
    // });
  }

  void deleteSearchTerm(String term) {
    searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
    // setState(() {
    //   filteredSearchHistory = filterSearchTerms(filter: null);
    // });
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController controller;

  GenericBloc<double> _blocPadding = GenericBloc(null);

  @override
  void initState() {
    super.initState();
    _blocPadding.sink.add(10.0);
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    _blocPadding.dispose();
    super.dispose();
  }

  void _processSearchResult() {
    if (selectedTerm != null && selectedTerm.isNotEmpty) {
      resutlItems = _appItems
          .where((term) =>
              term.name.toLowerCase().startsWith(selectedTerm.toLowerCase()))
          .toList();
    }
    if (resutlItems == null || resutlItems.isEmpty)
      resutlItems = _appItems.toList();

    debugPrint(
        'after processing search result --- length is ${resutlItems.length}  --------filteredSearch result ---- ${filteredSearchHistory.length} ---- padding top is ---$paddingTop');
  }

  @override
  Widget build(BuildContext context) {
    _processSearchResult();
    return Scaffold(
      backgroundColor: Colors.white, //AppTheme.notWhite,
      body: FloatingSearchBar(
        backdropColor: Colors.transparent,
        // AppTheme.notWhite, // ColorConstants.COLOR_NOTIFICATION_DIVIDER,
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListView(
            searchTerm: selectedTerm,
            appItems: _appItems,
            resutlItems: resutlItems,
            suggestedItems: searchedItems,
            paddingTop: paddingTop,
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
        onFocusChanged: (status) {
          print(status);
          setState(() {
            if (status) {
              if (filteredSearchHistory != null) {
                paddingTop = filteredSearchHistory.length * 20.0;
              } else {
                paddingTop = searchHistory.length * 20.0;
              }
            } else {
              paddingTop = 0.0;
            }

            print('reseting state');
          });
        },
        onQueryChanged: (query) {
          setState(() {
            selectedTerm = query;
            filteredSearchHistory = filterSearchTerms(filter: query);
            if (filteredSearchHistory != null) {
              paddingTop = filteredSearchHistory.length * 20.0 + 20.0;
            }
          });
        },
        clearQueryOnClose: true,
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
              borderOnForeground: true,
              shadowColor: Colors.black,
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

  final List<SearchItem> appItems;

  final List<SearchItem> suggestedItems;

  final List<SearchItem> resutlItems;

  final double paddingTop;

  SearchResultsListView(
      {Key key,
      @required this.searchTerm,
      @required this.appItems,
      this.suggestedItems,
      this.resutlItems,
      this.paddingTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fsb = FloatingSearchBar.of(context);

    debugPrint('padding applied to reasult result ---------- {$paddingTop }');

    // if (searchTerm == null) {
    return Container(
      margin:
          EdgeInsets.only(top: fsb.height + fsb.margins.vertical + paddingTop),
      child: Stack(
        children: [
          resutlItems.length < 2 ? _wdgt_startSearching(context) : Container(),
          _searchResultList(fsb, context),
          SelectHistory(suggestedItems)
        ],
      ),
    );

    // }

    // return _searchResultList(fsb, context);
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

  ListView _searchResultList(FloatingSearchBarState fsb, BuildContext context) {
    return ListView(
      // padding:
      //     EdgeInsets.only(top: fsb.height + fsb.margins.vertical + paddingTop),
      children: List.generate(
        resutlItems.length,
        (index) {
          return _resultWidget(context, index);
        },
      ),
    );
  }

  Card _resultWidget(BuildContext context, int index) {
    return Card(
      elevation: 10.0,
      color: Colors.blueAccent,
      child: ListTile(
        onTap: () {
          searchedItems.add(resutlItems[
              index]); // write add suggested items, push to first and remove searched items methods
          _navigateTo(context, resutlItems[index]);
        },
        title: Text('${resutlItems[index].name}'),
        subtitle: Text('${resutlItems[index].shortDesc}'),
      ),
    );
  }
}

// class SelectHistory extends StatefulWidget {
//   final List<SearchItem> items;
//   SelectHistory(this.items);
//   @override
//   _SelectHistoryState createState() => _SelectHistoryState();
// }

class SelectHistory extends StatelessWidget {
  SearchItem selectedChoice;

  // ScreenUtil _util = ScreenUtil();
  BuildContext _context;
  final List<SearchItem> items;
  SelectHistory(this.items);

  // @override
  // void initState() {
  //   // debugPrint('init stat4e called in multiselect chip state');
  //   super.initState();
  //   selectedIndex = 0;
  //   // selectedLight = widget.lights[selectedIndex];
  // }

  // this function will build and return the choice list
  _buildChoiceList() {
    // print(widget.lights);
    // debugPrint('widget.lights in MultiSelectChip ----- ${widget.lights.length}');

    return List<Widget>.generate(
      items.length,
      (int index) {
        return _buildChoiceChip(items[index], index);
      },
    ).toList();
  }

  _buildChoiceChip(SearchItem item, index) {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: ActionChip(
        label: Text(item.name),
        labelStyle: TextStyle(
            fontSize: 48.sp,
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
          _navigateTo(_context, item);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
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

void _navigateTo(BuildContext context, SearchItem item) {
  Navigator.of(context).pop(item);
  // SELECTED_SEARCH_ITEM = item;
  // Navigator.of(context)
  //     .pushReplacementNamed(HomeScreen.routeName, arguments: 0);
  // Navigator.of(context).pushNamed(item.routeName);

  // locator<NavigationService>().navigateTo(item.routeName);

  // Future.delayed(Duration(seconds: 1))
  //     .then((value) => Navigator.of(context).pushNamed(item.routeName));
}

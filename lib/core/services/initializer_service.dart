import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/search_item.dart';
import 'package:ocean_builder/core/services/locator.dart';
import 'package:ocean_builder/core/services/navigation_service.dart';
import 'package:ocean_builder/ui/screens/accessManagement/grant_access_screen.dart';
import 'package:ocean_builder/ui/screens/weather/weather_more_widget.dart';
import 'package:ocean_builder/ui/screens/weather/weather_screen.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/shared/shared_pref_data.dart';
import 'package:path_provider/path_provider.dart';
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

class InitalizerService extends ChangeNotifier {
  static bool isInitialized = false;
  _serviceSingleton({Function onDoneInitializing}) {
    if (!isInitialized) {
      _initializeHive();
      _internetConncetionChecker();
      onDoneInitializing();
      isInitialized = true;
    }
  }

  Future<void> init(Function onDoneInitializing) async {
    // //hive
    // _initializeHive();

    // // internet conncetion checker
    // _internetConncetionChecker();
    // onDoneInitializing();

    _serviceSingleton(onDoneInitializing: onDoneInitializing);
  }

  void _internetConncetionChecker() {
    GlobalListeners.listener =
        DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available. --- from service');
          if (GlobalContext.internetStatus != null &&
              !GlobalContext.internetStatus) {
            displayInternetInfoBar(
                locator<NavigationService>().navigatorKey.currentContext,
                AppStrings.internetConnection);
            GlobalContext.internetStatus = true;
          }
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet. --- from service');
          displayInternetInfoBar(
              locator<NavigationService>().navigatorKey.currentContext,
              AppStrings.noInternetConnection);
          GlobalContext.internetStatus = false;
          break;
      }
    });
  }

  Future<void> _initializeHive() async {
    Directory dir = await getExternalStorageDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(SearchItemAdapter());
    var _box_serachItems = await Hive.openBox<SearchItem>('searchItems');
    var _box_serachHistory = await Hive.openBox<String>('searchHistory');
    // var _box_selectedHistory = await Hive.openBox('selectedHistory');
    bool installStatus = await SharedPrefHelper.getFirstInstallStatus();
    if (installStatus) {
      _box_serachItems.addAll(_appItems);
      print(_box_serachItems.values.length);
      GlobalContext.appItems.addAll(_appItems);
    } else {
      for (var i = 0; i < _box_serachItems.length; i++) {
        SearchItem s = _box_serachItems.getAt(i);
        print(s.name);
        GlobalContext.appItems.add(s);
      }
    }

    GlobalContext.searchItems.clear();
    for (var i = 0; i < _box_serachHistory.length; i++) {
      String s = _box_serachHistory.getAt(i);
      print(s);
      GlobalContext.searchItems.add(s);
    }

    // GlobalContext.selectedItems.clear();
    // for (var i = 0; i < _box_selectedHistory.length; i++) {
    //   String s = _box_selectedHistory.getAt(i);
    //   print(s);
    //   GlobalContext.selectedItems.add(s);
    // }
  }

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
}

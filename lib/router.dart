import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ocean_builder/core/models/notification.dart';
import 'package:ocean_builder/core/models/ocean_builder_user.dart';
import 'package:ocean_builder/core/models/permission.dart';
import 'package:ocean_builder/search/appSearchScreen.dart';
import 'package:ocean_builder/map/darksky_map.dart';
import 'package:ocean_builder/splash/splash_screen.dart';
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
import 'package:ocean_builder/ui/screens/designSteps/smart_home_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/smart_home_screen_node_js.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';

const String initialRoute = SplashScreen.routeName;

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        // return CupertinoPageRoute(builder: (_) => SplashScreen());
        return PageTransition(
            type: PageTransitionType.fade, child: SplashScreen());
      case SmartHomeScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => SmartHomeScreen(),
            settings: RouteSettings(name: SmartHomeScreen.routeName));
      case SmartHomeScreenNodeServer.routeName:
        return CupertinoPageRoute(
            builder: (_) => SmartHomeScreenNodeServer(),
            settings: RouteSettings(name: SmartHomeScreenNodeServer.routeName));
      // case SwiperContainerScreen.routeName:
      //   return CupertinoPageRoute(
      //       builder: (_) => SwiperContainerScreen(),
      //       settings: RouteSettings(name: SwiperContainerScreen.routeName));
      case AppSearchScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => AppSearchScreen(),
            settings: RouteSettings(name: AppSearchScreen.routeName),
            fullscreenDialog: true);
      case LandingScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => LandingScreen(),
            settings: RouteSettings(name: LandingScreen.routeName));
      case HomeScreen.routeName:
        int currentIndex = settings.arguments;
        if (currentIndex == null) {
          currentIndex = 0;
        }
        return CupertinoPageRoute(
            builder: (_) => HomeScreen(
                  swiperIndex: currentIndex,
                ),
            settings: RouteSettings(name: HomeScreen.routeName));
      case LoginScreen.routeName:
        final String sourceScreen = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => LoginScreen(sourceScreen: sourceScreen),
            settings: RouteSettings(name: LoginScreen.routeName));
      case AccessManagementScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => AccessManagementScreen(),
            settings: RouteSettings(name: AccessManagementScreen.routeName));
      case NotificationHistoryScreen.routeName:
        final bool showOnlyAccessRequest = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => NotificationHistoryScreen(
                  showOnlyAccessRequests: showOnlyAccessRequest,
                ),
            settings: RouteSettings(name: NotificationHistoryScreen.routeName));
      case NotificationHistoryScreenWidget.routeName:
        return CupertinoPageRoute(
            builder: (_) => NotificationHistoryScreenWidget(),
            settings:
                RouteSettings(name: NotificationHistoryScreenWidget.routeName));
      case SettingsWidget.routeName:
        return CupertinoPageRoute(
            builder: (_) => SettingsWidget(),
            settings: RouteSettings(name: SettingsWidget.routeName));
      case ControlScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => ControlScreen(),
            settings: RouteSettings(name: ControlScreen.routeName));
      case LightingScreen.routeName:
        final LightingScreenParams lightingScreenParams = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => LightingScreen(
                  oceanBuilderUser: lightingScreenParams.obUser,
                  userProvider: lightingScreenParams.userProvider,
                  selectedOBIdProvider:
                      lightingScreenParams.selectedOBIdProvider,
                  selectedLightSceneIdFromPopup:
                      lightingScreenParams.selectedSceneId,
                ),
            settings: RouteSettings(name: LightingScreen.routeName));
      case LightingSceneListScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => LightingSceneListScreen(),
            settings: RouteSettings(name: LightingSceneListScreen.routeName));
      case MarineScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => MarineScreen(),
            settings: RouteSettings(name: MarineScreen.routeName));
      case WeatherScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => WeatherScreen(),
            settings: RouteSettings(name: WeatherScreen.routeName));
      case WeatherMoreWidget.routeName:
        return CupertinoPageRoute(
            builder: (_) => WeatherMoreWidget(),
            settings: RouteSettings(name: MarineScreen.routeName));
      case CameraScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => CameraScreen(),
            settings: RouteSettings(name: CameraScreen.routeName));
      case QRcodeScreen.routeName:
        final String invokedFromScreen = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => QRcodeScreen(inVokedFrom: invokedFromScreen),
            settings: RouteSettings(name: QRcodeScreen.routeName));
      case RegistrationScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => RegistrationScreen(),
            settings: RouteSettings(name: RegistrationScreen.routeName));
      case DesignScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => DesignScreen(),
            settings: RouteSettings(name: DesignScreen.routeName));
      case ExteriorFinishScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => ExteriorFinishScreen(),
            settings: RouteSettings(name: ExteriorFinishScreen.routeName));
      case ExteriorColorScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => ExteriorColorScreen(),
            settings: RouteSettings(name: ExteriorColorScreen.routeName));
      case SparFinishingScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => SparFinishingScreen(),
            settings: RouteSettings(name: SparFinishingScreen.routeName));
      case SparDesignScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => SparDesignScreen(),
            settings: RouteSettings(name: SparDesignScreen.routeName));
      case DeckEnclosureScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => DeckEnclosureScreen(),
            settings: RouteSettings(name: DeckEnclosureScreen.routeName));
      case BedroomLivingroomEnclosureScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => BedroomLivingroomEnclosureScreen(),
            settings: RouteSettings(
                name: BedroomLivingroomEnclosureScreen.routeName));
      case PowerScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => PowerScreen(),
            settings: RouteSettings(name: PowerScreen.routeName));
      case UnderwaterRoomFinishingScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => UnderwaterRoomFinishingScreen(),
            settings:
                RouteSettings(name: UnderwaterRoomFinishingScreen.routeName));
      case UnderwaterWindowsScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => UnderwaterWindowsScreen(),
            settings: RouteSettings(name: UnderwaterWindowsScreen.routeName));
      case SoundSystemScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => SoundSystemScreen(),
            settings: RouteSettings(name: SoundSystemScreen.routeName));
      case MasterBedroomFloorFinishingScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => MasterBedroomFloorFinishingScreen(),
            settings: RouteSettings(name: MarineScreen.routeName));
      case LivingRoomFloorFinishingScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => LivingRoomFloorFinishingScreen(),
            settings:
                RouteSettings(name: LivingRoomFloorFinishingScreen.routeName));
      case KitchenFloorFinishingScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => KitchenFloorFinishingScreen(),
            settings:
                RouteSettings(name: KitchenFloorFinishingScreen.routeName));
      case WeatherStationScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => WeatherStationScreen(),
            settings: RouteSettings(name: WeatherStationScreen.routeName));
      case EntryStairsScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => EntryStairsScreen(),
            settings: RouteSettings(name: MarineScreen.routeName));
      case FathometerScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => FathometerScreen(),
            settings: RouteSettings(name: FathometerScreen.routeName));
      case CleanWaterLevelIndicatorScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => CleanWaterLevelIndicatorScreen(),
            settings:
                RouteSettings(name: CleanWaterLevelIndicatorScreen.routeName));
      case InteriorLivingRoomWallColorScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => InteriorLivingRoomWallColorScreen(),
            settings: RouteSettings(
                name: InteriorLivingRoomWallColorScreen.routeName));
      case InteriorMasterBedRoomWallColorScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => InteriorMasterBedRoomWallColorScreen(),
            settings: RouteSettings(
                name: InteriorMasterBedRoomWallColorScreen.routeName));
      case InteriorKitchenWallColorScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => InteriorKitchenWallColorScreen(),
            settings:
                RouteSettings(name: InteriorKitchenWallColorScreen.routeName));
      case InteriorBedRoomWallColorScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => InteriorBedRoomWallColorScreen(),
            settings:
                RouteSettings(name: InteriorBedRoomWallColorScreen.routeName));
      case DeckFloorFinishMaterialsScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => DeckFloorFinishMaterialsScreen(),
            settings:
                RouteSettings(name: DeckFloorFinishMaterialsScreen.routeName));
      case YourInfoScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => YourInfoScreen(),
            settings: RouteSettings(name: YourInfoScreen.routeName));
      case EmailVerificationScreen.routeName:
        final EmailVerificationData data = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => EmailVerificationScreen(
                  emailVerificationData: data,
                ),
            fullscreenDialog: true,
            settings: RouteSettings(name: EmailVerificationScreen.routeName));
      case OBSelectionScreenWidgetModal.routeName:
        return CupertinoPageRoute(
            builder: (_) => OBSelectionScreenWidgetModal(),
            settings:
                RouteSettings(name: OBSelectionScreenWidgetModal.routeName));
      case OBEventScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => OBEventScreen(),
            settings: RouteSettings(name: OBEventScreen.routeName));
      case ProfileScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => ProfileScreen(),
            settings: RouteSettings(name: ProfileScreen.routeName));
      case OBAccessReqEventScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => OBAccessReqEventScreen(),
            settings: RouteSettings(name: OBAccessReqEventScreen.routeName));
      // case RadarMap.routeName:
      //   return CupertinoPageRoute(
      //       builder: (_) => RadarMap(),
      //       settings: RouteSettings(name: RadarMap.routeName));
      case PasswordScreen.routeName:
        final bool newUser = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => PasswordScreen(isNewUser: newUser),
            settings: RouteSettings(name: PasswordScreen.routeName));
      case InvitationResponseScreen.routeName:
        final AccessEvent accessInvitation = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => InvitationResponseScreen(
                  accessInvitation: accessInvitation,
                ),
            settings: RouteSettings(name: InvitationResponseScreen.routeName));
      case GuestRequestResponseScreen.routeName:
        final AccessEvent accessRequest = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => GuestRequestResponseScreen(
                  accessRequest: accessRequest,
                ),
            settings:
                RouteSettings(name: GuestRequestResponseScreen.routeName));
      case RequestAccessScreen.routeName:
        final String scannedQrCode = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => RequestAccessScreen(qrCode: scannedQrCode),
            settings: RouteSettings(name: RequestAccessScreen.routeName));
      case YourObsScreen.routeName:
        final FcmNotification fcmNotificationData = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => YourObsScreen(
                  fcmNotification: fcmNotificationData,
                ),
            settings: RouteSettings(name: YourObsScreen.routeName));
      case RegistrationScreenAcceptInvitation.routeName:
        return CupertinoPageRoute(
            builder: (_) => RegistrationScreenAcceptInvitation(),
            settings: RouteSettings(
                name: RegistrationScreenAcceptInvitation.routeName));
      case AcceptInvitationScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => AcceptInvitationScreen(),
            settings: RouteSettings(name: AcceptInvitationScreen.routeName));
      case WebViewDarksky.routeName:
        return CupertinoPageRoute(
            builder: (_) => WebViewDarksky(),
            settings: RouteSettings(name: WebViewDarksky.routeName));
      case EarthStationScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => EarthStationScreen(),
            settings: RouteSettings(name: EarthStationScreen.routeName));
      case NotificationSettingsWidget.routeName:
        return CupertinoPageRoute(
            builder: (_) => NotificationSettingsWidget(),
            settings:
                RouteSettings(name: NotificationSettingsWidget.routeName));
      case ForgotPasswordScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => ForgotPasswordScreen(),
            settings: RouteSettings(name: ForgotPasswordScreen.routeName));
      case GuestAccessScreen.routeName:
        final OceanBuilderUser oceanBuilderUser = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => GuestAccessScreen(
                  oceanBuilderUser: oceanBuilderUser,
                ),
            settings: RouteSettings(name: GuestAccessScreen.routeName));
      case AdminAccessScreen.routeName:
        final OceanBuilderUser oceanBuilderUser = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => AdminAccessScreen(
                  oceanBuilderUser: oceanBuilderUser,
                ),
            settings: RouteSettings(name: AdminAccessScreen.routeName));
      case VisitorAccessScreen.routeName:
        final OceanBuilderUser oceanBuilderUser = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => VisitorAccessScreen(
                  oceanBuilderUser: oceanBuilderUser,
                ),
            settings: RouteSettings(name: VisitorAccessScreen.routeName));
      case ManagePermissionScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => ManagePermissionScreen(),
            settings: RouteSettings(name: ManagePermissionScreen.routeName));
      case CreatePermissionScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => CreatePermissionScreen(),
            settings: RouteSettings(name: CreatePermissionScreen.routeName));
      case EditPermissionScreen.routeName:
        final PermissionSet permissionSet = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => EditPermissionScreen(permissionSet: permissionSet),
            settings: RouteSettings(name: EditPermissionScreen.routeName));
      case CustomPermissionScreen.routeName:
        final PermissionSet permissionSet = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) =>
                CustomPermissionScreen(permissionSet: permissionSet),
            settings: RouteSettings(name: CustomPermissionScreen.routeName));
      case AccessEventScreen.routeName:
        AccessEventsScreenParams accessEventsScreenParams = settings.arguments;
        return CupertinoPageRoute(
            builder: (_) => AccessEventScreen(
                  accessType: accessEventsScreenParams.accessType,
                  accessEvents: accessEventsScreenParams.accessEvents,
                ),
            settings: RouteSettings(name: AccessEventScreen.routeName));
      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}

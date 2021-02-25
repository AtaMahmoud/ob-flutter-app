import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ocean_builder/core/models/lighting.dart';
import 'package:ocean_builder/core/models/ocean_builder_user.dart';
import 'package:ocean_builder/core/models/permission.dart';
import 'package:ocean_builder/core/models/permission.dart';
import 'package:ocean_builder/core/models/permission.dart';
import 'package:ocean_builder/core/models/search_item.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';

class ColorConstants {
  static const CONTROL_ARC = Color(0xFF0C3A70);
  static const CONTROL_ARC_BKG_START = Color(0xFF05649B);
  static const CONTROL_ARC_BKG_END = Color(0xFF068ACD);
  static const WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT = Color(0xFF84A4D3);
  static Color WEATHER_MORE_DAY_INFO_TEXT_COLOR_LIGHT =
      Color(0xFF0A49A7).withOpacity(0.5);
  static const WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY = Color(0xFF0A49A7);
  static const WEATHER_MORE_ICON_COLOR = Color(0xFF144498);
  static const TEMP_BY_HOUR_START = Color(0xFFB7C1D2);
  static Color TEMP_BY_HOUR_END = Color(0xFFB7C1D2).withOpacity(0);
  static const WEATHER_MORE_LIST_BKG = Color(0xFFE5E5E5);
  static const WEATHER_BKG_CIRCLE = Color(0xFF31549B);
  static const WEATHER_TEMP_CIRCLE = Color(0xFF305AAD);
  static const WEATHER_RAIN_CIRCLE = Color(0xFF638BC2);
  static const WEATHER_HUMIY_CIRCLE = Color(0xFF063577);
  static const SCALE_COLOR_LIGHT = Color(0xFFA3B9D6);
  static const SCALE_COLOR = Color(0xFF93B0D8);
  static const MARINE_ITEM_COLOR = Color(0xFF638BC2);
  static const MARINE_ITEM_TEXT_COLOR = Color(0xFF0D48A3);
  static const TOP_CLIPPER_END_DARK = Color(0xFF084AAA);
  static const TOP_CLIPPER_START_DARK = Color(0xFF184192);
  static const SVG_ICON_COLOR = Color(0xFF3363A3);

  static const CONTROL_LIST_ITEM_BKG = Color(0xFF0590D3);
  static const CONTROL_LIST_BKG = Color(0xFF165AB7);
  static const CONTROL_BKG = Color(0xFF519BB3);
  static const CONTROL_END = Color(0xFF2DEE8FC);
  static const CONTROL_START = Color(0xFFFFFFFF);
  static const CONTROL_WHEEL_TEXT = Color(0xFF08619D);

  static const TOP_CLIPPER_END = Color(0xFF2C86AC);
  static const TOP_CLIPPER_START = Color(0xFF01388B);
  static const BOTTOM_CLIPPER_START = Color(0xFF01388B);
  static const BOTTOM_CLIPPER_END = Color(0xFF2C86AC);
  static const CLIPPER_BACKGROUND = Color(0xFFE4EDF3);
  static const TEXT_COLOR = Color(0XFF1B689F);
  static const BCKG_COLOR_START = Color(0XFFE4EDF3);
  static const BCKG_COLOR_END = Color(0XFFFFFFFF);
  static const PROFILE_BKG_1 = Color(0xFF2778D2);
  static const PROFILE_BKG_2 = Color(0xFF3784D9);
  static const INVALID_TEXTFIELD = Colors.blueGrey;
  static const LinearGradient BKG_GRADIENT = LinearGradient(
    colors: <Color>[BCKG_COLOR_START, BCKG_COLOR_END],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
  static const MODAL_BKG = Color(0xFF7F9EC8);
  static const MODAL_ICON_COLOR = Color(0xFF3363A3);
  static const SPLASH_BKG = Color(0xFF305FA1);
  static const underWaterOBColor = Color(0xFF042F68);

  // notification screen
  static const COLOR_NOTIFICATION_TITLE = Color(0xFF144498);
  static const COLOR_NOTIFICATION_NORMAL = Color(0xFF064390);
  static const COLOR_NOTIFICATION_URGENT = Color(0xFFCC3B3B);
  static const COLOR_NOTIFICATION_ITEM = Color(0xFF0A49A7);
  static const COLOR_NOTIFICATION_DIVIDER = Color(0xFF84A4D3);
  static Color COLOR_NOTIFICATION_BUBBLE = Color(0xFF064390).withOpacity(0.5);
  static Color COLOR_NOTIFICATION_SUB_ITEM = Color(0xFF0A49A7).withOpacity(0.5);

  // access management screen
  static const COLOR_PENDING_REQUEST = Color(0xFFEDF2FD);
  static const ACCESS_MANAGEMENT_TITLE = COLOR_NOTIFICATION_TITLE;
  static const ACCESS_MANAGEMENT_SUBTITLE = Color(0xFF83A6D8);
  static const ACCESS_MANAGEMENT_HINT = Color(0xFF2D68BF);
  static const ACCESS_MANAGEMENT_INPUT_BORDER = Color(0xFF6B94D2);
  static const ACCESS_MANAGEMENT_DIVIDER = COLOR_NOTIFICATION_ITEM;
  static const ACCESS_MANAGEMENT_BUTTON = Color(0xFF2D68BF);
  static const ACCESS_MANAGEMENT_LIST_TITLE = Color(0xFF305AAD);

  static const CAMERA_TITLE = Color(0xFF2D68BF);
  static const CAMERA_SLIDER_ITEM_BKG = Color(0xFFEDF2FD);
  static const CAMERA_SLIDER_MOVEMENT = Color(0xFF71DA36);
  static const CAMERA_SLIDER_ITEM = Color(0xFF698FBF);
  static const CAMERA_SLIDER_ITEM_SELECTED = Color(0xFFB2CCEC);
  static const CAMERA_ITEM_INACTIVE = Color(0xFFAEAEAE);

  static const LIGHT_GRAD_START = Color(0xFF29CA52);
  static const LIGHT_GRAD_MIDDLE = Color(0xFF18BBCA);
  static const LIGHT_GRAD_END = Color(0xFF8F3CE6);
  static const LIGHT_POPUP_TITLE = ACCESS_MANAGEMENT_HINT;
  static const LIGHT_POPUP_BKG = CAMERA_SLIDER_ITEM_BKG;
  static const LIGHT_POPUP_TEXT = Color(0xFF638BC2);
  static const LIGHT_INTENSITY_INACTIVE = Color(0xFF05669E);
  static const LIGHT_INTENSITY_ACTIVE = Color(0xFF0B3A6F);
  static const LIGHTING_CHIP_LABEL = Color(0xFF5282C9);
  static const LIGHTING_CHIP_BORDER = Color(0xFF9FBCE6);
  static const LIGHTING_HEXCODE = Color(0xFF2D68BF);
  static const LIGHTING_BOTTOM_CLIPER_BUTTON_BKG = Color(0xFF165AB7);
  static const LIGHTING_POP_UP_BKG = Color(0xFFEDF2FD);

  static const CREATE_PERMISSION_COLOR_BKG = Color(0xFFEDF2FD);

  // source pop up
  static const SOURCE_POPUP_BKG = Color(0xFFEDF2FD);

  static const AVATAR_BKG = Color(0xFFECF3F7);
}

class TextFieldHints {
  static const FIRST_NAME = 'FIRST NAME';
  static const LAST_NAME = 'LAST NAME';
  static const ENTER_EMAIL = 'EMAIL';
  static const PHONE = 'PHONE';
  static const ENTER_PASSWORD = 'PASSWORD';
  static const CONFIRM_PASSWORD = 'CONFIRM PASSWORD';
  static const VASSEL_CODE_OR_QR_CODE = 'VASSEL CODE / QR CODE';
  static const EMAIL = 'EMAIL';
  static const PASSWORD = 'PASSWORD';
  static const OCEAN_BUILDER_ACCESS = 'SEAPOD ACCESS';
  static const MY_EMERGENCY_CONTACT = 'MY EMERGENCY CONTACT';
  static const PROFILE_FIRST_NAME = 'FIRST NAME *';
  static const PROFILE_LAST_NAME = 'LAST NAME *';
  static const PROFILE_EMAIL = 'EMAIL *';
  static const NAME = 'Name*';
  static const EMAIL_ADDRESS = 'Email address*';

  static String CURRENT_PASSWORD = 'Current Password';

  static String NEW_PASSWORD = 'New Password';

  static String YOUR_SEAPOD_NAME = 'Your SeaPod Name';

  static String NAME_YOUR_SEAPOD = 'NAME YOUR SEAPOD';
}

class InputTypes {
  static const NUMBER =
      TextInputType.numberWithOptions(decimal: false, signed: false);
  static const EMAIL = TextInputType.emailAddress;

  static const PHONE = TextInputType.phone;
}

class InfoTexts {
  static const POLYUREA_COATING_INFO =
      '*A Polyurea Coating Will Help To Extend The Life Of Your Spar By Helping Prevent Rusting';
  static String YOUR_OB_INFO(String no) =>
      'You have $no SeaPod access request pending confirmation.\n\nPlease check back later';

  static String OB_ACCESS_REQ_PENDING = 'PENDING APPROVAL';
}

class ButtonText {
  static const LOGIN = 'LOGIN';
  static const LOGOUT = 'LOGOUT';
  static const REGISTER = 'REGISTER';
  static const REQUEST_ACCESS = 'REQUEST ACCESS';
  static const START_CUSTOMIZATION = 'START CUSTOMIZATION';
  static const BACK = 'BACK';
  static const NEXT = 'NEXT';
  static const SAVE = 'SAVE';
  static const SET_PASSWORD = 'SET PASSWORD';
  static const CHECKING = 'CHECKING';
  static const MAKE_DEPOSIT = 'MAKE DEPOSIT';
  static const SUBMIT_ORDER = 'SUBMIT ORDER';
  static const SHOW_MORE_COLORS = 'SHOW MORE COLORS';
  static const WITH_CAMERA = 'With Camera';
  static const FROM_GALLERY = 'From Gallery';
  static const APPROVE = 'APPROVE';
  static const DENY = 'DENY';
  static const CANCEL = 'CANCEL';
  static const CANCELLING = 'CANCELLING';
  static const NOTIFICATION_HISTORY = 'NOTIFICATION\nHISTORY';
  static const OB_ACCESS_REQUEST = 'OB ACCESS\nREQUESTS';
  static const MY_PROFILE = 'MY PROFILE';
  static const OCEAN_BUILDER_SELECTION = 'SEAPOD\nSELECTION';
  static const SEND_INVITATION = 'SEND INVITATION';
  static const SAVE_SCENE = 'SAVE SCENE';
  static const RENAME_DELETE_SCENE = 'RENAME / DELETE SCENE';
}

class ScreenTitle {
  static const LANDING_SCREEN = 'Landing Screen';
  static const HOME = 'Home';
  static const SMART_HOME = 'Smart Home';
  static const DASHBOARD = 'Dashboard';
  static const REGISTER = 'Register';
  static const LOGIN = 'Login';
  static const SET_PASSWORD = 'Set Password';
  static const FORGOT_PASSWORD = 'Forgot Password?';
  static const WELCOME = 'Welcome';
  static const QRCODE = 'Scan QR Code';
  static const DESIGN = 'Design';
  static const EXTERIOR_FINISH = 'Exterior Finish';
  static const EXTERIOR_COLOR = 'Exterior Color';
  static const SPAR_FINISHING = 'Spar Finishing';
  static const SPAR_DESIGN = 'Spar Design';
  static const DECK_ENCLOSURE = 'Deck Enclosure';
  static const BEDROOM_PLUS_LIVING_ROOM_ENCLOSURE =
      'Bedroom + Living Room Enclosure';
  static const POWER = 'Power';
  static const UNDERWATER_ROOM_FINISHING = 'Underwater Room Finishing';
  static const UNDERWATER_WINDOWS = 'Underwater Windows';
  static const SOUND_SYSTEM = 'Sound System';
  static const MASTER_BEDROOM_FLOOR_FINISHING =
      'Master Bedroom Floor Finishing';
  static const LIVING_ROOM_FLOOR_FINISHING = 'Living Room Floor Finishing';
  static const KITCHEN_FLOOR_FINISHING = 'Kitchen Floor Finishing';
  static const WEATHER_STATION = 'Weather Station';
  static const WEATHER = 'Weather';
  static const MARINE = 'Marine';
  static const CONTROLS = 'Controls';
  static const STEERING = 'Steering';
  static const ENTRY_STAIRS = 'Entry Stairs';
  static const FATHOMETER = 'Fathometer';
  static const CLEAN_WATER_LEVEL_INDICATOR = 'Clean Water Level Indicator';
  static const INTERIOR_LIVING_ROOM_WALL_COLOR =
      'Interior Living Room Wall Color';
  static const INTERIOR_MASTER_BEDROOM_WALL_COLOR =
      'Interior Master Bedroom Wall Color';
  static const INTERIOR_KITCHEN_WALL_COLOR = 'Interior Kitchen Wall Color';
  static const INTERIOR_BEDROOM_WALL_COLOR = 'Interior Bedroom Wall Color';
  static const DECK_FLOOR_FINISH_MATERIALS = 'Deck Floor Finish Materials';
  static const MAKE_A_DEPOSIT = 'Make a deposit';
  static const YOUR_INFO = 'Your info';
  static const EMAIL_CONFIRMATION = 'Email Confirmation';
  static const GUEST_REQUEST = 'Guest Request';
  static const INVITATION_REQUEST = 'Access Invitation';
  static const YOUR_OBS = 'Your SeaPods';
  static const REQUEST_ACCESS = 'Request Access';
  static const OB_SELECTION = 'SeaPod Selection';
  static const OB_EVENTS = 'SeaPod Events';
  static const OB_ACCESS_REQUESTS = 'SeaPod Access Requests';
  static const OB_PENDING_REQUESTS = 'Pending Requests';
  static const ACCESS_MANAGEMENT = 'Access Management';

  static String HOME_ACCESS_INVITATION = 'Home Access Invitation';

  static String ACCEPT_INVITATION = 'Accept Invitation';

  static String CREATE_ACCOUNT = 'Create Account';

  static String ADMINISTRATION_ACCESS = 'Administration Access';
  static String Guest_ACCESS = 'Guest Access';
  static String VISITOR_ACCESS = 'Visitor Access';
  static String MANAGE_PERMISSIONS = 'Manage Permissions';
  static String CREATE_PERMISSION = 'Create New';
  static String EDIT_PERMISSION = 'Edit Permissions';
  static String CUSTOMIZE_PERMISSION = 'Customize Permissions';
}

class ListHelper {
  static const oneDollar = '+ \$';
  static const twoDollar = '+ \$\$';
  static const threeDollar = '+ \$\$\$';
  static const fourDollar = '+ \$\$\$\$';
  static const int dayInHours = 24;

  static List<String> getCountryList() => [
        'Afghanistan',
        'Ã…land Islands',
        'Albania',
        'Algeria',
        'American Samoa',
        'Andorra',
        'Angola',
        'Anguilla',
        'Antarctica',
        'Antigua and Barbuda',
        'Argentina',
        'Armenia',
        'Aruba',
        'Australia',
        'Austria',
        'Azerbaijan',
        'Bahamas',
        'Bahrain',
        'Bangladesh',
        'Barbados',
        'Belarus',
        'Belgium',
        'Belize',
        'Benin',
        'Bermuda',
        'Bhutan',
        'Bolivia, Plurinational State of',
        'Bonaire, Sint Eustatius and Saba',
        'Bosnia and Herzegovina',
        'Botswana',
        'Bouvet Island',
        'Brazil',
        'British Indian Ocean Territory',
        'Brunei Darussalam',
        'Bulgaria',
        'Burkina Faso',
        'Burundi',
        'Cambodia',
        'Cameroon',
        'Canada',
        'Cape Verde',
        'Cayman Islands',
        'Central African Republic',
        'Chad',
        'Chile',
        'China',
        'Christmas Island',
        'Cocos (Keeling) Islands',
        'Colombia',
        'Comoros',
        'Congo',
        'Congo, the Democratic Republic of the',
        'Cook Islands',
        'Costa Rica',
        'CÃ´te d\'Ivoire',
        'Croatia',
        'Cuba',
        'CuraÃ§ao',
        'Cyprus',
        'Czech Republic',
        'Denmark',
        'Djibouti',
        'Dominica',
        'Dominican Republic',
        'Ecuador',
        'Egypt',
        'El Salvador',
        'Equatorial Guinea',
        'Eritrea',
        'Estonia',
        'Ethiopia',
        'Falkland Islands (Malvinas)',
        'Faroe Islands',
        'Fiji',
        'Finland',
        'France',
        'French Guiana',
        'French Polynesia',
        'French Southern Territories',
        'Gabon',
        'Gambia',
        'Georgia',
        'Germany',
        'Ghana',
        'Gibraltar',
        'Greece',
        'Greenland',
        'Grenada',
        'Guadeloupe',
        'Guam',
        'Guatemala',
        'Guernsey',
        'Guinea',
        'Guinea-Bissau',
        'Guyana',
        'Haiti',
        'Heard Island and McDonald Islands',
        'Holy See (Vatican City State)',
        'Honduras',
        'Hong Kong',
        'Hungary',
        'Iceland',
        'India',
        'Indonesia',
        'Iran, Islamic Republic of',
        'Iraq',
        'Ireland',
        'Isle of Man',
        'Israel',
        'Italy',
        'Jamaica',
        'Japan',
        'Jersey',
        'Jordan',
        'Kazakhstan',
        'Kenya',
        'Kiribati',
        'Korea, Democratic People\'s Republic of',
        'Korea, Republic of',
        'Kuwait',
        'Kyrgyzstan',
        'Lao People\'s Democratic Republic',
        'Latvia',
        'Lebanon',
        'Lesotho',
        'Liberia',
        'Libya',
        'Liechtenstein',
        'Lithuania',
        'Luxembourg',
        'Macao',
        'Macedonia, the Former Yugoslav Republic of',
        'Madagascar',
        'Malawi',
        'Malaysia',
        'Maldives',
        'Mali',
        'Malta',
        'Marshall Islands',
        'Martinique',
        'Mauritania',
        'Mauritius',
        'Mayotte',
        'Mexico',
        'Micronesia, Federated States of',
        'Moldova, Republic of',
        'Monaco',
        'Mongolia',
        'Montenegro',
        'Montserrat',
        'Morocco',
        'Mozambique',
        'Myanmar',
        'Namibia',
        'Nauru',
        'Nepal',
        'Netherlands',
        'New Caledonia',
        'New Zealand',
        'Nicaragua',
        'Niger',
        'Nigeria',
        'Niue',
        'Norfolk Island',
        'Northern Mariana Islands',
        'Norway',
        'Oman',
        'Pakistan',
        'Palau',
        'Palestine, State of',
        'Panama',
        'Papua New Guinea',
        'Paraguay',
        'Peru',
        'Philippines',
        'Pitcairn',
        'Poland',
        'Portugal',
        'Puerto Rico',
        'Qatar',
        'RÃ©union',
        'Romania',
        'Russian Federation',
        'Rwanda',
        'Saint BarthÃ©lemy',
        'Saint Helena, Ascension and Tristan da Cunha',
        'Saint Kitts and Nevis',
        'Saint Lucia',
        'Saint Martin (French part)',
        'Saint Pierre and Miquelon',
        'Saint Vincent and the Grenadines',
        'Samoa',
        'San Marino',
        'Sao Tome and Principe',
        'Saudi Arabia',
        'Senegal',
        'Serbia',
        'Seychelles',
        'Sierra Leone',
        'Singapore',
        'Sint Maarten (Dutch part)',
        'Slovakia',
        'Slovenia',
        'Solomon Islands',
        'Somalia',
        'South Africa',
        'South Georgia and the South Sandwich Islands',
        'South Sudan',
        'Spain',
        'Sri Lanka',
        'Sudan',
        'Suriname',
        'Svalbard and Jan Mayen',
        'Swaziland',
        'Sweden',
        'Switzerland',
        'Syrian Arab Republic',
        'Taiwan, Province of China',
        'Tajikistan',
        'Tanzania, United Republic of',
        'Thailand',
        'Timor-Leste',
        'Togo',
        'Tokelau',
        'Tonga',
        'Trinidad and Tobago',
        'Tunisia',
        'Turkey',
        'Turkmenistan',
        'Turks and Caicos Islands',
        'Tuvalu',
        'Uganda',
        'Ukraine',
        'United Arab Emirates',
        'United Kingdom',
        'United States',
        'United States Minor Outlying Islands',
        'Uruguay',
        'Uzbekistan',
        'Vanuatu',
        'Venezuela, Bolivarian Republic of',
        'Viet Nam',
        'Virgin Islands, British',
        'Virgin Islands, U.S.',
        'Wallis and Futuna',
        'Western Sahara',
        'Yemen',
        'Zambia',
        'Zimbabwe'
      ];

  //  [Default GUEST Permissions, Default MEMBER Permissions, Default VISITOR Permissions, Default ADMIN Permissions, Default OWNER Permissions]

  static List<String> getPermissionList() => [
        'Default ADMIN Permissions',
        'Default OWNER Permissions',
        'Default VISITOR Permissions',
        'Default GUEST Permissions',
        'Default MEMBER Permissions',
        'Restricted Bedroom & Kitchen'
      ];

  static List<String> getAccessAsList() =>
      ['REQUEST ACCESS AS...', 'MEMBER', 'GUEST', 'VISITOR'];

  static List<String> getGrantAccessAsList() => [
        'GRANT ACCESS AS...',
        'SHORT VISIT (VISITOR ACCESS)',
        'STAY (GUEST ACCESS)',
        'MOVE IN PERMANENTLY (MEMBER)'
      ];

  static List<String> getAccessTimeList() => [
        'REQUEST ACCESS FOR...',
        '1 DAY',
        '3 DAYS',
        '7 DAYS',
        '15 DAYS',
        '1 MONTH',
        '3 MONTHS',
        '6 MONTHS',
        '1 YEAR',
        'PERMANENT ACCESS',
      ];

  static List<String> getAccessForList() => [
        'REQUEST ACCESS FOR...',
        'SHORT VISIT (VISITOR ACCESS)',
        'STAY (GUEST ACCESS)',
        'MOVE IN PERMANENTLY (MEMBER ACCESS)'
      ];

  static List<String> getStayForTimeList() => [
        'STAY FOR...',
        '1 DAY',
        '3 DAYS',
        '7 DAYS',
        '15 DAYS',
        '1 MONTH',
        '3 MONTHS',
        '6 MONTHS',
        '1 YEAR'
      ];

  static List<String> getGrantAccessTimeList() => [
        'GRANT ACCESS FOR...',
        '1 DAY',
        '3 DAYS',
        '7 DAYS',
        '15 DAYS',
        '1 MONTH',
        '3 MONTHS',
        '6 MONTHS',
        '1 YEAR',
        'PERMANENT ACCESS',
      ];

  static Map<String, dynamic> getAccessTimeMap() => {
        getAccessTimeList()[1]: Duration(hours: dayInHours),
        getAccessTimeList()[2]: Duration(hours: dayInHours * 3),
        getAccessTimeList()[3]: Duration(hours: dayInHours * 7),
        getAccessTimeList()[4]: Duration(hours: dayInHours * 15),
        getAccessTimeList()[5]: Duration(hours: dayInHours * 30),
        getAccessTimeList()[6]: Duration(hours: dayInHours * 90),
        getAccessTimeList()[7]: Duration(hours: dayInHours * 180),
        getAccessTimeList()[8]: Duration(hours: dayInHours * 360),
        getAccessTimeList()[9]: Duration(hours: dayInHours * 360 * 5),
      };

  static List<String> getExteriorFinishList() => ['Matt', 'Gloss'];

  static List<String> getExteriorFinishPriceList() => ['', '\n($threeDollar)'];

  static List<String> getExteriorColorList() =>
      ['Ivory White', 'Select\nFrom Pallet\n($threeDollar)'];

  static List<String> getSparFinishingColorList() =>
      ['Black Stainless Steel', 'Color\nPolyurea*\nFinish\n($threeDollar)'];

  static List<String> getSparDesignList() =>
      ['None', 'Single Light Strip', 'Triple Light Strip'];

  static List<String> getSparDesignPricingList() =>
      ['', twoDollar, threeDollar];

  static List<String> getDeckEnclosureList() => [
        'None',
        'Canvas',
        'Metel Roller Blinds',
        'Flat Glass Panes',
        'Flat Smart Color Tinting Windows*',
        'Curved FlexiGLass'
      ];

  static List<String> getDeckEnclosurePricingList() =>
      ['', twoDollar, threeDollar, threeDollar, fourDollar, oneDollar];

  static List<String> getBedroomLivingRoomEnclosureList() => [
        'None',
        'Curved FlexiGlass',
        'Canvas',
        'Metel Roller Blinds',
        'Flast Glass Panes',
        'Flat Smart Color Tinting Windows'
      ];

  static List<String> getBedroomLivingRoomEnclosurePricingList() =>
      ['', oneDollar, twoDollar, threeDollar, threeDollar, fourDollar];

  static List<String> getPowerRbList() =>
      ['1000 Kw Solar Cells On Rack', 'Additional Solar Cells', 'Solar Skin'];

  static List<String> getPowerRbPricingList() => ['', twoDollar, threeDollar];

  static List<String> getPowerCbList() =>
      ['Solar Battery Charge Level Indicator', 'Battery Health Meter'];

  static List<String> getPowerCbPricingList() => [threeDollar, fourDollar];

  static List<String> getUnderwaterRoomFinishingList() => [
        'Unfinished',
        'Contoured Design',
        'Other-Something Simple',
        'Greenhouse'
      ];

  static List<String> getUnderwaterRoomFinishPricingList() =>
      ['', threeDollar, threeDollar, fourDollar];

  static List<String> getSoundSystemList() =>
      ['Upper Platform', 'Underwater Room'];

  static List<String> getSoundSystemPricingList() => [threeDollar, threeDollar];

  static List<String> getUnderwaterWindowsList() => [
        '1 Port Window',
        '2 Port Window',
        '3 Port Window',
        '360 VR',
        '360 Curved Glass'
      ];

  static List<String> getUnderWaterWindowsPricingList() =>
      ['', '', '', threeDollar, fourDollar];

  static List<String> getFloorFinishingColorList() => [
        'Carbon Fiber',
        'Tile',
        'Wood',
      ];

  static List<String> getFloorFinishingColorPricingList() =>
      ['', threeDollar, fourDollar];

  static List<String> getWeatherStationList() => [' '];

  static List<String> getWeatherStationPricingList() => [threeDollar];

  static List<String> getEntryStairsList() => [
        'Fixed Position',
        'Motorized Fold Away Entry Stairs',
      ];

  static List<String> getlightSceneList() => [
        'NIGHT MODE',
        'DAY MODE',
        'ENTERTAINMENT',
        'NEW SCENE',
        'RAINY DAY SCENE',
      ];
  static List<String> getRoomNameList() => [
        'BEDROOM',
        'LIVING ROOM',
        'KITCHEN',
        'UNDERAWATER ROOM',
      ];

  static List<String> getSourceList() => ['EXTERNAL SOURCE', 'LOCAL SOURCE'];

  static List<String> getLightList() =>
      ["Lightstrip 1", "Lightstrip 2", "Light 3", "Counter 4", "Overhead 3"];

  static List<String> getEntryStairsPricingList() => ['', threeDollar];

  static List<String> getFathometerList() => [' '];

  static List<String> getFathometerPricingList() => [threeDollar];

  static List<String> getCleanWaterLevelIndicatorList() => [' '];

  static List<String> getCleanWaterLevelIndicatorPricingList() => [threeDollar];

  static List<String> getWallColorList() => ['White', 'Custom'];

  static List<String> getWallColorPricingList() => ['', threeDollar];

  static List<String> getWallColorSubtitle() => [null, 'Select From Palate'];

  static List<String> getDeckFloorFinishMaterialList() =>
      ['Carbon Fiber', 'Tile', 'Wood', 'Custom'];

  static List<String> getFloorFinishing() => ['Carbon Fiber', 'Tile', 'Wood'];

  static List<String> getFloorFinishPricing() => ['', threeDollar, threeDollar];

  static List<String> getFloorFinishSubTitle() => [
        null,
        'Select from 50 Different Styles',
        'Select from 10 Different Styles'
      ];

  static getFathometerSubtitle() =>
      'This Meter Shows You How Deep The Water You Are In Is And You Will Receive Notifications If You Are In Too Shallow Water';

  static getCleanWaterLevelIndicatorSubtitle() =>
      'Check Your Water Level And Get Notifications When Your Water Level Is Getting Low';

  static List<String> getDeckFloorFinishMaterialPricingList() =>
      ['', oneDollar, twoDollar, threeDollar];

  static List<int> colorList() => [
        0xFF768EA1,
        0xFFE1E1E2,
        0xFF5F8CA3,
        0xFF3F6CA4,
        0xFF768EA5,
        0xFFE1E1E6,
        0xFF5F8CA7,
        0xFF3F6CA8,
        0xFF768EB1,
        0xFFE1E1F2,
        0xFF5F8CB3,
        0xFF3F6CB4,
        0xFF768FA1,
        0xFFE1E2E2,
        0xFF5F8DA3,
        0xFF3F6DA4,
        0xFF768CA1,
        0xFFE1F1E2,
        0xFF5F9CA3,
        0xFF3F7CA4,
        0xFF758EA1,
        0xFFE2E1E2,
        0xFF5E8CA3,
        0xFF3E6CA4,
        0xFF778EA1,
        0xFFF1E1E2,
        0xFF6F8CA3,
        0xFF4F6CA4,
        0xFF668EA1,
        0xFFD1E1E2,
        0xFF4F8CA3,
        0xFF2F6CA4,
        0xFF756EA1,
        0xFFE0E1E2,
        0xFF5D8CA3,
        0xFF3D6CA4,
        0xFF767EA1,
        0xFFE1D1E2,
        0xFF5F7CA3,
        0xFF3F5CA4,
        0xFF768DA1,
        0xFFE1E0E2,
        0xFF5F8BA3,
        0xFF3F6BA4,
        0xFF768E91,
        0xFFE1E1D2,
        0xFF5F8C93,
        0xFF3F6C94,
        0xFF768EA0,
        0xFFE1E1E1
      ];

  static List<String> getFakeNames() => [
        'Blue Sky',
        'Blue Ocean',
        'Blue Sunset',
        'Blue Waves',
        'Blue Sea',
        'Blue Summer',
        'Blue Life',
        'Blue Nature',
        'Blue Nautical',
        'Blue Maritime',
        'Blue Dreamer',
        'Red Sky',
        'Red Ocean',
        'Red Sunset',
        'Red Waves',
        'Red Sea',
        'Red Summer',
        'Red Life',
        'Red Nature',
        'Red Nautical',
        'Red Maritime',
        'Red Dreamer',
        'Dark Sky',
        'Dark Ocean',
        'Dark Sunset',
        'Dark Waves',
        'Dark Sea',
        'Dark Summer',
        'Dark Life',
        'Dark Nature',
        'Dark Nautical',
        'Dark Maritime',
        'Dark Dreamer',
        'Night Sky',
        'Night Ocean',
        'Night Sunset',
        'Night Waves',
        'Night Sea',
        'Night Summer',
        'Night Life',
        'Night Nature',
        'Night Nautical',
        'Night Maritime',
        'Night Dreamer',
        'Wild Sky',
        'Wild Ocean',
        'Wild Sunset',
        'Wild Waves',
        'Wild Sea',
        'Wild Summer',
        'Wild Life',
        'Wild Nature',
        'Wild Nautical',
        'Wild Maritime',
        'Wild Dreamer',
        'Sea Breeze',
        'Second Wind',
        'Ocean Bliss',
        'Blue Moon',
        'Aqua Vita',
        'Chasing Daylight',
        'The Serenity',
        'Float house',
        'Blue Heaven',
        'Grand Bahama'
      ];
  static String getRandomName() {
    Random rand = Random();
    int index = rand.nextInt(64);

    return getFakeNames()[index];
  }
}

class Fonts {
  static String fontVarela = 'Varela';
}

class ImagePaths {
  static String defaultIcon = 'images/default_icon.png';
  static String qrCodeImage = 'images/phone.png';
  static String deckImage = 'images/icon_large.png';
  static String containerBackgroundImage = 'images/container_background.png';
  static String barcodeImage = 'images/barcode.svg';
  static String loginToDashboard = 'images/login_to_dashboard.svg';
  static String requestAccess = 'images/request_home_access.svg';
  static String obWelcome = 'images/obWelcome.svg';
  static String obIcon = 'images/ob_icon.svg';
  static String newob = 'images/newob.svg';
  static String cross = 'images/cross.png';
  static String latestOb = 'images/latest_ob.png';
  static String sandClock = 'images/sand_clock.png';
  static String vdots = 'images/vdots.png';
  static String vdotsSvg = 'images/svg_v_dots.svg';
  static String conrolScreenOB = 'images/control_screen_ob.png';
  static String obWhite = 'images/ob_with_bottom.png';

  static String bkgTowerOrientation =
      'images/tower_orientation_bkg_w_circle.png';
  static String bkgTowerOrientationWithDir = 'images/tower_bg_w_dir.png';
  static String bkgMarine = 'images/marine_bkg.png';

  static String bkgWeatherCloudy = 'images/weather_bkg_cloudy.png';
  static String bkgWeatherFoggy = 'images/weather_bkg_foggy.png';
  static String bkgWeatherRainy = 'images/weather_bkg_rainy.png';
  static String bkgWeatherStormy = 'images/weather_bkg_stormy.png';
  static String bkgWeatherSunnyCloudy = 'images/weather_bkg_sunny_cloudy.png';
  static String bkgWeatherBkgSunny = 'images/weather_bkg_sunny.png';

  static String bkgControl = 'images/control_bkg.png';
  static String bkgSteering = 'images/steering_bkg.png';

  static String icHome = 'images/ic_home.png';
  static String icVerticalDots = 'images/vertical_dots.png';

  static String icSolarBattery = 'images/solar_battery.png';
  static String icCamera = 'images/camera.png';
  static String icWaterLeakDetectors = 'images/water_leak_detectors.png';
  static String icDrinkingWaterLevels = 'images/drinking_water_levels.png';
  static String icCo2Level = 'images/CO2_Level.png';
  static String icFireDetector = 'images/fire_detector.png';
  static String icInsideTemperature = 'images/inside_temp.png';
  static String icFrostWindows = 'images/frost_windows.png';
  static String icLowerStairs = 'images/lower_stairs.png';

  static String icControls = 'images/controls.png';
  static String icMarine = 'images/marine.png';
  static String icWeather = 'images/weather.png';
  static String icAccessMngmnt = 'images/key_access.png';
  static String icSteering = 'images/steering.png';
  static String icNotificationHistory = 'images/notification_history.png';
  static String icNotifications = 'images/notification_bell.png';
  static String icAccessRequest = 'images/key_access.png';
  static String icSettings = 'images/settings.png';
  static String icProfile = 'images/profile.png';
  static String icLogout = 'images/log_out.png';
  static String icHamburger = 'images/hamburger.png';
  static String icGroup = 'images/Group.png';
  static String icAvatar = 'images/avatar.png';
  static String icMail = 'images/email_icon.png';
  static String icPhone = 'images/ic_phone.png';

  static String icWaterTemp = 'images/water_temp.png';
  static String icSeaLevel = 'images/sea_level.png';
  static String icWaveHeight = 'images/wave_height.png';
  static String icSignificantWave = 'images/significant_wave.png';
  static String icVisibility = 'images/visibility.png';
  static String icSwellHeight = 'images/swell_height.png';
  static String icSwellDirection = 'images/swell_direction.png';
  static String icSwellPeriod = 'images/swell_period.png';
  static String icTides = 'images/tides.png';
  static String icWind = 'images/wind.png';
  static String icPressure = 'images/pressure.png';

  static String icRead = 'images/ic_read.png';
  static String icUnread = 'images/ic_unread.png';
  static String icAdd = 'images/ic_add.png';
  static String meterBar = 'images/meter.png';
  static String towerOrientation = 'images/tower_orientation_bkg.png';

  static String marineDividerLine = 'images/marine_divider.png';

  static String admin_avatar = 'images/admin_avatar.png';

  static String svgSeaGround = 'images/sea_ground.svg';
  static String svgSeaGround2 = 'images/sea_ground2.svg';
  static String svgSeaWave = 'images/sea_wave.svg';
  static String svgSeaWave2 = 'images/sea_wave2.svg';
  static String svgObWhite = 'images/ob_white.png';
  static String svgObUnderWater = 'images/ob_under_water.svg';
  static String svgGradationAboveWater = 'images/gradation_above_water.svg';
  static String svgGradationUnderWater = 'images/gradation_under_water.svg';
  static String svgMarineDividerLine = 'images/Line_2.7.svg';

  static String svgCloudRain = 'images/cloud_rain.svg';
  static String svgCloudy = 'images/cloudy.svg';
  static String svgStormy = 'images/stormy.svg';
  static String svgCloudSunny = 'images/sunny_and_cloudy.svg';

  static String svgWeatherTypeRainy = 'images/rainy.svg';
  static String svgWeatherTypeStormy = 'images/stormy.svg';
  static String svgWeatherTypeCloudy = 'images/cloudy.svg';
  static String svgWeatherTypeOvercast = 'images/overcast.svg';
  static String svgWeatherTypeWildGusts = 'images/wid gusts.svg';
  static String svgWeatherTypePartlyCloudy = 'images/partly cloudy.svg';
  static String svgWeatherTypeAirDensity = 'images/air density.svg';

  static String svgRainDuration = 'images/rain duration.svg';
  static String svgRainAccumulation = 'images/rain accumulation.svg';
  static String svgRainIntensity = 'images/rain intensity.svg';

  static String svgAlarmLightingDetectedLast3hours =
      'images/lightnig detected last 3 hours.svg';
  static String svgCountLightingStrike = 'images/lightning strike count.svg';
  static String svgAlarmLightingDistanceDetected =
      'images/lightning distance detected.svg';
  static String svgLighitngLastDetected = 'images/lightning last detected.svg';

  static String svgHumidity = 'images/humidity.svg';
  static String svgUmbrella = 'images/umbrella.svg';

  static String svgSolarRadiation = 'images/solarradiation.svg';
  static String svguvRadiation = 'images/uv_radiation.svg';
  static String svgWindDirection = 'images/wind_direction.svg';
  static String svgWindGusts = 'images/wind_gusts.svg';
  static String svgWindSpeed = 'images/wind_speed.svg';
  static String svgBarometricPresure = 'images/barometric_pressure.svg';

  // marine svg icons
  static String svgSeaLevel = 'images/sea_level.svg';
  static String svgSignificantWave = 'images/significant_wave.svg';
  static String svgSwellDirection = 'images/swell_direction.svg';
  static String svgSwellHeight = 'images/swell_height.svg';
  static String svgSwellPeriod = 'images/swell_period.svg';
  static String svgTides = 'images/TIDES.svg';
  static String svgVisibility = 'images/visibility.svg';
  static String svgWaterTemp = 'images/water_temp.svg';
  static String svgWaveHeight = 'images/wave_height.svg';
  static String svgAccessRequest = 'images/access_requests.svg';

  // control svg icons
  static String svgSoalrBattery = 'images/solar_battery.svg';
  static String svgCamera = 'images/camera.svg';
  static String svgWaterLeakDetectors = 'images/water_leak_detectors.svg';
  static String svgDrikingWaterLevel = 'images/drinking_water_levels.svg';
  static String svgCo2Level = 'images/CO2_Level.svg';
  static String svgFireDetector = 'images/fire_detector.svg';
  static String svgInsideTemp = 'images/inside_temp.svg';
  static String svgFrostWindows = 'images/frost_windows.svg';
  static String svgLowerStairs = '';

  static String svgMoreIcon = 'images/more_icon.svg';
  static String svgWeatherDayStatus = 'images/weather_day_status.svg';
  static String svgWeatherInfoDividerLine =
      'images/svg_weather_info_divider.svg';
  // static String svgCamera = 'images/camera.svg';
  static String svgBulb = 'images/bulb.svg';
  static String svgMterbars = 'images/meter.svg';
  static String svgAc = 'images/ac.svg';

  // camera page
  static String cameraPreview =
      'images/camera_static.jpg'; //'images/tempCameraPreview.png';
  static String svgBedRoom = 'images/bedroom.svg';
  static String svgKitchen = 'images/kitchen.svg';
  static String svgLivingRoom = 'images/living_room.svg';
  static String svgUnderWaterRoom = 'images/underwater_room.svg';
  static String svgMovement = 'images/movement.svg';

  static String svgAcceptInvitation = 'images/access_invitaion.svg';

  static String svgError = 'images/ic_error_svg.svg';
  static String svgInvitationReceived = 'images/ic_invitation_received_svg.svg';
  static String svgInvitationSent = 'images/ic_invitation_sent_svg.svg';
  static String svgAccessKey = 'images/ic_key_svg.svg';
  static String svgMngmnt = 'images/ic_mngmnt_svg.svg';
  static String svgRequestAccess = 'images/ic_req_access_svg.svg';
  static String svgRequsetReceived = 'images/ic_request_received_svg.svg';
  static String svgRequestSent = 'images/ic_request_sent_svg.svg';
  static String svgSourceLocal = 'images/ic_satelile_disg_svg.svg';
  static String svgSourceLocalDisc = 'images/ic_svg_loacl_disc.svg';
  static String svgSourceExternal = 'images/ic_antena_svg.svg';
  static String svgSendInvitation = 'images/ic_send_invit_svg.svg';
  static String svgEdit = 'images/icon_edit_svg.svg';
  static String svgSeapod = 'images/icon_seapod_svg.svg';

  // weather type
  static String weatherTypeSunny = 'images/SUNNY.svg';
  static String weatherTypeThunderyOutbreakPossible =
      'images/THUNDERY_OUTBREAKS_POSSIBLE.svg';
  static String weatherTypePatchySnowPossible =
      'images/PATCHY_SNOW_POSSIBLE.svg';
  static String weatherTypePatchySleetPossible =
      'images/PATCHY_SLEET_POSSIBLE.svg';
  static String weatherTypePatchyRainPossible =
      'images/PATCHY_RAIN_POSSIBLE.svg';
  static String weatherTypePatchyLightRain = 'images/PATCHY_LIGHT_RAIN.svg';
  static String weatherTypePatchyLightDrizzle =
      'images/PATCHY_LIGHT_DRIZZLE.svg';
  static String weatherTypePatchyFreezingDrizzlePossible =
      'images/PATCHY_FREEZING_DRIZZLE_POSSIBLE.svg';
  static String weatherTypePartyCloudy = 'images/PARTLY_CLOUDY.svg';
  static String weatherTypeOvercast = 'images/OVERCAST.svg';
  static String weatherTypeModerateRain = 'images/MODERATE_RAIN.svg';
  static String weatherTypeModerateRainAtTime =
      'images/MODERATE_RAIN_AT_TIMES.svg';
  static String weatherTypeMist = 'images/MIST.svg';
  static String weatherTypeLightRain = 'images/LIGHT RAIN.svg';
  static String weatherTypeLightDrizzle = 'images/LIGHT DRIZZLE.svg';
  static String weatherTypeHeavyRain = 'images/HEAVY_RAIN.svg';
  static String weatherTypeHeavyRainAtTime = 'images/HEAVY_RAIN_AT_TIMES.svg';
  static String weatherTypeHeavyFreezingDrizzle =
      'images/HEAVY FREEZING DRIZZLE.svg';
  static String weatherTypeFreezingFog = 'images/FREEZING_FOG.svg';
  static String weatherTypeFreezingDrizzle = 'images/FREEZING_DRIZZLE.svg';
  static String weatherTypeFog = 'images/FOG.svg';
  static String weatherTypeCloudy = 'images/cloudy.svg';
  static String weatherTypeBlowingSnow = 'images/BLOWING_SNOW.svg';
  static String weatherTypeBizzard = 'images/BLIZZARD.svg';

  static String svgUrgentNotification = 'images/notification_history.svg';

  static String svgSettings = 'images/settings.svg';

  static String svgBulbLarge = 'images/lightining_scenes.svg';

  static String svgMap = 'images/ic_map.svg';
  static String svgIcSent = 'images/ic_sent.svg';
  static String svgIcReceived = 'images/ic_received.svg';
  static String svgIcLock = 'images/ic_lock.svg';

  static String svgBack = 'images/back.svg';
  static String svgNext = 'images/next.svg';
  static String svgMarineIcon = 'images/marine.svg';
  static String svgHomeIcon = 'images/seapod_icon.svg';
  static String svgControlIcon = 'images/controls.svg';
  static String svgSteeringIcon = 'images/steering.svg';
  static String svgWeatherIcon = 'images/weather.svg';
  static String svgPlus = 'images/ic_plus.svg';

  static String avatarBkg = 'images/avatar_bkg.png';

  static String svgIcDrawerControls = 'images/ic_drawer_controls.svg';
  static String svgIcDrawerLogout = 'images/ic_drawer_logut.svg';
  static String svgIcDrawerManagement = 'images/ic_drawer_management.svg';
  static String svgIcDrawerMarine = 'images/ic_drawer_marine.svg';
  static String svgIcDrawerNotiHistory =
      'images/ic_drawer_notification_history.svg';
  static String svgIcDrawerProfile = 'images/ic_drawer_profile.svg';
  static String svgIcDrawerSettings = 'images/ic_drawer_steering.svg';
  static String svgIcDrawerSteering = 'images/ic_drawer_steering.svg';
  static String svgIcDrawerWeather = 'images/ic_drawer_weather.svg';
}

class AppStrings {
  static String solarRadiation = 'SOLAR RADIATION';
  static String uvRadiation = 'UV RADIATION';
  static String windSpeed = 'WIND SPEED';
  static String windGusts = 'WIND GUSTS';
  static String windDirection = 'WIND DIRECTION';
  static String barometricPressure = 'BAROMETRIC PRESSURE';
  static String waterTemp = 'WATER TEMPERATURE';
  static String seaLevel = 'SEA LEVEL';
  static String waveHeight = 'WAVE HEIGHT';
  static String significantWave = 'SIGNIFICANT WAVE';
  static String visibility = 'VISIBILITY';
  static String swellHeight = 'SWELL HEIGHT';
  static String swellDirection = 'SWELL DIRECTION';
  static String swellPeriod = 'SWELL PERIOD';
  static String tides = 'TIDES';
  static String home = 'HOME';
  static String controls = 'CONTROLS';
  static String marine = 'MARINE';
  static String weather = 'WEATHER';
  static String accessManagement = 'ACCESS MANAGEMENT';
  static String seapodManagement = 'SEAPOD MANAGEMENT';
  static String steering = 'STEERING';
  static String notifications = 'NOTIFICATIONS';
  static String notiHistory = 'NOTIFICATION HISTORY';
  static String accessRequests = 'ACCESS REQUESTS';
  static String settings = 'SETTINGS';
  static String profile = 'PROFILE';
  static String logout = 'LOGOUT';
  static String welcomeMessage =
      'Design your own SeaPod\nHome or Scan an SeaPod\nQR code to access home controls';
  static String scanHomeQrCode = 'SCAN HOME QR CODE';
  static String designYourOB = 'DESIGN YOUR SEAPOD';
  static String startCustomization = 'START CUSTOMIZATION';
  static String loginToDashboard = 'LOGIN TO DASHBOARD';
  static String requestHomeAccess = 'REQUEST SEAPOD ACCESS';
  static String requestAcceptHomeAccess = 'REQUEST OR ACCEPT SEAPOD ACCESS';
  static String design = 'DESIGN';
  static String designMessage =
      'Design Your Own\nSeaPod And See It\nCome To Life';
  static String email = 'EMAIL';
  static String password = 'PASSWORD';
  static String solarBattery = 'Solar battery and\npower consumption';
  static String solarBatteryTitle = 'Solar battery level';
  static String cameras = 'Cameras';
  static String waterLeakDetectors = 'Water Leak Detectors';
  static String drinkingWaterLevels = 'Drinking Water Levels';
  static String co2Level = 'CO2_Level';
  static String fireDetector = 'Fire Detector';
  static String insideTemperature = 'Inside Temperature';
  static String temperature = 'Temperature';
  static String frostWindows = 'Frost Windows';
  static String lowerStairs = 'LOWER STAIRS';
  static String loweringStairs = 'LOWERING STAIRS...';
  static String raiseStairs = 'RAISE STAIRS';
  static String raisingStairs = 'RAISING STAIRS...';
  static String stairsFullyLowered = 'STAIRS FULLY LOWERED';
  static String stairsFullyRaised = 'STAIRS FULLY RAISED';
  static String noInternetConnection = 'Internet connection is not available.';
  static String noInternetConnectionTryAgain =
      'Internet connection is not available, please try again later.';
  static String internetConnection = 'Internet connection is available.';
  static String dismiss = 'Dismiss';
  static String selectOceanBuilder = 'Select SeaPod';
  static String pendingRequests = 'Pending requests';
  static String sentInvitations = 'SENT INVITATIONS';
  static String sentRequests = 'SENT REQUESTS';
  static String receivedRequests = 'RECEIVED REQUESTS';
  static String receivedInvitations = 'RECEIVED INVITATIONS';
  static String lights = 'Lights';
  static String goTOLightingSceen = 'GO TO LIGHTING PAGE';
  static String intensity = 'Intensity';
  static String lighting = 'Lighting';
  static String lightingSceneList = 'Lighting Scenes';
  static String slectLight = 'Select Light';

  static String noData = 'No Data';

  static String urgentNotification = 'URGENT NOTIFICATIONS';

  static String notAvailableRightNow =
      'This feature is not available right now';

  static String viewAllTheScenes = 'VIEW ALL THE SCENES';

  static String changePassword = 'Change password';

  static String changeEmail = 'Change Email';

  static String acceptHomeAccessInvitation = 'ACCEPT SEAPOD ACCESS INVITATION';

  static String continueDesign = 'CONTINUE DESIGN';

  static String saveYourSeaPod =
      'This will allow you to continue designing your seapod any time, anywhere ';

  static String remindMeLater = 'Remind Me Later';

  static String noThanks = 'No, Thanks';

  static String saveYourSeaPodTitle = 'SAVE YOUR SEAPOD';

  static String seaPodSavedTitle = 'SEAPOD SAVED, THANKS!';

  static String seaPodSavedInfo = 'All NEW CHANGES WILL BE SAVED AUTOMATICALLY';

  static String seaPodSaved =
      'Please remember the name you chose.\nIf you want to continue with your design\nfrom a a different device you will need to provide the name of the seapod.';

  static String accessEvent = 'Access Event';

  static String noInvitationFound = 'No invitation found!';

  static String noRequestFound = 'No request found!';

  static String humidity = 'Humidity';

  static String chanceOfRain = 'Chance of Rain';

  static String smartHome = 'Smart Home';

  static String smartHome_local_server = 'Smart Home(Server)';

  static String smartHomeMessage =
      'Get latest update\nand control your\nseapod devices';

  static String checkYourInbox = 'Check your inbox';

  static String confirmEmailText1 =
      'We have sent you an email with a link that will allow you to finish your account setup.';

  static String confirmEmailText2 =
      'Alternatively, you can enter the code provided in the email here';
}

class NotificationConstants {
  static String request = 'SEAPOD ACCESS REQUEST';
  static String response = 'SEAPOD ACCESS RESPONSE';
  static String invitation = 'INVITATION';
  static String invitationResponse = 'INVITATION RESPONSE';
  static String accepted = 'ACCEPTED';
  static String denied = 'DENIED';
  static String initiated = 'PENDING';
  static String pending = 'PENDING';
  static String canceled = 'CANCELED';
}

class ErrorConstants {
  static const SERVER_BUSY_TITLE = 'SERVER BUSY';
  static const SERVER_BUSY = 'Server is busy, please try again later';
  static const INVALID_CREDENTIALS =
      'Email OR Password is incorrect. Please try again!';
  static const TITLE_INVALID_VESSELCODE = 'INVALID VESSEL CODE';
  static const INVALID_VESSELCODE =
      'Vessel code is not valid, Please try again.';
  static const TITLE_INVALID_VESSELCODE_OWNER = 'INVALID VESSEL CODE OWNER';
  static const INVALID_VESSELCODE_OWNER =
      'Vessel code owner is not valid, Please try again.';
  static const TITLE_SENDING_ACCESS_REQUEST_FAILED =
      'SENDING ACCESS REQUEST FAILED';
  static const SENDING_ACCESS_REQUEST_FAILED =
      'Access request sending failed, please try again later.';
  static const TITLE_SENDING_ACCESS_REQUEST_YOURSELF =
      'SENDING REQUEST TO SELF';
  static const SENDING_ACCESS_REQUEST_YOURSELF =
      'Can not send access request to self.';
  static const INVALID_USER_DATA = 'Invalid user data, please fill again';
  static const TITLE_INVALID_USER_DATA = 'INVALID USER DATA';
  static const TITLE_SENDING_ACCESS_REQUEST_AGAIN = 'REQUEST ALREADY ACCEPTED';
  static const SENDING_ACCESS_REQUEST_AGAIN =
      'Your access request to this OB has been already accepted';
  static const TITLE_USER_ALREADY_EXISTS = 'ALREADY A MEMEBER';
  static const USER_ALREADY_EXISTS =
      'You are already a member, please sign in to continue.';
  static const USER_ALREADY_EXISTS_USE_ALREADY_BUTTON =
      'Please sign in using ALREADY A MEMBER? option';
}

class SymbolConstant {
  static String DEGREE = '\u{00B0}';
}

class AppLaunchState {
  static bool LAUNCH_FROM_NOTIFICATION_TRAY = false;

  static bool RESUME_FROM_NOTIFICATION_TRAY = false;
}

class SharedPreferanceKeys {
  static String KEY_PROFILE_PIC = 'profile_image';
  static String KEY_SELECTED_OB_ID = 'selected_ob_id';
  static String KEY_X_AUTH_TOKEN = 'x-auth-token';
  static String KEY_X_AUTH_TOKEN_EARTH_STATION = 'x-auth-token-es';
  static String KEY_EMAIL = 'key_email';
}

class ApplicationStatics {
  static String SELECTED_OB_ID;
  static DrawerIndex selectedScreenIndex = DrawerIndex.HOME;

  static OceanBuilderUser oceanBuilderUser;

  static String selectedWeatherProvider = 'external';
}

enum WeatherType { COLUDY, SUNNY_CLOUDY, RAINY, STORMY }

class GlobalListeners {
  static StreamSubscription listener;
}

class GlobalContext {
  static BuildContext currentScreenContext;
  static int dashBoardBuildCount = 0;
  static bool internetStatus;
  static SwiperController swiperController = new SwiperController();
  static int currentScreenIndex = 0;
  static bool isDrawerOpen = false;

  static List<SearchItem> appItems = [];
  static List<String> searchItems = [];

  // static List<String> selectedItems = [];
}

class NavigationContext {
  static const int HOME = 0;
  static const int CONTROL = 1;
  static const int WEATHER = 2;
  static const int MARINE = 3;
}

class ProfileEditState {
  static bool profileInfoChanged = false;
  static bool emergencyContactInfoChanged = false;
}

class WeatherDescMap {
  static var weatherCodeMap = {
    '113': {'Sunny', ImagePaths.weatherTypeSunny},
    '116': {'Partly cloudy', ImagePaths.svgWeatherTypePartlyCloudy},
    '119': {'Cloudy', ImagePaths.svgWeatherTypeCloudy},
    '122': {'Overcast', ImagePaths.svgWeatherTypeOvercast},
    '143': {'Mist', ImagePaths.weatherTypeMist},
    '176': {'Patchy rain possible', ImagePaths.weatherTypePatchyRainPossible},
    '179': {'Patchy snow possible', ImagePaths.weatherTypePatchySnowPossible},
    '182': {'Patchy sleet possible', ImagePaths.weatherTypePatchySleetPossible},
    '185': {
      'Patchy freezing drizzle possible',
      ImagePaths.weatherTypePatchyFreezingDrizzlePossible
    },
    '200': {
      'Thundery outbreaks possible',
      ImagePaths.weatherTypeThunderyOutbreakPossible
    },
    '227': {'Blowing snow', ImagePaths.weatherTypeBlowingSnow},
    '230': {'Blizzard', ImagePaths.weatherTypeBizzard},
    '248': {'Fog', ImagePaths.weatherTypeFog},
    '260': {'Freezing fog', ImagePaths.svgStormy},
    '263': {'Patchy light drizzle', ImagePaths.weatherTypePatchyLightDrizzle},
    '266': {'Light drizzle', ImagePaths.weatherTypeLightDrizzle},
    '281': {'Freezing drizzle', ImagePaths.weatherTypeFreezingDrizzle},
    '284': {
      'Heavy freezing drizzle',
      ImagePaths.weatherTypeHeavyFreezingDrizzle
    },
    '293': {'Patchy light rain', ImagePaths.weatherTypePatchyLightRain},
    '296': {'Light rain', ImagePaths.weatherTypeLightRain},
    '299': {'Moderate rain at times', ImagePaths.weatherTypeModerateRainAtTime},
    '302': {'Moderate rain', ImagePaths.weatherTypeModerateRain},
    '305': {'Heavy rain at times', ImagePaths.weatherTypeHeavyRainAtTime},
    '308': {'Heavy rain', ImagePaths.weatherTypeHeavyRain},
    '311': {'Light freezing rain', ImagePaths.weatherTypeLightRain},
    '314': {'Moderate or Heavy freezing rain', ImagePaths.weatherTypeHeavyRain},
    '317': {'Light sleet', ImagePaths.weatherTypePatchySleetPossible},
    '320': {'Moderate or heavy sleet', ImagePaths.svgCloudRain},
    '323': {'Patchy light snow', ImagePaths.svgWindGusts},
    '326': {'Light snow', ImagePaths.svgWindGusts},
    '329': {'Patchy moderate snow', ImagePaths.svgWindGusts},
    '332': {'Moderate snow', ImagePaths.svgWindGusts},
    '335': {'Patchy heavy snow', ImagePaths.svgWindGusts},
    '338': {'Heavy snow', ImagePaths.svgWindGusts},
    '350': {'Ice pellets', ImagePaths.svgStormy},
    '353': {'Light rain shower', ImagePaths.svgStormy},
    '356': {'Moderate or heavy rain shower', ImagePaths.svgStormy},
    '359': {'Torrential rain shower', ImagePaths.svgStormy},
    '362': {'Light sleet showers', ImagePaths.svgStormy},
    '365': {'Moderate or heavy sleet showers', ImagePaths.svgStormy},
    '368': {'Light snow showers', ImagePaths.svgStormy},
    '371': {'Moderate or heavy snow showers', ImagePaths.svgStormy},
    '374': {'Light showers of ice pellets', ImagePaths.svgStormy},
    '377': {'Moderate or heavy showers of ice pellets', ImagePaths.svgStormy},
    '386': {'Patchy light rain in area with thunder', ImagePaths.svgStormy},
    '389': {
      'Moderate or heavy rain in area with thunder',
      ImagePaths.svgStormy
    },
    '392': {'Patchy light snow in area with thunder', ImagePaths.svgStormy},
    '395': {
      'Moderate or heavy snow in area with thunder',
      ImagePaths.svgStormy
    },
  };

  static List<String> stormyWeatherCodes = [
    '200',
    '227',
    '230',
    '371',
    '374',
    '377',
    '386',
    '389',
    '392',
    '395'
  ];
  static List<String> rainyWeatherCodes = [
    '176',
    '179',
    '182',
    '185',
    '263',
    '266',
    '281',
    '284',
    '293',
    '296',
    '299',
    '302',
    '305',
    '308',
    '311',
    '314',
    '317',
    '320',
    '353',
    '356',
    '359',
    '362',
    '365',
    '368'
  ];
  static List<String> cloudyWeatherCodes = ['119'];
  static List<String> foggyWeatherCodes = [
    '143',
    '248',
    '260',
    '323',
    '326',
    '329',
    '332',
    '335',
    '338',
    '350'
  ];
  static List<String> sunnyCloudyWeatherCodes = [
    '116',
    '122',
  ];
  static List<String> sunnyWeatherCodes = ['113'];
}

class TempPermissionData {
  static PermissionSet permissionSet = PermissionSet(
      permissionSetName: 'Default Visitor Permission',
      permissionGroups: permissions);

  static List<PermissionGroup> permissions = [
    mainControllPermissionSet,
    cameraPermission,
    lighting,
    accessManagement,
    seapodInformation
  ];
  static PermissionGroup mainControllPermissionSet =
      PermissionGroup(name: 'Main Control', permissions: [
    Permission(name: 'Change the orientation of the tower', status: 'ON'),
    Permission(name: 'Raise/lower the stairs of the spar', status: 'OFF'),
    Permission(name: 'Frost windows', status: 'ON'),
    Permission(name: 'Modify AC temperature / fan speed, etc.', status: 'ON'),
    Permission(name: 'Doors control', status: 'ON'),
    Permission(name: 'Windows control', status: 'ON'),
    Permission(name: 'Smart windows control', status: 'ON'),
    Permission(name: 'Power supply', status: 'ON'),
    Permission(name: 'Water supply', status: 'ON'),
    Permission(name: 'Audio System', status: 'ON'),
    Permission(name: 'Stove', status: 'ON'),
    Permission(name: 'Oven', status: 'ON')
  ]);

  static PermissionGroup cameraPermission =
      PermissionGroup(name: 'Cameras', permissions: [
    Permission(name: 'View Kitchen Cameras', status: 'ON'),
    Permission(name: 'View Living room camera', status: 'ON'),
    Permission(name: 'View Bedrrom Cameras', status: 'ON')
  ]);

  static PermissionGroup steeringPermission =
      PermissionGroup(name: 'Steering', permissions: [
    Permission(name: 'Steering control', status: 'ON'),
    Permission(name: 'Steering control', status: 'ON'),
  ]);

  static PermissionGroup droneDelivery =
      PermissionGroup(name: 'Drone Delivery', permissions: [
    Permission(name: 'Drone Delivery', status: 'ON'),
    Permission(name: 'Drone Delivery', status: 'ON'),
  ]);

  static PermissionGroup lighting =
      PermissionGroup(name: 'Lighting', permissions: [
    Permission(name: 'Turn Lights', status: 'ON'),
    Permission(name: 'Modify Intensity', status: 'ON'),
    Permission(name: 'Switch Lightscene', status: 'ON'),
    Permission(name: 'Add Global Lightscene', status: 'ON'),
    Permission(name: 'Manage Global Lightscene', status: 'ON')
  ]);

  static PermissionGroup generalMonitoring =
      PermissionGroup(name: 'General Monitoring', permissions: [
    Permission(name: 'General Monitoring', status: 'ON'),
    Permission(name: 'General Monitoring', status: 'ON'),
  ]);

  static PermissionGroup accessManagement = PermissionGroup(
      name: 'Access Management',
      permissions: [Permission(name: 'inviteGuests', status: 'ON')]);

  static PermissionGroup accountingBills =
      PermissionGroup(name: 'Accounting Bills', permissions: [
    Permission(name: 'Accounting Bills', status: 'ON'),
    Permission(name: 'Accounting Bills', status: 'ON'),
  ]);

  static PermissionGroup seapodInformation =
      PermissionGroup(name: 'SeaPod Information', permissions: [
    Permission(name: 'Serial Number', status: 'ON'),
    Permission(name: 'Model InfoAndSpec', status: 'ON'),
  ]);
}

class PredefinedLightData {
  static List<Light> lights = [
    new Light(lightName: 'Lightstrip 1', lightColor: '0xFF959B1B'),
    new Light(lightName: 'Lightstrip 2', lightColor: '0xFF1322FF'),
    new Light(lightName: 'Ligh 3', lightColor: '0xFFFF1EEE'),
    new Light(lightName: 'Counter 4', lightColor: '0xFFFFBE93'),
    new Light(lightName: 'Ocerhead 3', lightColor: '0xFFC1FFE5')
  ];

  static List<Light> lightsBedroom = [
    new Light(lightName: 'Lightstrip 1', lightColor: '0xFF959B1B'),
    new Light(lightName: 'Lightstrip 2', lightColor: '0xFF1322FF'),
    new Light(lightName: 'Ligh 3', lightColor: '0xFFFF1EEE'),
    new Light(lightName: 'Counter 4', lightColor: '0xFFFFBE93'),
    new Light(lightName: 'Ocerhead 3', lightColor: '0xFFC1FFE5')
  ];

  static List<Light> lightsLivingRoom = [
    new Light(lightName: 'Lightstrip 1', lightColor: '0xFF959B1B'),
    new Light(lightName: 'Lightstrip 2', lightColor: '0xFF1322FF'),
    new Light(lightName: 'Ligh 3', lightColor: '0xFFFF1EEE'),
    new Light(lightName: 'Counter 4', lightColor: '0xFFFFBE93'),
    new Light(lightName: 'Ocerhead 3', lightColor: '0xFFC1FFE5')
  ];

  static List<Light> lightsKitchen = [
    new Light(lightName: 'Lightstrip 1', lightColor: '0xFF959B1B'),
    new Light(lightName: 'Lightstrip 2', lightColor: '0xFF1322FF'),
    new Light(lightName: 'Ligh 3', lightColor: '0xFFFF1EEE'),
    new Light(lightName: 'Counter 4', lightColor: '0xFFFFBE93'),
    new Light(lightName: 'Ocerhead 3', lightColor: '0xFFC1FFE5')
  ];

  static List<Light> lightsUnderWaterRoom = [
    new Light(lightName: 'Lightstrip 1', lightColor: '0xFF959B1B'),
    new Light(lightName: 'Lightstrip 2', lightColor: '0xFF1322FF'),
    new Light(lightName: 'Ligh 3', lightColor: '0xFFFF1EEE'),
    new Light(lightName: 'Counter 4', lightColor: '0xFFFFBE93'),
    new Light(lightName: 'Ocerhead 3', lightColor: '0xFFC1FFE5')
  ];

  static List<Room> rooms = [
    new Room(
        roomName: 'Bedroom',
        // light: lightsBedroom[0],
        lightModes: lightsBedroom),
    new Room(
        roomName: 'Livingroom',
        // light: lightsLivingRoom[1],
        lightModes: lightsLivingRoom),
    new Room(
        roomName: 'Kitchen',
        // light: lightsKitchen[2],
        lightModes: lightsKitchen),
    new Room(
        roomName: 'UnderWaterRoom',
        // light: lightsUnderWaterRoom[3],
        lightModes: lightsUnderWaterRoom),
  ];

  static List<Scene> scenes = [
    new Scene(
      name: 'New Scene',
      rooms: rooms,
    ),
    new Scene(
      name: 'Night Mode',
      rooms: rooms,
    ),
    new Scene(
      name: 'Day Mode',
      rooms: rooms,
    ),
    new Scene(
      name: 'Entertainment',
      rooms: rooms,
    ),
    new Scene(
      name: 'Rainy Day Scene',
      rooms: rooms,
    ),
  ];

  static List<Scene> defaultscenes = [
    new Scene(
      id: 'id1',
      name: 'Day Mode',
      rooms: rooms,
    ),
    new Scene(
      id: 'id2',
      name: 'Night Mode',
      rooms: rooms,
    )
  ];

  static Lighting lighting = new Lighting(
    isLightON: true,
    intensity: 0.5,
    selectedScene: defaultscenes[0].id,
    sceneList: defaultscenes,
  );
}

List<String> WEATEHR_SOURCE_LIST = [
  'LOCAL (WEATHERFLOW STATION)',
  'EXTERNAL (STORMGLASS)'
];

SearchItem SELECTED_SEARCH_ITEM;

// List<App>

/*

{
    "sceneName": "First Scene",
    "rooms": [
        {
            "label": "BedRoom",
            "moodes": [
                {
                    "Lightstrip 1": "0xFF959B1B"
                },
                {
                    "Lightstrip 2": "0xFF1322FF"
                },
                {
                    "Light 3": "0xFFFF1EEE"
                },
                {
                    "Counter 4": "0xFFBE93"
                },
                {
                    "Ocerhead 3": "0xFFC1FFE5"
                }
            ]
        },
        {
            "label": "Livingroom",
            "moodes": [
                {
                    "Lightstrip 1": "0xFF959B1B"
                },
                {
                    "Lightstrip 2": "0xFF1322FF"
                },
                {
                    "Light 3": "0xFFFF1EEE"
                },
                {
                    "Counter 4": "0xFFBE93"
                },
                {
                    "Ocerhead 3": "0xFFC1FFE5"
                }
            ]
        },
        {
            "label": "Kitchen",
            "moodes": [
                {
                    "Lightstrip 1": "0xFF959B1B"
                },
                {
                    "Lightstrip 2": "0xFF1322FF"
                },
                {
                    "Light 3": "0xFFFF1EEE"
                },
                {
                    "Counter 4": "0xFFBE93"
                },
                {
                    "Ocerhead 3": "0xFFC1FFE5"
                }
            ]
        },
        {
            "label": "UnderWaterroom",
            "moodes": [
                {
                    "Lightstrip 1": "0xFF959B1B"
                },
                {
                    "Lightstrip 2": "0xFF1322FF"
                },
                {
                    "Light 3": "0xFFFF1EEE"
                },
                {
                    "Counter 4": "0xFFBE93"
                },
                {
                    "Ocerhead 3": "0xFFC1FFE5"
                }
            ]
        },
    ]
}
*/

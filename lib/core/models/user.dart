import 'package:json_annotation/json_annotation.dart';
import 'package:ocean_builder/core/models/access_request.dart';
import 'package:ocean_builder/core/models/fcm_token.dart';
import 'package:ocean_builder/core/models/lighting.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user_ocean_builder.dart';
import 'package:ocean_builder/core/models/emergency_contact.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  String userID;
  String email;
  String firstName;
  String lastName;
  String country;
  @JsonKey(name: 'mobileNumber')
  String phone;
  String profileImageUrl;

  bool isVerified;

  @JsonKey(nullable: true)
  String xAuthToken;

  @JsonKey(nullable: true)
  String userType;

  @JsonKey(nullable: true)
  String requestAccessTime;

  @JsonKey(nullable: true)
  String password;

  @JsonKey(fromJson: _dateTimeFromEpochUs, toJson: _dateTimeToEpochUs)
  DateTime checkInDate;

  List<UserOceanBuilder> userOceanBuilder;

  List<ServerNotification> notifications;

  @JsonKey(nullable: true)
  FcmToken token;

  @JsonKey(nullable: true)
  List<Scene> lightiningScenes;

  @JsonKey(nullable: true)
  EmergencyContact emergencyContact;

  @JsonKey(name: 'emergencyContacts', nullable: true)
  List<EmergencyContact> emergencyContacts;

  @JsonKey(name: '__v')
  int version;

  @JsonKey(nullable: true)
  List<SeaPod> seaPods;

  @JsonKey(nullable: true)
  List<AccessEvent> accessRequests;

  @JsonKey(nullable: true, name: 'accessInvitation')
  List<AccessEvent> accessInvitations;

  String selectedWeatherSource;

  User(
      {this.userID,
      this.email,
      this.firstName,
      this.lastName,
      this.country,
      this.phone,
      this.profileImageUrl,
      this.isVerified,
      this.userOceanBuilder,
      this.password,
      this.requestAccessTime,
      this.token,
      this.lightiningScenes,
      this.notifications,
      this.checkInDate,
      this.emergencyContact,
      this.seaPods,
      this.selectedWeatherSource,
      this.version});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  static DateTime _dateTimeFromEpochUs(int us) =>
      us == null ? null : DateTime.fromMicrosecondsSinceEpoch(us);
  static int _dateTimeToEpochUs(DateTime dateTime) =>
      dateTime?.microsecondsSinceEpoch;
}

/*

{
    "profileImageUrl": "",
    "seaPods": [
        {
            "powerUtilities": [],
            "soundSystem": [],
            "masterBedroomFloorFinishing": [],
            "hasWeatherStation": false,
            "hasFathometer": false,
            "hasCleanWaterLevelIndicator": false,
            "permissionSets": [
                {
                    "isDefault": true,
                    "_id": "5ee1eba57189612d8020da41",
                    "Name": "Default GUEST Permissions",
                    "MainControls": {
                        "changeOrientation": "OFF",
                        "raiseLowerStairs": "OFF",
                        "frostWindows": "ON",
                        "modifyACTemp": "ON",
                        "doorsControl": "OFF",
                        "windowsControl": "ON",
                        "smartWindowsControl": "ON",
                        "powerSupply": "EMERGENCY",
                        "waterSupply": "EMERGENCY",
                        "audioSystem": "ON",
                        "stove": "ON",
                        "oven": "ON"
                    },
                    "Cameras": {
                        "kitchen": "EMERGENCY",
                        "livingRoom": "EMERGENCY",
                        "Bedroom": "EMERGENCY"
                    },
                    "Lighting": {
                        "turnLights": "ON",
                        "modifyIntensity": "ON",
                        "switchLightscene": "ON",
                        "addPersonalLightscene": "ON",
                        "addGlobalLightscene": "OFF",
                        "manageGlobalLightscene": "OFF"
                    },
                    "AccessManagement": {
                        "inviteGuests": "OFF"
                    },
                    "SeapodInfo": {
                        "serialNumber": "OFF",
                        "modelInfoAndSpec": "OFF"
                    },
                    "__v": 0
                }
            ],
            "defaultLightiningScenes": [],
            "seaPodOrientation": 50,
            "accessRequests": [],
            "accessInvitation": [],
            "_id": "5ee1eba57189612d8020da39",
            "SeaPodName": "Ola SeaPod",
            "exteriorFinish": "exfinish",
            "exterioirColor": "0xff3399FF",
            "sparFinish": "sparFinish",
            "sparDesign": "sparDesign",
            "deckEnclosure": "deckEnclosure",
            "bedAndLivingRoomEnclousure": "bedAndLivingRoomEnclousure",
            "power": "power",
            "underWaterRoomFinishing": "underWaterRoomFinishing",
            "underWaterWindows": "underWaterWindows",
            "masterBedroomInteriorWallColor": "0xff3399FF",
            "livingRoomloorFinishing": "livingRoomloorFinishing",
            "livingRoomInteriorWallColor": "0xff3399FF",
            "kitchenfloorFinishing": "kitchenfloorFinishing",
            "kitchenInteriorWallColor": "0xff3399FF",
            "entryStairs": "true",
            "interiorBedroomWallColor": "0xff3399FF",
            "deckFloorFinishMaterial": "deckFloorFinishMaterial",
            "seaPodStatus": "seaPodStatus",
            "users": [
                {
                    "isDisabled": false,
                    "lighting": {
                        "isOn": false,
                        "lightScenes": [
                            {
                                "seapodId": [
                                    "5ee1eba57189612d8020da39"
                                ],
                                "_id": "5ee1ef5370ef2227b4c9de49",
                                "sceneName": "seapod",
                                "rooms": [
                                    {
                                        "moodes": [
                                            {
                                                "night": "#AAAAAA"
                                            },
                                            {
                                                "night": "#123456"
                                            }
                                        ],
                                        "_id": "5ee1ef5370ef2227b4c9de4a",
                                        "label": "BedRoom"
                                    }
                                ],
                                "__v": 0
                            }
                        ],
                        "_id": "5ee1eba57189612d8020da3a"
                    },
                    "_id": "5ee1eba27189612d8020da36",
                    "userName": "Ola Galal",
                    "profilePicUrl": "",
                    "type": "OWNER",
                    "permissionSet": {
                        "isDefault": true,
                        "_id": "5ee1eba87189612d8020da4a",
                        "Name": "Default OWNER Permissions",
                        "MainControls": {
                            "changeOrientation": "ON",
                            "raiseLowerStairs": "ON",
                            "frostWindows": "ON",
                            "modifyACTemp": "ON",
                            "doorsControl": "ON",
                            "windowsControl": "ON",
                            "smartWindowsControl": "ON",
                            "powerSupply": "ON",
                            "waterSupply": "ON",
                            "audioSystem": "ON",
                            "stove": "ON",
                            "oven": "ON"
                        },
                        "Cameras": {
                            "kitchen": "ON",
                            "livingRoom": "ON",
                            "Bedroom": "ON"
                        },
                        "Lighting": {
                            "turnLights": "ON",
                            "modifyIntensity": "ON",
                            "switchLightscene": "ON",
                            "addPersonalLightscene": "ON",
                            "addGlobalLightscene": "ON",
                            "manageGlobalLightscene": "ON"
                        },
                        "AccessManagement": {
                            "inviteGuests": "ON"
                        },
                        "SeapodInfo": {
                            "serialNumber": "ON",
                            "modelInfoAndSpec": "ON"
                        },
                        "__v": 0
                    }
                }
            ],
            "location": {
                "latitude": 8.005298031789989,
                "longitude": -81.98228152943271
            },
            "vessleCode": "S39EBA5",
            "qrCodeImageUrl": "https://undefined/qrcodes/S39EBA5.png",
            "__v": 2,
            "user": {
                "isDisabled": false,
                "lighting": {
                    "isOn": false,
                    "lightScenes": [
                        {
                            "seapodId": [
                                "5ee1eba57189612d8020da39"
                            ],
                            "_id": "5ee1ef5370ef2227b4c9de49",
                            "sceneName": "seapod",
                            "rooms": [
                                {
                                    "moodes": [
                                        {
                                            "night": "#AAAAAA"
                                        },
                                        {
                                            "night": "#123456"
                                        }
                                    ],
                                    "_id": "5ee1ef5370ef2227b4c9de4a",
                                    "label": "BedRoom"
                                }
                            ],
                            "__v": 0
                        }
                    ],
                    "_id": "5ee1eba57189612d8020da3a"
                },
                "_id": "5ee1eba27189612d8020da36",
                "userName": "Ola Galal",
                "profilePicUrl": "",
                "notificationToken": "jsdfgdsfjghsdfghdfsjkghsfkdjghdfksjghdjf",
                "type": "OWNER",
                "permissionSet": {
                        "isDefault": true,
                        "_id": "5ee1eba87189612d8020da4a",
                        "Name": "Default OWNER Permissions",
                        "MainControls": {
                            "changeOrientation": "ON",
                            "raiseLowerStairs": "ON",
                            "frostWindows": "ON",
                            "modifyACTemp": "ON",
                            "doorsControl": "ON",
                            "windowsControl": "ON",
                            "smartWindowsControl": "ON",
                            "powerSupply": "ON",
                            "waterSupply": "ON",
                            "audioSystem": "ON",
                            "stove": "ON",
                            "oven": "ON"
                        },
                        "Cameras": {
                            "kitchen": "ON",
                            "livingRoom": "ON",
                            "Bedroom": "ON"
                        },
                        "Lighting": {
                            "turnLights": "ON",
                            "modifyIntensity": "ON",
                            "switchLightscene": "ON",
                            "addPersonalLightscene": "ON",
                            "addGlobalLightscene": "ON",
                            "manageGlobalLightscene": "ON"
                        },
                        "AccessManagement": {
                            "inviteGuests": "ON"
                        },
                        "SeapodInfo": {
                            "serialNumber": "ON",
                            "modelInfoAndSpec": "ON"
                        },
                        "__v": 0
                    }
            },
            "data": {
                "insideTemperature": 23,
                "drinkingWaterPercentage": 6,
                "co2Percentage": 55,
                "movementAngle": 47,
                "frostWindowsPercentage": 79,
                "lowerStairsPercentage": 12,
                "solarBatteryPercentage": 68,
                "batteryPercentageWaterLeak": 85,
                "batteryPercentageFireDetectors": 14,
                "batteryPercentageC02": 44
            }
        }
    ],
    "lightiningScenes": [
        {
            "seapodId": [],
            "_id": "5ee1ec937189612d8020da4d",
            "sceneName": "user",
            "rooms": [
                {
                    "moodes": [
                        {
                            "night": "#AAAAAA"
                        },
                        {
                            "night": "#123456"
                        }
                    ],
                    "_id": "5ee1ec937189612d8020da4e",
                    "label": "BedRoom"
                }
            ],
            "userId": "5ee1eba27189612d8020da36",
            "__v": 0
        }
    ],
    "isVerified": true,
    "accessRequests": [],
    "accessInvitation": [],
    "_id": "5ee1eba27189612d8020da36",
    "firstName": "Ola",
    "lastName": "Galal",
    "email": "Ola54@hotmail.com",
    "mobileNumber": "+201092101362",
    "country": "Egypt",
    "notifications": [],
    "emergencyContacts": [],
    "__v": 9
}

=========================================================================================

{
    "profileImageUrl": "",
    "seaPods": [
        {
            "powerUtilities": [],
            "soundSystem": [],
            "masterBedroomFloorFinishing": [
                "Carbon Fiber"
            ],
            "hasWeatherStation": true,
            "hasFathometer": true,
            "hasCleanWaterLevelIndicator": true,
            "permissionSets": [
                {
                    "isDefault": true,
                    "_id": "5eca7c6c3b4ffb001774ee12",
                    "Name": "Default GUEST Permissions",
                    "MainControls": {
                        "changeOrientation": "OFF",
                        "raiseLowerStairs": "OFF",
                        "frostWindows": "ON",
                        "modifyACTemp": "ON",
                        "doorsControl": "OFF",
                        "windowsControl": "ON",
                        "smartWindowsControl": "ON",
                        "powerSupply": "EMERGENCY",
                        "waterSupply": "EMERGENCY",
                        "audioSystem": "ON",
                        "stove": "ON",
                        "oven": "ON"
                    },
                    "Cameras": {
                        "kitchen": "EMERGENCY",
                        "livingRoom": "EMERGENCY",
                        "Bedroom": "EMERGENCY"
                    },
                    "Lighting": {
                        "turnLights": "ON",
                        "modifyIntensity": "ON",
                        "switchLightscene": "ON",
                        "addPersonalLightscene": "ON",
                        "addGlobalLightscene": "OFF",
                        "manageGlobalLightscene": "OFF"
                    },
                    "AccessManagement": {
                        "inviteGuests": "OFF"
                    },
                    "SeapodInfo": {
                        "serialNumber": "OFF",
                        "modelInfoAndSpec": "OFF"
                    },
                    "__v": 0
                },
                {
                    "isDefault": true,
                    "_id": "5eca7c6c3b4ffb001774ee13",
                    "Name": "Default MEMBER Permissions",
                    "MainControls": {
                        "changeOrientation": "ON",
                        "raiseLowerStairs": "ON",
                        "frostWindows": "ON",
                        "modifyACTemp": "ON",
                        "doorsControl": "ON",
                        "windowsControl": "ON",
                        "smartWindowsControl": "ON",
                        "powerSupply": "ON",
                        "waterSupply": "ON",
                        "audioSystem": "ON",
                        "stove": "ON",
                        "oven": "ON"
                    },
                    "Cameras": {
                        "kitchen": "ON",
                        "livingRoom": "ON",
                        "Bedroom": "EMERGENCY"
                    },
                    "Lighting": {
                        "turnLights": "ON",
                        "modifyIntensity": "ON",
                        "switchLightscene": "ON",
                        "addPersonalLightscene": "ON",
                        "addGlobalLightscene": "ON",
                        "manageGlobalLightscene": "ON"
                    },
                    "AccessManagement": {
                        "inviteGuests": "OFF"
                    },
                    "SeapodInfo": {
                        "serialNumber": "ON",
                        "modelInfoAndSpec": "ON"
                    },
                    "__v": 0
                },
                {
                    "isDefault": true,
                    "_id": "5eca7c6c3b4ffb001774ee14",
                    "Name": "Default VISITOR Permissions",
                    "MainControls": {
                        "changeOrientation": "OFF",
                        "raiseLowerStairs": "OFF",
                        "frostWindows": "ON",
                        "modifyACTemp": "ON",
                        "doorsControl": "OFF",
                        "windowsControl": "ON",
                        "smartWindowsControl": "ON",
                        "powerSupply": "OFF",
                        "waterSupply": "OFF",
                        "audioSystem": "ON",
                        "stove": "OFF",
                        "oven": "OFF"
                    },
                    "Cameras": {
                        "kitchen": "EMERGENCY",
                        "livingRoom": "EMERGENCY",
                        "Bedroom": "EMERGENCY"
                    },
                    "Lighting": {
                        "turnLights": "OFF",
                        "modifyIntensity": "OFF",
                        "switchLightscene": "OFF",
                        "addPersonalLightscene": "OFF",
                        "addGlobalLightscene": "OFF",
                        "manageGlobalLightscene": "OFF"
                    },
                    "AccessManagement": {
                        "inviteGuests": "OFF"
                    },
                    "SeapodInfo": {
                        "serialNumber": "OFF",
                        "modelInfoAndSpec": "OFF"
                    },
                    "__v": 0
                },
                {
                    "isDefault": true,
                    "_id": "5eca7c6c3b4ffb001774ee15",
                    "Name": "Default ADMIN Permissions",
                    "MainControls": {
                        "changeOrientation": "EMERGENCY",
                        "raiseLowerStairs": "EMERGENCY",
                        "frostWindows": "EMERGENCY",
                        "modifyACTemp": "EMERGENCY",
                        "doorsControl": "EMERGENCY",
                        "windowsControl": "EMERGENCY",
                        "smartWindowsControl": "EMERGENCY",
                        "powerSupply": "EMERGENCY",
                        "waterSupply": "EMERGENCY",
                        "audioSystem": "EMERGENCY",
                        "stove": "EMERGENCY",
                        "oven": "EMERGENCY"
                    },
                    "Cameras": {
                        "kitchen": "EMERGENCY",
                        "livingRoom": "EMERGENCY",
                        "Bedroom": "EMERGENCY"
                    },
                    "Lighting": {
                        "turnLights": "EMERGENCY",
                        "modifyIntensity": "EMERGENCY",
                        "switchLightscene": "EMERGENCY",
                        "addPersonalLightscene": "EMERGENCY",
                        "addGlobalLightscene": "EMERGENCY",
                        "manageGlobalLightscene": "EMERGENCY"
                    },
                    "AccessManagement": {
                        "inviteGuests": "OFF"
                    },
                    "SeapodInfo": {
                        "serialNumber": "ON",
                        "modelInfoAndSpec": "ON"
                    },
                    "__v": 0
                },
                {
                    "isDefault": true,
                    "_id": "5eca7c6c3b4ffb001774ee16",
                    "Name": "Default OWNER Permissions",
                    "MainControls": {
                        "changeOrientation": "ON",
                        "raiseLowerStairs": "ON",
                        "frostWindows": "ON",
                        "modifyACTemp": "ON",
                        "doorsControl": "ON",
                        "windowsControl": "ON",
                        "smartWindowsControl": "ON",
                        "powerSupply": "ON",
                        "waterSupply": "ON",
                        "audioSystem": "ON",
                        "stove": "ON",
                        "oven": "ON"
                    },
                    "Cameras": {
                        "kitchen": "ON",
                        "livingRoom": "ON",
                        "Bedroom": "ON"
                    },
                    "Lighting": {
                        "turnLights": "ON",
                        "modifyIntensity": "ON",
                        "switchLightscene": "ON",
                        "addPersonalLightscene": "ON",
                        "addGlobalLightscene": "ON",
                        "manageGlobalLightscene": "ON"
                    },
                    "AccessManagement": {
                        "inviteGuests": "ON"
                    },
                    "SeapodInfo": {
                        "serialNumber": "ON",
                        "modelInfoAndSpec": "ON"
                    },
                    "__v": 0
                }
            ],
            "defaultLightiningScenes": [],
            "seaPodOrientation": 50,
            "accessRequests": [
                "5ed2743235d4750017ca6eea"
            ],
            "accessInvitation": [],
            "_id": "5eca7c6c3b4ffb001774ee0f",
            "SeaPodName": "Aqua Vita",
            "exteriorFinish": "Matt",
            "exterioirColor": "0xFFFFFFF0",
            "sparFinish": "Black Stainless Steel",
            "sparDesign": "None",
            "deckEnclosure": "None",
            "bedAndLivingRoomEnclousure": "None",
            "power": "1000 Kw Solar Cells On Rack",
            "underWaterRoomFinishing": "Unfinished",
            "underWaterWindows": "1 Port Window",
            "masterBedroomInteriorWallColor": "0xffffffff",
            "livingRoomloorFinishing": "Carbon Fiber",
            "livingRoomInteriorWallColor": "0xffffffff",
            "kitchenfloorFinishing": "Carbon Fiber",
            "kitchenInteriorWallColor": "0xffffffff",
            "entryStairs": "false",
            "interiorBedroomWallColor": "0xffffffff",
            "deckFloorFinishMaterial": "Carbon Fiber",
            "seaPodStatus": "status",
            "users": [
                {
                    "isDisabled": false,
                    "lighting": {
                        "isOn": false,
                        "lightScenes": [
                            "5edd1160ab2ab00017d6c1d4"
                        ],
                        "_id": "5eca7c6c3b4ffb001774ee10"
                    },
                    "_id": "5eca7c6b3b4ffb001774ee0c",
                    "userName": "Asad Asad",
                    "profilePicUrl": "",
                    "type": "OWNER"
                }
            ],
            "location": {
                "latitude": 8.044911096017215,
                "longitude": -82.0058449282009
            },
            "vessleCode": "S0F7C6C",
            "qrCodeImageUrl": "https://undefined/qrcodes/S0F7C6C.png",
            "__v": 2,
            "user": {
                "isDisabled": false,
                "lighting": {
                    "isOn": false,
                    "lightScenes": [
                        "5edd1160ab2ab00017d6c1d4"
                    ],
                    "_id": "5eca7c6c3b4ffb001774ee10"
                },
                "_id": "5eca7c6b3b4ffb001774ee0c",
                "userName": "Asad Asad",
                "profilePicUrl": "",
                "notificationToken": "fluMksedKxY:APA91bFMdxZD7Ouwh0aiVWuDcLrzPfNMkU6WbH_zIjICm_57samvG3hLcsrcM9MkA45568IUWCnXI-7cBEMrI6NLtfqlauc8Wssa-xN5vXXFS2hb7mka0Y1RJ698YD6aFrdGXTk1eVCF",
                "type": "OWNER"
            },
            "data": {
                "insideTemperature": 23,
                "drinkingWaterPercentage": 74,
                "co2Percentage": 2,
                "movementAngle": 116,
                "frostWindowsPercentage": 42,
                "lowerStairsPercentage": 5,
                "solarBatteryPercentage": 27,
                "batteryPercentageWaterLeak": 11,
                "batteryPercentageFireDetectors": 8,
                "batteryPercentageC02": 15
            }
        }
    ],
    "lightiningScenes": [
        {
            "seapodId": null,
            "_id": "5edcf9aeab2ab00017d6c186",
            "userId": "5eca7c6b3b4ffb001774ee0c",
            "sceneName": "My scene 1",
            "rooms": [
                {
                    "moodes": [
                        {
                            "lightName": "Lightstrip 1",
                            "lightColor": "0xFF959B1B"
                        },
                        {
                            "lightName": "Lightstrip 2",
                            "lightColor": "0xFF1322FF"
                        },
                        {
                            "lightName": "Ligh 3",
                            "lightColor": "0xFFFF1EEE"
                        },
                        {
                            "lightName": "Counter 4",
                            "lightColor": "0xFFBE93"
                        },
                        {
                            "lightName": "Ocerhead 3",
                            "lightColor": "0xFFC1FFE5"
                        }
                    ],
                    "_id": "5edcf9aeab2ab00017d6c18a",
                    "label": "Bedroom"
                },
                {
                    "moodes": [
                        {
                            "lightName": "Lightstrip 1",
                            "lightColor": "0xFF959B1B"
                        },
                        {
                            "lightName": "Lightstrip 2",
                            "lightColor": "0xFF1322FF"
                        },
                        {
                            "lightName": "Ligh 3",
                            "lightColor": "0xFFFF1EEE"
                        },
                        {
                            "lightName": "Counter 4",
                            "lightColor": "0xFFBE93"
                        },
                        {
                            "lightName": "Ocerhead 3",
                            "lightColor": "0xFFC1FFE5"
                        }
                    ],
                    "_id": "5edcf9aeab2ab00017d6c189",
                    "label": "Livingroom"
                },
                {
                    "moodes": [
                        {
                            "lightName": "Lightstrip 1",
                            "lightColor": "0xFF959B1B"
                        },
                        {
                            "lightName": "Lightstrip 2",
                            "lightColor": "0xFF1322FF"
                        },
                        {
                            "lightName": "Ligh 3",
                            "lightColor": "0xFFFF1EEE"
                        },
                        {
                            "lightName": "Counter 4",
                            "lightColor": "0xFFBE93"
                        },
                        {
                            "lightName": "Ocerhead 3",
                            "lightColor": "0xFFC1FFE5"
                        }
                    ],
                    "_id": "5edcf9aeab2ab00017d6c188",
                    "label": "Kitchen"
                },
                {
                    "moodes": [
                        {
                            "lightName": "Lightstrip 1",
                            "lightColor": "0xFF959B1B"
                        },
                        {
                            "lightName": "Lightstrip 2",
                            "lightColor": "0xFF1322FF"
                        },
                        {
                            "lightName": "Ligh 3",
                            "lightColor": "0xFFFF1EEE"
                        },
                        {
                            "lightName": "Counter 4",
                            "lightColor": "0xFFBE93"
                        },
                        {
                            "lightName": "Ocerhead 3",
                            "lightColor": "0xFFC1FFE5"
                        }
                    ],
                    "_id": "5edcf9aeab2ab00017d6c187",
                    "label": "UnderWaterRoom"
                }
            ],
            "__v": 0
        }
    ],
    "isVerified": true,
    "accessRequests": [],
    "accessInvitation": [
        {
            "period": 0,
            "isRecived": true,
            "_id": "5eca83793b4ffb001774ee57",
            "user": {
                "_id": "5eca7c6b3b4ffb001774ee0c",
                "name": "Asad Asad",
                "imageUrl": "",
                "email": "asad@asad.com",
                "mobileNumber": "+8801717172695"
            },
            "seaPod": {
                "_id": "5eca7ab93b4ffb001774ee02",
                "name": "Night Life",
                "vessleCode": "S027AB9"
            },
            "type": "MEMBER",
            "status": "PENDING",
            "checkIn": 1590330233152,
            "__v": 0
        }
    ],
    "_id": "5eca7c6b3b4ffb001774ee0c",
    "firstName": "Asad",
    "lastName": "Asad",
    "email": "asad@asad.com",
    "mobileNumber": "+8801717172695",
    "country": "Bangladesh",
    "notifications": [
        {
            "seen": false,
            "priority": 0,
            "data": {
                "period": 604800000,
                "isRecived": true,
                "_id": "5ed2743235d4750017ca6eea",
                "user": {
                    "_id": "5eca7ab93b4ffb001774edff",
                    "name": "John  Doe",
                    "imageUrl": "",
                    "email": "skiplogin@oceanbuilders.com",
                    "mobileNumber": "+8801717172695"
                },
                "seaPod": {
                    "_id": "5eca7c6c3b4ffb001774ee0f",
                    "name": "Aqua Vita",
                    "vessleCode": "S0F7C6C"
                },
                "type": "GUEST",
                "status": "PENDING",
                "checkIn": 1593453600000,
                "__v": 0
            },
            "_id": "5ed2743335d4750017ca6eeb",
            "title": "John  Doe has requested access to your SeaPod Aqua Vita (S0F7C6C) for 7 DAYS starting on June 29, 2020",
            "message": "SEAPOD ACCESS REQUEST"
        },
        {
            "seen": false,
            "priority": 0,
            "data": {
                "period": 0,
                "isRecived": true,
                "_id": "5eca83793b4ffb001774ee57",
                "user": {
                    "_id": "5eca7c6b3b4ffb001774ee0c",
                    "name": "Asad Asad",
                    "imageUrl": "",
                    "email": "asad@asad.com",
                    "mobileNumber": "+8801717172695"
                },
                "seaPod": {
                    "_id": "5eca7ab93b4ffb001774ee02",
                    "name": "Night Life",
                    "vessleCode": "S027AB9"
                },
                "type": "MEMBER",
                "status": "PENDING",
                "checkIn": 1590330233152
            },
            "_id": "5eca83793b4ffb001774ee58",
            "title": "You are invited to join a sea pod (Night Life) as a Member",
            "message": "SEAPOD ACCESS INVITATION"
        }
    ],
    "emergencyContacts": [],
    "__v": 7
}


*/

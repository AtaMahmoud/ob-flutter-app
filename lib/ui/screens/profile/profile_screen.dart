import 'dart:io';
import 'package:ocean_builder/bloc/profile_edit_bloc.dart';
import 'package:ocean_builder/core/models/emergency_contact.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/ui/shared/shared_pref_data.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocean_builder/bloc/registration_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/models/user_ocean_builder.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_profile.dart';
import 'package:ocean_builder/ui/cleeper_ui/clipper_profile_emergency_dropdown.dart';
import 'package:ocean_builder/ui/cleeper_ui/clipper_profile_ob_dropdown.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _profileImageFile;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserProvider _userProvider;
  User _user;
  RegistrationValidationBloc _bloc = RegistrationValidationBloc();

  ProfileEditBloc _editBloc = ProfileEditBloc();

  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;

  FocusNode _firstNameNode = FocusNode();
  FocusNode _lastNameNode = FocusNode();
  FocusNode _phoneNode = FocusNode();
  FocusNode _emailNode = FocusNode();

  ScrollController _scrollController;

  SelectedOBIdProvider _selectedOBIdProvider;

  bool isEmergencyContactNull = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      _userProvider.autoLogin();
    });
    UIHelper.setStatusBarColor();
    _scrollController = ScrollController();
    _editBloc.profileInfoChanged(false);
    _editBloc.emergencyInfoChanged(false);
    _getProfilePicture();
    _setUserDataListener();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    ProfileEditState.profileInfoChanged = false;
    ProfileEditState.emergencyContactInfoChanged = false;
    _bloc.dispose();
    _editBloc.dispose();
    super.dispose();
  }

  _setUserDataListener() {
    _bloc.firstNameController.listen((onData) {
      if (_user.firstName.compareTo(onData) != 0 &&
          onData != null &&
          onData.length >= 3) {
        _editBloc.profileInfoChanged(true);
        _user.firstName = onData;
      } else {
        // _editBloc.profileInfoChanged(false);
      }
    });

    _bloc.lastNameController.listen((onData) {
      if (_user.lastName.compareTo(onData) != 0 &&
          onData != null &&
          onData.length >= 3) {
        _editBloc.profileInfoChanged(true);
        _user.lastName = onData;
      } else {
        // _editBloc.profileInfoChanged(false);
      }
    });

    _bloc.emailController.listen((onData) {
      if (_user.email.compareTo(onData) != 0 &&
          onData != null &&
          onData.length >= 3) {
        _editBloc.profileInfoChanged(true);
        _user.email = onData;
      } else {
        // _editBloc.profileInfoChanged(false);
      }
    });

    _bloc.phoneController.listen((onData) {
      if (_user.phone.compareTo(onData) != 0 &&
          onData != null &&
          onData.length >= 13) {
        _editBloc.profileInfoChanged(true);
        _user.phone = onData;
      } else {
        // _editBloc.profileInfoChanged(false);
      }
    });

    _editBloc.profileInfoEditController.listen((isChanged) {
      print('profileInfoEditController  state -- $isChanged ');
      if (isChanged) {
        ProfileEditState.profileInfoChanged = true;
      } else {
        ProfileEditState.profileInfoChanged = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'Building Profile screen ----- dashBoardBuildCount ${GlobalContext.dashBoardBuildCount}');
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);
    GlobalContext.currentScreenContext = context;
    _userProvider = Provider.of<UserProvider>(context);
    _user = _userProvider.authenticatedUser;
    if (_user == null) {
      return Container();
    }
    _firstNameController = TextEditingController(text: _user.firstName);
    _lastNameController = TextEditingController(text: _user.lastName);
    _emailController = TextEditingController(text: _user.email);
    _phoneController = TextEditingController(text: _user.phone);

    _bloc.firstNameChanged(_user.firstName);
    _bloc.lastNameChanged(_user.lastName);
    _bloc.emailChanged(_user.email);
    _bloc.phoneChanged(_user.phone);
    // _editBloc.profileInfoChanged(false);

    if (_user.emergencyContacts != null && _user.emergencyContacts.length > 0) {
      _user.emergencyContact = _user.emergencyContacts[0];
    }

    if (_user.emergencyContact == null) {
      isEmergencyContactNull = true;
      _user.emergencyContact = new EmergencyContact();
    } else if (_user.emergencyContact.id != null) {
      isEmergencyContactNull = false;
    }

    return _mainContainer(); //customDrawer(_innerDrawerKey, _mainContainer());
  }

  _mainContainer() {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: HomeDrawer(
          isSecondLevel: true,
          screenIndex: DrawerIndex.PROFILE,
        ),
        drawerScrimColor: AppTheme.drawerScrimColor.withOpacity(.65),
        body: _body(),
      ),
    );
  }

  Stack _body() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(gradient: profileGradient),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              _startSpace(),
              SliverPadding(
                padding: EdgeInsets.only(
                  top: 8.h,
                  bottom: 128.h,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buttonHamburgerMenu(),
                      _profilePicture(),
                      SpaceH64(),
                      _inputFirstName(),
                      SizedBox(height: 120.h),
                      _inputLastName(),
                      SizedBox(height: 120.h),
                      _inputPhone(),
                      SizedBox(height: 120.h),
                      _inputEmail(),
                      SizedBox(height: 60.h),
                      _dropdownSeaPod(),
                      _emergencyContactDetails(),
                      // SizedBox(height: util.setHeight(175)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _userProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(),
        _bottomBar()
      ],
    );
  }

  Positioned _bottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: bottomBarButtons(),
    );
  }

  Container _emergencyContactDetails() {
    return Container(
      transform: Matrix4.translationValues(0.0, -175.h, 0.0), // 192 + 64
      child: ClipperProfileEmergencyDropdown(
          TextFieldHints.MY_EMERGENCY_CONTACT,
          ColorConstants.PROFILE_BKG_2,
          _scrollController,
          _editBloc,
          _user),
    );
  }

  ClipperProfileOBDropdown _dropdownSeaPod() {
    return ClipperProfileOBDropdown(TextFieldHints.OCEAN_BUILDER_ACCESS,
        getList(), ColorConstants.PROFILE_BKG_1, _scrollController);
  }

  Widget _inputEmail() {
    return UIHelper.getProfileOBUnit(
        context,
        TextFieldHints.PROFILE_EMAIL,
        _bloc.email,
        _bloc.emailChanged,
        _emailController,
        InputTypes.EMAIL,
        true,
        _emailNode,
        null);
  }

  Widget _inputPhone() {
    return UIHelper.getProfileOBUnitPhone(
        context,
        TextFieldHints.PHONE,
        _bloc.phone,
        _bloc.phoneChanged,
        _phoneController,
        InputTypes.PHONE,
        true,
        _phoneNode,
        _emailNode);
  }

  Widget _inputLastName() {
    return UIHelper.getProfileOBUnit(
      context,
      TextFieldHints.PROFILE_LAST_NAME,
      _bloc.lastName,
      _bloc.lastNameChanged,
      _lastNameController,
      null,
      true,
      _lastNameNode,
      _phoneNode,
      maxLength: 30,
    );
  }

  Widget _inputFirstName() {
    return UIHelper.getProfileOBUnit(
      context,
      TextFieldHints.PROFILE_FIRST_NAME,
      _bloc.firstName,
      _bloc.firstNameChanged,
      _firstNameController,
      null,
      true,
      _firstNameNode,
      _lastNameNode,
      maxLength: 30,
    );
  }

  CircleAvatar _profilePicture() {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 196.w,
      child: InkWell(
        onTap: () {
          _pickProfilePicture();
        },
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: _profileImageFile != null ? 196.w : 128.w,
          backgroundImage: _profileImageFile != null
              ? FileImage(
                  _profileImageFile,
                )
              : AssetImage(
                  ImagePaths.icAvatar,
                ),
        ),
      ),
    );
  }

  Padding _buttonHamburgerMenu() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              _scaffoldKey.currentState.openDrawer();
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                32.h,
                32.w,
                32.h,
              ),
              child: ImageIcon(
                AssetImage(ImagePaths.icHamburger),
                size: 50.w,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  _startSpace() => UIHelper.getTopEmptyContainer(64.h, false);

  Widget bottomBarButtons() {
    return StreamBuilder<bool>(
      stream: _editBloc.emergencyInfoCheck,
      builder: (context, snapshot) {
        debugPrint(
            'emergencyInfoCheck snapshot --------  data ----- ${snapshot.data} ');
        return BottomClipperProfile(
            ButtonText.BACK,
            ButtonText.SAVE,
            !snapshot.hasData || !snapshot.data,
            () => _goBack(),
            () => _save());
      },
    );
  }

  List<UserOceanBuilder> getList() {
    List<UserOceanBuilder> userOBList = [];
    _user.userOceanBuilder.map((f) {
      if (f.reqStatus.compareTo(NotificationConstants.canceled) != 0) {
        userOBList.add(f);
      }
    }).toList();
    return userOBList;
  }

  _goBack() {
    GlobalContext.dashBoardBuildCount = 0;
    if (!(_selectedOBIdProvider.selectedObId
            .compareTo(AppStrings.selectOceanBuilder) ==
        0)) {
      Navigator.pop(context);
    }
  }

  _save() async {
    FocusScope.of(context).unfocus();

    // extracting only the changed or existing emergency contact information

    // EmergencyContact changedEmergencyCotnact = _user.emergencyContact;

    // checking if both user contact and emergenct contact get updated
    if (ProfileEditState.profileInfoChanged &&
        ProfileEditState.emergencyContactInfoChanged) {
      // debugPrint('Updating Profile data and emergency contacts ----------------------------------------------------------------------------------');

      if (!_userProvider.isLoading) {
        // first update user data then update/add emergenct contact
        _userProvider.updateUserProfile(_user).then((responseStatus) {
          if (responseStatus.status == 200) {
            // _userProvider.autoLogin();
            // showInfoBar(
            //     'Profile Updated', 'Profile information updated', context);
            ProfileEditState.profileInfoChanged = false;
            if (isEmergencyContactNull) {
              // debugPrint('emergency contact is null add it ');
              _addEmergencyContact();
            } else {
              _updateEmergencyContact();
            }
          } else {
            showInfoBar(parseErrorTitle(responseStatus.code),
                responseStatus.message, context);
          }
        });
      }
    } else if (ProfileEditState.profileInfoChanged) {
      // debugPrint('Updating Profile data  ----------------------------------------------------------------------------------');
      if (!_userProvider.isLoading) {
        _updateUserData();
      }
    } else if (ProfileEditState.emergencyContactInfoChanged) {
      // debugPrint('Updating emergency contacts ------------------- ---------------------------------------------------------------');
      // debugPrint('----------------------  $isEmergencyContactNull --------------------------------------------');
      if (isEmergencyContactNull) {
        // debugPrint('emergency contact is null add it ');
        // debugPrint(
        //     'emeregency contact -------- ${changedEmergencyCotnact.toJson()}');
        // _user.emergencyContact = changedEmergencyCotnact;
        _addEmergencyContact();
      } else if (!_userProvider.isLoading) {
        _updateEmergencyContact();
      }
    }
  }

  void _updateUserData() {
    _userProvider.updateUserProfile(_user).then((responseStatus) {
      if (responseStatus.status == 200) {
        ProfileEditState.profileInfoChanged = false;
        _userProvider.autoLogin();
        showInfoBar('Profile Updated', 'Profile information updated', context);
        // print(_userProvider.authenticatedUser.emergencyContact
        // .toJson()
        // .toString());
      } else {
        showInfoBar(parseErrorTitle(responseStatus.code),
            responseStatus.message, context);
      }
    });
  }

  void _updateEmergencyContact() {
    _userProvider.updateEmergencyContact(_user).then((responseStatus) {
      if (responseStatus.status == 200) {
        ProfileEditState.emergencyContactInfoChanged = false;
        _userProvider.autoLogin();
        showInfoBar('Profile Updated', 'Profile information updated', context);
        // print(_userProvider.authenticatedUser.emergencyContact
        // .toJson()
        // .toString());
      } else {
        showInfoBar(parseErrorTitle(responseStatus.code),
            responseStatus.message, context);
      }
    });
  }

  void _addEmergencyContact() {
    if (_user.emergencyContact.firstName != null &&
        _user.emergencyContact.lastName != null &&
        _user.emergencyContact.email != null &&
        _user.phone != null) {
      if (!_userProvider.isLoading) {
        _userProvider.addEmergencyContact(_user).then((responseStatus) {
          if (responseStatus.status == 200) {
            isEmergencyContactNull = false;
            ProfileEditState.emergencyContactInfoChanged = false;
            _userProvider.autoLogin();
            showInfoBar(
                'Profile Updated', 'Profile information updated', context);
            // print(_userProvider.authenticatedUser.emergencyContact
            // .toJson()
            // .toString());
          } else {
            showInfoBar(parseErrorTitle(responseStatus.code),
                responseStatus.message, context);
          }
        });
      }
    } else {
      showInfoBar('All Fields Required',
          'Please fill all the fields of emergency contact', context);
    }
  }

  _getProfilePicture() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String path = prefs.getString(SharedPreferanceKeys.KEY_PROFILE_PIC);

    String path = await SharedPrefHelper.getProfilePicFilePath();

    if (path != null) {
      final File imageFile = File(path);
      if (await imageFile.exists()) {
        // Use the cached images if it exists
        setState(() {
          _profileImageFile = imageFile;
        });
      }
    }
  }

  _pickProfilePicture() async {
    double radius = 512.w;
    // Step 1: Retrieve image from picker
    final PickedFile image =
        await ImagePicker().getImage(source: ImageSource.gallery);
// Step 2: Check for valid file
    if (image == null) return;
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(image.path);
    File compressedFile = await FlutterNativeImage.compressImage(image.path,
        quality: 80,
        targetWidth: radius.toInt(),
        targetHeight:
            (properties.height * radius.toInt() / properties.width).round());

// Step 3: Get directory where we can duplicate selected file.
    final Directory temp = await getApplicationDocumentsDirectory();
    final String path = temp.path;

// Step 4: Copy the file to a application document directory.
    final fileName = p.basename(compressedFile.path);
    final File localImage = await compressedFile.copy('$path/$fileName');

// Step 1: Save image/file path as string either db or shared pref
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString(SharedPreferanceKeys.KEY_PROFILE_PIC, localImage.path);

    SharedPrefHelper.setProfilePicFilePath(localImage.path);
    setState(() {
      _profileImageFile = localImage;
    });
  }
}

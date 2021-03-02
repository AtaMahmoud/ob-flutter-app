import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/bloc/grant_access_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/permission.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/permission/custom_permission_screen.dart';
import 'package:ocean_builder/ui/shared/drop_downs.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rxdart/rxdart.dart';

class GrantAccessScreenWidget extends StatefulWidget {
  static const String routeName = '/grantAccessScreenWidget';
  final bool showOnlyAccessRequests;
  final bool showOnlyUnreadNotifications;

  GrantAccessScreenWidget(
      {this.showOnlyAccessRequests = false,
      this.showOnlyUnreadNotifications = false});

  @override
  _GrantAccessScreenWidgetState createState() =>
      _GrantAccessScreenWidgetState();
}

class _GrantAccessScreenWidgetState extends State<GrantAccessScreenWidget> {
  bool _updatingNotification = false;

  GrantAccessValidationBloc _bloc = GrantAccessValidationBloc();
  User _user;

  TextEditingController _firstNameController;
  TextEditingController _emailController;
  TextEditingController _messageController;

  FocusNode _firstNameNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _messageNode = FocusNode();

  DateTime _pickedDate; //  = DateTime.now();
  bool _isMemberSelected = false;

  String _selectedObName;

  UserProvider _userProvider;

  OceanBuilderInfo _selectedObInfo;

  User _sender;
  User _reciever;

  String permissionSet;
  String _message;

  List<PermissionSet> _selectedPermissionSet;

  @override
  void initState() {
    super.initState();
    UIHelper.setStatusBarColor();
    _firstNameController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _messageController = TextEditingController(text: '');
    _sender = User();
    _reciever = User();
    _setUserDataListener();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  _setUserDataListener() {
    _bloc.firstNameController.listen((onData) {
      _reciever.firstName = onData;
    });

    _bloc.emailController.listen((onData) {
      _reciever.email = onData;
    });

    //-----
    _bloc.requestAccessAsController.listen((onData) {
      print('acces type --- $onData');
      if (onData.compareTo(ListHelper.getGrantAccessAsList()[3]) == 0) {
        _reciever.userType = ListHelper.getAccessAsList()[1];
        _setPermissionsDropdownValue(_reciever.userType);

        if (!_isMemberSelected)
          setState(() {
            _isMemberSelected = true;
            _reciever.requestAccessTime = ListHelper.getAccessTimeList()[9];
          });
      } else if (onData.compareTo(ListHelper.getGrantAccessAsList()[2]) == 0) {
        _reciever.userType = ListHelper.getAccessAsList()[2];
        _setPermissionsDropdownValue(_reciever.userType);
        if (_isMemberSelected)
          setState(() {
            _isMemberSelected = false;
            _reciever.requestAccessTime = ListHelper.getAccessTimeList()[1];
          });
      } else if (onData.compareTo(ListHelper.getGrantAccessAsList()[1]) == 0) {
        _reciever.userType = ListHelper.getAccessAsList()[3];
        _setPermissionsDropdownValue(_reciever.userType);
        if (_isMemberSelected)
          setState(() {
            _isMemberSelected = false;
            _reciever.requestAccessTime = ListHelper.getAccessTimeList()[1];
          });
      }
    });

    _bloc.vasselCodeController.listen((onData) {
      _selectedObName = onData;
      _selectedObInfo = _getSelectedObInfo();
      _getPermissionListOfSeapod();
    });

    _bloc.requestAccessTimeController.listen((onData) {
      _reciever.requestAccessTime = onData;
    });

    _bloc.permissionController.listen((onData) {
      permissionSet = onData;
    });

    _bloc.messageController.listen((msg) {
      _message = msg;
    });

    //-----
  }

  void _setPermissionsDropdownValue(String onData) {
    String permissionSetName = _findPermissionSetName(onData);
    if (permissionSetName.length > 1) {
      _bloc.permissionChanged(permissionSetName);
    } else {
      _bloc.permissionChanged('Grant permissions');
    }
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);

    _selectedPermissionSet =
        _userProvider.authenticatedUser.seaPods[0].permissionSets;
    print(_selectedPermissionSet.map((permission) {
      return permission.permissionSetName;
    }).toList());
    _user = _userProvider.authenticatedUser;
    return Stack(
      children: [
        Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: BoxDecoration(

                // gradient: profileGradient,

                color: Colors.white,
                borderRadius: BorderRadius.circular(8)),
            child: CustomScrollView(
              slivers: <Widget>[
                // UIHelper.getTopEmptyContainer(

                //     MediaQuery.of(context).size.height / 16, false),

                UIHelper.defaultSliverAppbar(null, goBack,
                    screnTitle: 'Grant new access', isDrawer: false),

                SliverPadding(
                  padding: EdgeInsets.only(
                      top: 8.h,

                      // bottom: _util.setHeight(128),

                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _headerTitle(),

                        _firstNameField(context),

                        SpaceH64(),

                        _emailField(context),

                        SpaceH64(),

                        _seaPodDropdown(),

                        SpaceH32(),

                        _accessTypeDropdown(),

                        SpaceH32(),

                        _permissionSetRow(),

                        SpaceH32(),

                        _customPermissionsRow(),

                        SpaceH32(),

                        checkInDatePicker(),

                        // _isMemberSelected ? Container() : SpaceH32(),

                        // _isMemberSelected ? Container() : _accessTimeDropdown(),

                        SpaceH32(),

                        _messageContainer(),

                        SpaceH32(),

                        _sendInvitationButton(context),

                        SpaceH32(),
                      ],
                    ),
                  ),
                ),

                UIHelper.getTopEmptyContainer(90, false),
              ],
            )

            // ),

            ),
        _userProvider.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container()
      ],
    );
  }

  Container _sendInvitationButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      margin: EdgeInsets.symmetric(horizontal: 32.w),
      child: DialogButton(
        child: Text(
          'Send invitation',
          style: TextStyle(color: Colors.white, fontSize: 36.sp),
        ),
        onPressed: () {
          // Navigator.of(context).pop();
          if (permissionSet != null &&
              _reciever.email != null &&
              _reciever.firstName != null &&
              _reciever.userType != null &&
              _reciever.checkInDate != null)
            _showConfirmGrantAccessDialog();
          else
            showInfoBar('Fill all the fields',
                'Please fill all the fields to continue', context);
          // _showDeleteGrantAccessDialog();
        },
        color: ColorConstants.ACCESS_MANAGEMENT_BUTTON,
        radius: BorderRadius.circular(72.w),
      ),
    );
  }

  Widget _accessTimeDropdown() {
    return getDropdown(
      ListHelper.getGrantAccessTimeList().sublist(0, 9),
      _bloc.requestAccessTime,
      _bloc.requestAccessTimeChanged,
      true,
      label: 'Access for',
    );
  }

  Widget _accessTypeDropdown() {
    return getDropdown(ListHelper.getGrantAccessAsList(), _bloc.requestAccessAs,
        _bloc.requestAccessAsChanged, true,
        label: 'Access type');
  }

  Widget _seaPodDropdown() {
    return getDropdown(
        getSeaPodList(), _bloc.vasselCode, _bloc.vasselCodeChanged, true,
        label: 'SeaPods');
  }

  Widget _emailField(BuildContext context) {
    return _getEditTextUnit(
      context,
      TextFieldHints.EMAIL_ADDRESS,
      _bloc.email,
      _bloc.emailChanged,
      _emailController,
      null,
      true,
      _emailNode,
      null,
      maxLength: 30,
    );
  }

  Widget _firstNameField(BuildContext context) {
    return _getEditTextUnit(
      context,
      TextFieldHints.NAME,
      _bloc.firstName,
      _bloc.firstNameChanged,
      _firstNameController,
      null,
      true,
      _firstNameNode,
      _emailNode,
      maxLength: 30,
    );
  }

  Container _headerTitle() {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 12.0),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.w),
      child: Text(
        'This will send an invitation that has to be accepted by the recipient',
        style: TextStyle(
            color: ColorConstants.ACCESS_MANAGEMENT_SUBTITLE,
            fontWeight: FontWeight.w400,
            fontSize: 48.sp),
      ),
    );
  }

  List<String> getSeaPodList() {
    List<String> seapodList = [];
    _user.userOceanBuilder.map((ob) {
      // debugPrint('ob type --- ${ob.userType}');
      if (ob.userType.toLowerCase().compareTo('owner') == 0) {
        seapodList.add(ob.oceanBuilderName);
      }
    }).toList();
    return seapodList;
  }

  Widget _messageContainer() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 48.w),
        child: TextField(
          autofocus: false,
          controller: _messageController,
          onChanged: _bloc.messageChanged,
          keyboardType: null,
          keyboardAppearance: Brightness.light,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.top,
          scrollPadding: EdgeInsets.only(bottom: 100, top: 32.h),
          textInputAction: TextInputAction.done,
          focusNode: _messageNode,
          onEditingComplete: () => FocusScope.of(context).unfocus(),
          maxLines: 6,
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                    width: 1),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                    width: 1),
              ),
              labelText: 'Message (Optional)',
              labelStyle: TextStyle(
                  color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                  fontSize: 40.sp),
              contentPadding: EdgeInsets.only(left: 48.w, top: 48.h)),
          style: TextStyle(
            fontSize: 36.sp,
            fontWeight: FontWeight.w400,
            color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
          ),
          inputFormatters: [
            new LengthLimitingTextInputFormatter(300),
          ],
        ));
  }

  Widget _getEditTextUnit(
      BuildContext context,
      String title,
      Observable<String> stream,
      changed,
      TextEditingController controller,
      TextInputType inputType,
      bool includePadding,
      FocusNode node,
      FocusNode nextNode,
      {maxLength = 50}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 48.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title,
                  style: TextStyle(
                      color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                      fontSize: 40.sp)),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  autofocus: false,
                  controller: controller,
                  onChanged: changed,
                  keyboardType: inputType,
                  keyboardAppearance: Brightness.light,
                  textAlign: TextAlign.end,
                  scrollPadding: EdgeInsets.only(bottom: 100),
                  textInputAction: nextNode != null
                      ? TextInputAction.next
                      : TextInputAction.done,
                  focusNode: node,
                  onEditingComplete: () => nextNode != null
                      ? FocusScope.of(context).requestFocus(nextNode)
                      : FocusScope.of(context).unfocus(),
                  decoration: InputDecoration.collapsed(hintText: null),
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                  ),
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(maxLength),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            width: MediaQuery.of(context).size.width - 54,
            height: 1,
            color: ColorConstants.ACCESS_MANAGEMENT_SUBTITLE,
          )
        ],
      ),
    );
  }

  Widget checkInDatePicker() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: SizedBox(
        width: double.maxFinite,
        child: InkWell(
          onTap: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime.now(), //DateTime(2018, 3, 5),
                // maxTime: DateTime(2019, 12, 7),
                theme: DatePickerTheme(
                    backgroundColor:
                        Colors.white, //ColorConstants.PROFILE_BKG_1,
                    // containerHeight: ScreenUtil().setHeight(512),
                    cancelStyle: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.TOP_CLIPPER_START),
                    itemStyle: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.TOP_CLIPPER_START),
                    doneStyle: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.TOP_CLIPPER_START)),
                onChanged: (date) {
              // // print('change $date in time zone ' +
              // date.timeZoneOffset.inHours.toString());
            }, onConfirm: (date) {
              // print('confirm $date');
              setState(() {
                _pickedDate = date;
                _reciever.checkInDate = date;
                _bloc.checkInChanged(DateFormat('yMMMMd').format(_pickedDate));
              });
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.w),
                borderSide: BorderSide(
                    color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                    width: 1),
              ),
              contentPadding: EdgeInsets.only(
                top: 16.h,
                bottom: 16.h,
                left: 48.w,
                // right: 32.w
              ),
              labelText: 'Access from',
              // hintStyle: TextStyle(color: Colors.red),
              labelStyle: TextStyle(
                  color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                  fontSize: 48.sp),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    _pickedDate == null
                        ? 'Tap to change'
                        : DateFormat('yMd').format(_pickedDate),
                    style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w400,
                        color: _pickedDate == null
                            ? ColorConstants.ACCESS_MANAGEMENT_SUBTITLE
                            : ColorConstants.ACCESS_MANAGEMENT_TITLE),
                  ),
                  Icon(Icons.arrow_drop_down,
                      size: 96.w,
                      color: _pickedDate == null
                          ? ColorConstants.ACCESS_MANAGEMENT_SUBTITLE
                          : ColorConstants
                              .ACCESS_MANAGEMENT_TITLE //ColorConstants.INVALID_TEXTFIELD,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  goBack() {
    Navigator.of(context).pop();
  }

  goNext() {
    // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  // ------------ grant access Alert -----------------------------
  _showConfirmGrantAccessDialog() async {
    var alertStyle = AlertStyle(
      titleStyle: TextStyle(
          color: ColorConstants.TOP_CLIPPER_START,
          fontWeight: FontWeight.normal,
          fontSize: 2),
      isOverlayTapDismiss: true,
      isCloseButton: false,
    );
    Alert(
        context: context,
        title: '', //'Grant new access',
        style: alertStyle,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                bottom: 32.h,
              ),
              child: Text(
                'Grant new access',
                style: TextStyle(
                    color: ColorConstants.COLOR_NOTIFICATION_TITLE,
                    fontWeight: FontWeight.w400,
                    fontSize: 60.sp),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 64.h,
              ),
              child: Text(
                'You are about to share ownership of the SeaPod $_selectedObName, giving this person full control of your home.\n\n\nPlease confirm that you really want to share ownership.',
                style: TextStyle(
                    color: ColorConstants.ACCESS_MANAGEMENT_SUBTITLE,
                    fontWeight: FontWeight.w400,
                    fontSize: 48.sp),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        'CANCEL',
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(48.w),
                          side: BorderSide(
                            color:
                                ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                          )),
                      textColor: Colors.white,
                      color: ColorConstants
                          .ACCESS_MANAGEMENT_BUTTON //ColorConstants.TOP_CLIPPER_END
                      ),
                ),
                SizedBox(
                  width: 24.w,
                ),
                Expanded(
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        _sendInvitationToUser();
                      },
                      child: Text('CONFIRM'),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(48.w),
                          side: BorderSide(
                            color:
                                ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                          )),
                      textColor: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                      color: Colors.white),
                )
              ],
            )
          ],
        ),
        buttons: []).show();
  }

  _sendInvitationToUser() async {
    _sender = _userProvider.authenticatedUser;
    String permissionSetId = _getPermissionSetId(permissionSet);
    _userProvider
        .sendInvitation(
            _reciever, _selectedObInfo.documentId, permissionSetId, _message)
        .then((responseStatus) {
      if (responseStatus.status == 200) {
        Navigator.of(context).pop();
        showInfoBar(
            'Invitation sent',
            'Access invitation has been sent to "${_reciever.email}"',
            GlobalContext.currentScreenContext);
      } else {
        // Navigator.of(context).pop();
        showInfoBar(parseErrorTitle(responseStatus.code),
            responseStatus.message, context);
      }
    });
  }

  OceanBuilderInfo _getSelectedObInfo() {
    OceanBuilderInfo obInfo = OceanBuilderInfo();
    _user.userOceanBuilder.map((ob) {
      if (_selectedObName.compareTo(ob.oceanBuilderName) == 0) {
        obInfo.documentId = ob.oceanBuilderId;
        obInfo.obName = ob.oceanBuilderName;
        obInfo.vesselCode = MethodHelper.getVesselCode(ob.oceanBuilderId);
      }
    }).toList();

    return obInfo;
  }

  _getPermissionListOfSeapod() {
    SeaPod _seaPod;
    _userProvider.authenticatedUser.seaPods.map((f) {
      if (f.obName.compareTo(_selectedObName) == 0) {
        _seaPod = f;
      }
    }).toList();
    _selectedPermissionSet = _seaPod.permissionSets;
  }

  _customPermissionsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              PermissionSet ps = TempPermissionData.permissionSet;
              ps.permissionSetName = permissionSet;
              Navigator.of(context)
                  .pushNamed(CustomPermissionScreen.routeName, arguments: ps);
            },
            child: Row(
              children: <Widget>[
                SvgPicture.asset(ImagePaths.svgEdit),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  'CUSTOM PERMISSIONS',
                  style: TextStyle(
                      fontSize: 48.sp,
                      color: ColorConstants.COLOR_NOTIFICATION_ITEM),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _permissionSetRow() {
    List<String> list = [];
    list.add('Grant permissions');
    list.addAll(_selectedPermissionSet.map((permission) {
      return permission.permissionSetName;
    }).toList());
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: getDropdown(
                list, _bloc.permission, _bloc.permissionChanged, false,
                label: 'Permissions'),
          )
        ],
      ),
    );
  }

  String _getPermissionSetId(String permissionSet) {
    String _id;
    _selectedPermissionSet.map((p) {
      if (p.permissionSetName.compareTo(permissionSet) == 0) {
        _id = p.id;
      }
    }).toList();
    return _id;
  }

  String _findPermissionSetName(String onData) {
    String defaultPermissionName = '';
    for (var i = 0; i < _selectedPermissionSet.length; i++) {
      PermissionSet ps = _selectedPermissionSet[i];
      if (ps.permissionSetName.contains(onData) &&
          ps.permissionSetName.contains('Default')) {
        defaultPermissionName = ps.permissionSetName;
      }
    }
    print(defaultPermissionName);
    return defaultPermissionName;
  }
}

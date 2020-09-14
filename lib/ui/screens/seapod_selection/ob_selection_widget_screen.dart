import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/registration_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user_ocean_builder.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/cleeper_ui/pending_request_list.dart';
import 'package:ocean_builder/ui/screens/accessManagement/ob_events_screen.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/shared/shared_pref_data.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OBSelectionScreenWidgetModal extends StatefulWidget {
  static const String routeName = '/obSelectionScreenWidgetModal';

  @override
  _OBSelectionScreenWidgetModalState createState() =>
      _OBSelectionScreenWidgetModalState();
}

class _OBSelectionScreenWidgetModalState
    extends State<OBSelectionScreenWidgetModal> {
  OceanBuilderProvider _oceanBuilderProvider;
  UserProvider _cancelUserProvider;
  UserOceanBuilder _cancelUserOceanBuilder;
  RegistrationValidationBloc _bloc = RegistrationValidationBloc();
  FocusNode _obNameNode = FocusNode();
  TextEditingController _obNameController;
  String _changedObName = 'defaultName';

  Flushbar _flush;

  String _currentlySelectedObId;

  UserProvider userProvider;

  @override
  void initState() {
    UIHelper.setStatusBarColor(color: ColorConstants.MODAL_BKG);
    super.initState();

    Future.delayed(Duration.zero).then((_) {
      userProvider.autoLogin().then((onValue) async {
        await MethodHelper.selectOnlyOBasSelectedOB();
      });
    });

    _obNameController = TextEditingController(text: '');
    _bloc.firstNameController.listen((onData) {
      _changedObName = onData;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _obNameController.dispose();
    _obNameNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    userProvider = Provider.of<UserProvider>(context);
    _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);

    // debugPrint('ob_selection_widget_screen ------  ${userProvider?.authenticatedUser?.seaPods?.length}');

    SelectedOBIdProvider selectedOBIdProvider =
        Provider.of<SelectedOBIdProvider>(context);

    _currentlySelectedObId = selectedOBIdProvider.selectedObId;
    // debugPrint('_currentlySelectedObId   $_currentlySelectedObId');

    ScreenUtil _util = ScreenUtil();
    List<UserOceanBuilder> pendigOceanBuilderList = [];
    List<UserOceanBuilder> myOceanBuilderList = [];

    int len = userProvider?.authenticatedUser?.userOceanBuilder?.length ?? 0;
    if (len > 0) {
      pendigOceanBuilderList = new List<UserOceanBuilder>.from(
          userProvider?.authenticatedUser?.userOceanBuilder);
      pendigOceanBuilderList.retainWhere((uob) {
        return uob.reqStatus != null &&
            uob.reqStatus.contains(NotificationConstants.initiated) &&
            !uob.userType.toLowerCase().contains('owner');
      });

      myOceanBuilderList = new List<UserOceanBuilder>.from(
          userProvider?.authenticatedUser?.userOceanBuilder);
      myOceanBuilderList.retainWhere((uob) {
        return uob.reqStatus == null ||
            !uob.reqStatus.contains(NotificationConstants.initiated);
      });
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: ColorConstants.MODAL_BKG.withOpacity(.95),
            borderRadius: BorderRadius.circular(8)),
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                UIHelper.getTopEmptyContainer(
                    MediaQuery.of(context).size.height / 16, false),
                SliverToBoxAdapter(
                  child: Container(
                    // color: ColorConstants.MODAL_BKG.withOpacity(.375),
                    padding: EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Select A Home',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: _util.setSp(64)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: _util.setHeight(48)),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      InkWell(
                        onTap: () {
                          // Navigator.of(context)
                          //     .pushNamed(DesignScreen.routeName);
                          showAddOBDialog(userProvider, context);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 4.0),
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          decoration: UIHelper.customDecoration(
                              2, 4, ColorConstants.BCKG_COLOR_START),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add,
                                color: ColorConstants.MODAL_ICON_COLOR,
                              ),
                              Text('DESIGN/REQUEST ACCESS',
                                  style: TextStyle(
                                      color: ColorConstants.TOP_CLIPPER_END)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _util.setHeight(24),
                      ),
                      pendigOceanBuilderList.length > 0
                          ? PendingRequestList(ColorConstants.PROFILE_BKG_1)
                          : Container(),
                    ]),
                  ),
                ),
                // SliverToBoxAdapter(
                //   child:
                // ),
                len > 0
                    ? SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: ScreenUtil().setWidth(512),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: .60,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            UserOceanBuilder uob = myOceanBuilderList[index];
                            // String vesselCode = MethodHelper.getVesselCode(
                            //     uob.oceanBuilderId);
                            String obName = uob.oceanBuilderName;
                            String userType = uob.userType;
                            String reqStatus = uob.reqStatus;
                            String uobId = uob.oceanBuilderId;

                            // debugPrint('----------uobId--------$uobId ----------_currentlySelectedObId---------------$_currentlySelectedObId');

                            return InkWell(
                              onTap: () {
                                if (reqStatus != null &&
                                    reqStatus.contains(
                                        NotificationConstants.initiated)) {
                                  _showCancelAlert(
                                      userProvider,
                                      userProvider.authenticatedUser
                                          .userOceanBuilder[index]);
                                } else {
                                  // // debugPrint('selected OB name ${myOceanBuilderList[index].oceanBuilderName} and code ${myOceanBuilderList[index].oceanBuilderId}');
                                  _currentlySelectedObId =
                                      myOceanBuilderList[index].oceanBuilderId;
                                  selectedOBIdProvider.selectedObId =
                                      _currentlySelectedObId;
                                  SharedPrefHelper.setCurrentOB(
                                      myOceanBuilderList[index].oceanBuilderId);
                                  UIHelper.setStatusBarColor(
                                      color: ColorConstants
                                          .TOP_CLIPPER_START_DARK);
                                  Navigator.of(context).pushReplacementNamed(
                                      HomeScreen.routeName);
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 4.0),
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                decoration: _currentlySelectedObId != null &&
                                        uobId.contains(_currentlySelectedObId)
                                    ? UIHelper.customDecoration(
                                        2, 8, ColorConstants.SPLASH_BKG,
                                        bkgColor: ColorConstants.SPLASH_BKG)
                                    : UIHelper.customDecoration(
                                        2, 8, ColorConstants.BCKG_COLOR_START),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            // debugPrint('options dot tapped');
                                            if (uob.userType
                                                .toLowerCase()
                                                .contains('owner')) {
                                              _showUpdateOBNameDialog(
                                                  uob, userProvider);
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                _util.setWidth(24)),
                                            child: SvgPicture.asset(
                                              ImagePaths.vdotsSvg,
                                              width: ScreenUtil().setWidth(10),
                                              height:
                                                  ScreenUtil().setHeight(36),
                                              color: _currentlySelectedObId !=
                                                          null &&
                                                      uobId.contains(
                                                          _currentlySelectedObId)
                                                  ? Colors.white
                                                  : Color(0XFF3363A3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      ImagePaths.latestOb,
                                      width: ScreenUtil().setWidth(172),
                                      height: ScreenUtil().setWidth(172),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(obName,
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(36),
                                                        color: _currentlySelectedObId !=
                                                                    null &&
                                                                uobId.contains(
                                                                    _currentlySelectedObId)
                                                            ? Colors.white
                                                            : Colors.black)),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(userType.toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(24),
                                                        color: _currentlySelectedObId !=
                                                                    null &&
                                                                uobId.contains(
                                                                    _currentlySelectedObId)
                                                            ? Colors.white
                                                            : Colors.black)),
                                              ],
                                            ),
                                            uob.userType.contains('owner')
                                                ? Container()
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Wrap(
                                                        direction:
                                                            Axis.horizontal,
                                                        alignment: WrapAlignment
                                                            .spaceBetween,
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                            ImagePaths
                                                                .sandClock,
                                                            color: _currentlySelectedObId !=
                                                                        null &&
                                                                    uobId.contains(
                                                                        _currentlySelectedObId)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            width: ScreenUtil()
                                                                .setWidth(36),
                                                            height: ScreenUtil()
                                                                .setWidth(36),
                                                          ),
                                                          _timeWidget(uob),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: myOceanBuilderList.length,
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            'No SeaPod Found!!',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: _util.setHeight(256),
                  ),
                )
                // UIHelper.getTopEmptyContainer(90, false),
              ],
            ),
            // Appbar(ScreenTitle.OB_SELECTION),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomClipper(ButtonText.BACK, '', () {
                goBack();
              }, () {}, isNextEnabled: false),
            )
          ],
        ),
      ),
    );
  }

  _showCancelAlert(
      UserProvider userProvider, UserOceanBuilder userOceanBuilder) {
    // Navigator.of(context).pushReplacementNamed(PendingOBScreen.routeName,arguments: userOceanBuilder);
    // _showCancelAlert(userOceanBuilder);
    _cancelUserProvider = userProvider;
    _cancelUserOceanBuilder = userOceanBuilder;

    String vesselCode = userOceanBuilder.vessleCode;

    showAlertWithOneButton(
        title: "CANCEL ACCESS REQUEST",
        desc: "Do you want to cancel access request of $vesselCode ?",
        buttonText: "Cancel",
        buttonCallback: cancelCallback,
        context: context);
  }

  cancelCallback() {
    _cancelRequest(_cancelUserProvider, _cancelUserOceanBuilder);
  }

  goBack() {
    if (!(_currentlySelectedObId.compareTo(AppStrings.selectOceanBuilder) ==
        0)) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      //               Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => ProfileScreen()),
      //   (Route<dynamic> route) => false,
      // );
    }
  }

  goNext() {
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  goToEventScreen(UserProvider userProvider) {
    userProvider.autoLogin().then((onValue) {
      Navigator.of(context).pushNamed(OBEventScreen.routeName);
    });
  }

  _cancelRequest(
      UserProvider userProvider, UserOceanBuilder userOceanBuilder) async {
/*     ServerNotification fcmNotification;
    List<ServerNotification> notifications =
        userProvider.authenticatedUser.notifications;
    int len = userProvider.authenticatedUser.notifications.length;
    for (int i = 0; i < len; i++) {
      ServerNotification noti = notifications[i];

      if (noti.data.seaPod.id != null &&
          noti.data.seaPod.id.contains(userOceanBuilder.oceanBuilderId)) {
        fcmNotification = noti;
        break;
      }
    }

    String notificationId = fcmNotification.data.id; */
    String accessRequestId = userOceanBuilder.accessRequestID;

    // debugPrint('access request to cancel ------  ' + accessRequestId);

    userProvider.cancelAccessReqeust(accessRequestId).then((f) async {
      if (f.status == 200) {
        // Navigator.of(context).pushReplacementNamed(OBEventScreen.routeName);

        await userProvider.autoLogin();
        setState(() {
          showInfoBar('Access Request Cancel',
              'Access reqeust cancellation successful', context);
        });
      } else {
        showInfoBar('Access Request Cancel',
            'Access reqeust cancellation failed', context);
      }
    });
  }

  _timeWidget(UserOceanBuilder uob) {
    String timeText = '';
    if (uob.userType.contains('owner')) {
      return Container();
    } else if (uob.checkInDate != null) {
      DateTime now = DateTime.now();
      DateTime checkInDate = uob.checkInDate;
      DateTime checkOutDate = checkInDate.add(uob.accessTime);
      Duration remainingDays = checkOutDate.difference(now);
      // Check in Date
      // N days remaining.
      if (uob.checkInDate.isAfter(DateTime.now())) {
        timeText = '${remainingDays.inDays} days remaining';
      } else {
        timeText = 'Check in ${DateFormat('yMMMMd').format(checkInDate)}';
      }
      return Text(
        timeText,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            color: _currentlySelectedObId != null &&
                    uob.oceanBuilderId.contains(_currentlySelectedObId)
                ? Colors.white
                : Colors.black),
      );
    } else {
      return Container();
    }
  }

  _showUpdateOBNameDialog(
      UserOceanBuilder uob, UserProvider userProvider) async {
    // debugPrint('showUpdateOBNameDialog');

    SeaPod seapod =
        await _oceanBuilderProvider.getSeaPod(uob.oceanBuilderId, userProvider);
    _obNameController = TextEditingController(text: '');
    var alertStyle = AlertStyle(
      isCloseButton: false,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(
          color: ColorConstants.TOP_CLIPPER_START,
          fontSize: 86.sp,
          fontWeight: FontWeight.bold),
    );
    Alert(
        context: context,
        title: "SeaPod Information",
        style: alertStyle,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Image.network(
                  seapod.qRCodeImageUrl,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            UIHelper.getTitleSubtitleWidget('Vesseel Code', seapod.vessleCode),
            SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Name',
                  style: TextStyle(
                      color: ColorConstants.TOP_CLIPPER_START,
                      fontWeight: FontWeight.w500,
                      fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: UIHelper.getRegistrationTextField(
                  context,
                  _bloc.firstName,
                  _bloc.firstNameChanged,
                  uob.oceanBuilderName, //TextFieldHints.FIRST_NAME,
                  _obNameController,
                  null,
                  null,
                  false,
                  TextInputAction.next,
                  _obNameNode,
                  () => {}),
            ),
            SizedBox(
              height: 16.0,
            ),
            UIHelper.getTitleSubtitleWidget('ID', uob.oceanBuilderId),
            SizedBox(
              height: 16.0,
            ),
            UIHelper.getTitleSubtitleWidget('User Type', uob.userType),
            SizedBox(
              height: 16.0,
            ),
            uob.accessTime.inHours != 0
                ? UIHelper.getTitleSubtitleWidget('Access Duration',
                    '${uob.accessTime.inDays.toString()} days')
                : Container(),
            SizedBox(
              height: 16.0,
            ),
            uob.checkInDate != null
                ? UIHelper.getTitleSubtitleWidget('Check in Date',
                    DateFormat('yMMMMd').format(uob.checkInDate))
                : Container(),
            SizedBox(
              height: 16.0,
            ),
            uob.reqStatus.contains('INITIATED')
                ? UIHelper.getTitleSubtitleWidget('Status', 'Pending approval')
                : Container(),
          ],
        ),
        buttons: [
          DialogButton(
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              _showWarning(uob, userProvider);
            },
            // color: Color.fromRGBO(0, 179, 134, 1.0),
            gradient: LinearGradient(colors: [
              ColorConstants.BOTTOM_CLIPPER_START,
              ColorConstants.BOTTOM_CLIPPER_END
            ], begin: Alignment.topRight, end: Alignment.bottomLeft),
            radius: BorderRadius.circular(4.0),
          ),
          DialogButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              // Navigator.pop(context);
              // Navigator.of(context).pop();
            },
            // color: Color.fromRGBO(0, 179, 134, 1.0),
            gradient: LinearGradient(colors: [
              ColorConstants.BOTTOM_CLIPPER_START,
              ColorConstants.BOTTOM_CLIPPER_END
            ], begin: Alignment.topRight, end: Alignment.bottomLeft),
            radius: BorderRadius.circular(4.0),
          ),
        ]).show();
  }

  _showWarning(UserOceanBuilder uob, UserProvider _userProvider) {
    _flush = Flushbar<bool>(
      title: "Warning",
      message:
          " Are you sure you want to change the name of your SeaPod? The name used here should match the name used on your SeaPod home",
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.red,
      boxShadows: [
        BoxShadow(
            color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)
      ],
      backgroundGradient: LinearGradient(colors: [
        ColorConstants.TOP_CLIPPER_START,
        ColorConstants.TOP_CLIPPER_END
      ]),
      isDismissible: true,
      // duration: Duration(seconds: 4),
      icon: Icon(
        Icons.warning,
        color: Colors.red,
      ),
      mainButton: FlatButton(
        onPressed: () {
          _flush.dismiss(true);
        },
        child: Text(
          "Yes",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),

      showProgressIndicator: true,
      progressIndicatorBackgroundColor: AppTheme.notWhite,
    );

    _flush.show(context).then((result) async {
      // print(result);

      if (result != null && result) {
        uob.oceanBuilderName = _changedObName;
        // ResponseStatus responseStatus = await _userProvider.updateUserOceanBuilder(uob);
        ResponseStatus responseStatus = await _userProvider.updateSeapodName(
            uob.oceanBuilderId, uob.oceanBuilderName);
        if (responseStatus.status == 200) {
          // Navigator.of(context).pop();
          // await _userProvider
          //     .resetAuthenticatedUser(_userProvider.authenticatedUser.userID);
          await _userProvider.autoLogin();
          setState(() {
            showInfoBar('Seapod Name Updated', 'SeaPod name updated', context);
          });
        } else {
          // Navigator.of(context).pop();
          //  Navigator.pop(context);
          showInfoBar(parseErrorTitle(responseStatus.code),
              responseStatus.message, context);
        }
      }
    });
  }
}

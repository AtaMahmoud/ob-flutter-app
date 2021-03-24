import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/registration_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user_ocean_builder.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_clipper/custom_clipper.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ClipperProfileOBDropdown extends StatefulWidget {
  final String title;
  final List<UserOceanBuilder> list;

  final Color backgroundColor;

  final ScrollController scrollController;

  const ClipperProfileOBDropdown(
      this.title, this.list, this.backgroundColor, this.scrollController);

  @override
  _ClipperProfileOBDropdownState createState() =>
      _ClipperProfileOBDropdownState();
}

class _ClipperProfileOBDropdownState extends State<ClipperProfileOBDropdown> {
  bool isExpanded = false;
  UserProvider _userProvider;

  OceanBuilderProvider _oceanBuilderProvider;

  RegistrationValidationBloc _bloc = RegistrationValidationBloc();
  FocusNode _obNameNode = FocusNode();
  TextEditingController _obNameController;
  String _changedObName = '';

  Flushbar _flush;

  @override
  void initState() {
    super.initState();

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
    _userProvider = Provider.of<UserProvider>(context);
    _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);

    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomProfileDropdownClipper(),
          child: Container(
            color: widget.backgroundColor,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 164.h, horizontal: 16.w),
              child: Center(
                child: Theme(
                  child: ExpansionTile(
                      trailing: Icon(
                        isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 128.w,
                        color: Colors.white,
                      ),
                      onExpansionChanged: (b) {
                        setState(() {
                          if (b) {
                            double heightToScollOffsetRatio =
                                widget.scrollController.offset /
                                    MediaQuery.of(context).size.height;
                            // // debugPrint('--------- scrollOffsetRatio profile -- $heightToScollOffsetRatio  -offset -- ${widget.scrollController.offset}');
                            double limitRatio = 0.5; //0.19212079534723905;
                            if (heightToScollOffsetRatio <= limitRatio) {
                              double animateTo = widget.scrollController
                                      .position.maxScrollExtent *
                                  2; //widget.scrollController.offset + util.setHeight(960);
                              widget.scrollController.animateTo(animateTo,
                                  curve: Curves.linear,
                                  duration: Duration(milliseconds: 500));
                            }
                          }
                          isExpanded = b;
                        });
                      },
                      title: Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 48.sp,
                            letterSpacing: 1.3),
                      ),
                      children: widget.list != null && widget.list.length > 0
                          ? widget.list.map((ob) {
                              return InkWell(
                                onTap: () {
                                  if (ob.userType
                                      .toLowerCase()
                                      .contains('owner')) {
                                    _showUpdateOBNameDialog(ob);
                                  }
                                },
                                child: ListTile(
                                  title: Text(
                                    ob.oceanBuilderName,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      ob.userType,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 18),
                                    ),
                                  ),
                                  trailing: Text(
                                    ob.vessleCode, //MethodHelper.getVesselCode(ob.oceanBuilderId),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 18),
                                  ),
                                ),
                              );
                            }).toList()
                          : [Container()]),
                  data: ThemeData(dividerColor: Colors.transparent),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showUpdateOBNameDialog(UserOceanBuilder uob) async {
    SeaPod seapod = await _oceanBuilderProvider.getSeaPod(
        uob.oceanBuilderId, _userProvider);
    print('######-----${seapod.qRCodeImageUrl}');
    var qrCodeImageUri =
        'https://oceanbuilders.herokuapp.com/qrcodes/${seapod.vessleCode}.png';

    print(
        '-----------------------------------------------------$qrCodeImageUri');

    _obNameController = TextEditingController(text: '');
    var alertStyle = AlertStyle(
      isCloseButton: false,
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
            SpaceH32(),
            Padding(
              padding: EdgeInsets.all(16.h),
              child: Center(
                child: Image.network(
                  qrCodeImageUri,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SpaceH32(),
            UIHelper.getTitleSubtitleWidget('Vesseel Code', seapod.vessleCode),
            SpaceH32(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
            SpaceH32(),
            UIHelper.getTitleSubtitleWidget('ID', uob.oceanBuilderId),
            SpaceH32(),
            UIHelper.getTitleSubtitleWidget('User Type', uob.userType),
            SpaceH32(),
            uob.accessTime.inHours != 0
                ? UIHelper.getTitleSubtitleWidget('Access Duration',
                    '${uob.accessTime.inDays.toString()} days')
                : Container(),
            SpaceH32(),
            uob.checkInDate != null
                ? UIHelper.getTitleSubtitleWidget('Check in Date',
                    DateFormat('yMMMMd').format(uob.checkInDate))
                : Container(),
            SpaceH32(),
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
              _showWarning(uob);
            },
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

  _showWarning(UserOceanBuilder uob) {
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
      progressIndicatorBackgroundColor: Colors.blueGrey,
    );

    _flush.show(context).then((result) async {
      if (result != null && result) {
        uob.oceanBuilderName = _changedObName;
        ResponseStatus responseStatus = await _userProvider.updateSeapodName(
            uob.oceanBuilderId, uob.oceanBuilderName);
        if (responseStatus.status == 200) {
          await _userProvider.autoLogin();
          showInfoBar('Seapod Name Updated', 'SeaPod name updated', context);
        } else {
          showInfoBar(parseErrorTitle(responseStatus.code),
              responseStatus.message, context);
        }
      }
    });
  }
}

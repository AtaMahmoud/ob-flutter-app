import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/access_request.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/models/user_ocean_builder.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class PendingRequestList extends StatefulWidget {
  final Color backgroundColor;
  const PendingRequestList(this.backgroundColor);

  @override
  _PendingRequestListState createState() => _PendingRequestListState();
}

class _PendingRequestListState extends State<PendingRequestList> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    List<UserOceanBuilder> pendigOceanBuilderList = [];
    int _len = userProvider?.authenticatedUser?.userOceanBuilder?.length ?? 0;

    if (_len > 0) {
      pendigOceanBuilderList = new List<UserOceanBuilder>.from(
          userProvider?.authenticatedUser?.userOceanBuilder);
      pendigOceanBuilderList.retainWhere((uob) {
        return uob.reqStatus != null &&
            uob.reqStatus.contains(NotificationConstants.initiated) &&
            !uob.userType.toLowerCase().contains('owner');
      });
    }

    String _title =
        'You have ${pendigOceanBuilderList.length} pending access request';

    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.25),
            borderRadius: BorderRadius.circular(8),
          ),
          // color: Colors.white.withOpacity(.25),//widget.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
            child: Center(
              child: Theme(
                child: ExpansionTile(
                    trailing: Icon(
                      isExpanded ? Icons.arrow_drop_up : Icons.arrow_right,
                      // size: 20,
                      color: Colors.white,
                    ),
                    onExpansionChanged: (b) {
                      setState(() {
                        // print(b);
                        isExpanded = b;
                      });
                    },
                    title: Text(
                      _title,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    children: pendigOceanBuilderList.map((ob) {
                      DateTime checkInDate = ob.checkInDate;
                      DateTime checkOutDate = ob.checkInDate.add(ob.accessTime);
                      return InkWell(
                        onTap: () {
                          // if(reqStatus !=null && reqStatus.contains(NotificationConstants.initiated))
                          _showCancelAlert(userProvider, ob);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 8.0),
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          decoration: UIHelper.customDecoration(
                              2, 12, ColorConstants.BCKG_COLOR_START),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Image.asset(
                                    ImagePaths.latestOb,
                                    width: 60,
                                    height: 60,
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 4.0,
                                    // right: 4.0,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(ob.oceanBuilderName,
                                          style: TextStyle(fontSize: 18)),
                                      Text(InfoTexts.OB_ACCESS_REQ_PENDING,
                                          style: TextStyle(fontSize: 12)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Wrap(
                                            direction: Axis.horizontal,
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: <Widget>[
                                              Image.asset(
                                                ImagePaths.sandClock,
                                                // width: 60,
                                                // height: 60,
                                              ),
                                              Text(
                                                'Check in ${DateFormat('yMMMMd').format(checkInDate)}',
                                                style: TextStyle(fontSize: 8),
                                              )
                                            ],
                                          ),
                                          Wrap(
                                            direction: Axis.horizontal,
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: <Widget>[
                                              Image.asset(
                                                ImagePaths.sandClock,
                                                // width: 60,
                                                // height: 60,
                                              ),
                                              Text(
                                                  'Check out ${DateFormat('yMMMMd').format(checkOutDate)}',
                                                  style: TextStyle(fontSize: 8))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList()),
                data: ThemeData(dividerColor: Colors.transparent),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(48.h, 130.h, 48.h, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[],
          ),
        )
      ],
    );
  }

  UserProvider _cancelUserProvider;
  UserOceanBuilder _cancelUserOceanBuilder;
  String alertButtonText = 'Cancel';
  bool cancelling = false;

// show cancel alert
  _showCancelAlert(
      UserProvider userProvider, UserOceanBuilder userOceanBuilder) {
    // Navigator.of(context).pushReplacementNamed(PendingOBScreen.routeName,arguments: userOceanBuilder);
    // _showCancelAlert(userOceanBuilder);
    _cancelUserProvider = userProvider;
    _cancelUserOceanBuilder = userOceanBuilder;

    String vesselCode = userOceanBuilder.vessleCode;
    showAlertWithOneButton(
        title: "CANCEL ACCESS REQUEST",
        desc:
            "Do you want to cancel access request of ${userOceanBuilder.oceanBuilderName}\n (VesselCode: $vesselCode) ?",
        buttonText: alertButtonText,
        buttonCallback: cancelCallback,
        context: context);
  }

  cancelCallback() {
    if (!cancelling)
      _cancelRequest(_cancelUserProvider, _cancelUserOceanBuilder);
  }

  _cancelRequest(
      UserProvider userProvider, UserOceanBuilder userOceanBuilder) async {
    setState(() {
      cancelling = true;
      alertButtonText = 'Cancelling';
    });

    String accessRequestId = userOceanBuilder.accessRequestID;

    // debugPrint('access request to cancel ------  ' + accessRequestId);

    userProvider.cancelAccessReqeust(accessRequestId).then((f) {
      if (f.status == 200) {
        userProvider.autoLogin().then((onValue) {
          setState(() {
            cancelling = false;
            alertButtonText = 'Cancel';
            Navigator.of(context, rootNavigator: true).pop();
            showInfoBar(
                'Cancel Access Request', 'Access request canceled', context);
          });
        });
      } else {
        setState(() {
          cancelling = false;
          alertButtonText = 'Cancel';
          Navigator.of(context, rootNavigator: true).pop();
          showInfoBar('Cancel Access Request',
              'Access reqeust cancellation failed', context);
        });
      }
    });
  }
}

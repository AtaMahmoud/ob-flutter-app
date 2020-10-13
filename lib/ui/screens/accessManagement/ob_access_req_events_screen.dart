import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/access_request.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/notification/guest_request_response_screen.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class OBAccessReqEventScreen extends StatefulWidget {
  static const String routeName = '/obaccessrequsetevents';

  @override
  _OBAccessReqEventScreenState createState() => _OBAccessReqEventScreenState();
}

class _OBAccessReqEventScreenState extends State<OBAccessReqEventScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    int len = userProvider?.authenticatedUser?.notifications?.length ?? 0;
    List<ServerNotification> notificationList = [];

    if (len > 0)
      notificationList =
          userProvider.authenticatedUser.notifications.reversed.toList();

    notificationList.retainWhere((noti) {
      return noti.message.contains(NotificationConstants.request);
    });

    return Scaffold(
        body: Stack(
      children: <Widget>[
        CustomScrollView(
          slivers: <Widget>[
            UIHelper.getTopEmptyContainer(
                MediaQuery.of(context).size.height / 4, false),
            len > 0 ? _notificationList(notificationList) : _noEventFoundText(),
            UIHelper.getTopEmptyContainer(90, false),
          ],
        ),
        Appbar(ScreenTitle.OB_ACCESS_REQUESTS),
        _bottomBar()
      ],
    ));
  }

  Positioned _bottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: StreamBuilder<String>(
        stream: null,
        builder: (context, snapshot) {
          return BottomClipper(
              ButtonText.BACK, ButtonText.NEXT, () => goBack(), () => goNext());
        },
      ),
    );
  }

  SliverList _notificationList(List<ServerNotification> notificationList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        ServerNotification fcmNotification = notificationList[index];

        String notiMsg = fcmNotification.title;
        String requestStatus = fcmNotification.data.status;
        String notificationType = fcmNotification.message;

        DateTime dateTime = new DateTime.fromMicrosecondsSinceEpoch(
            int.parse(fcmNotification.data.id));
        String formatedDateTime =
            DateFormat('yyyy-MM-dd  HH:mm:ss a').format(dateTime);

        return InkWell(
          onTap: () {
            if (notificationType.contains(NotificationConstants.request))
              Navigator.of(context).pushNamed(
                  GuestRequestResponseScreen.routeName,
                  arguments: fcmNotification);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            padding: EdgeInsets.symmetric(vertical: 8.0),
            decoration: UIHelper.customDecoration(
                2, 12, ColorConstants.BCKG_COLOR_START),
            child: ListTile(
              leading: SvgPicture.asset(
                ImagePaths.svgSeapod,
                width: 60,
                height: 60,
              ),
              title: Text(notiMsg),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Type: $notificationType'),
                    // Text('Status: $requestStatus'),
                    Text('Time: $formatedDateTime'),
                  ],
                ),
              ),
            ),
          ),
        );
      }, childCount: notificationList.length),
    );
  }

  SliverToBoxAdapter _noEventFoundText() {
    return SliverToBoxAdapter(
      child: Center(
        child: Text(
          'No event Found!!',
          style: TextStyle(fontSize: 48.sp),
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
}

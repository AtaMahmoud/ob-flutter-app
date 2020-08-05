import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/permission_edit_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/permission.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/ui/widgets/custom_expansion_title.dart';
import 'package:provider/provider.dart';

class PermissionDropdown extends StatefulWidget {
  final PermissionGroup permissionSet;

  // final Color backgroundColor;
  final PermissionEditBloc editBloc;

  final ScrollController scrollController;

  const PermissionDropdown(this.permissionSet, this.scrollController,{this.editBloc});

  @override
  _PermissionDropdownState createState() => _PermissionDropdownState();
}

class _PermissionDropdownState extends State<PermissionDropdown> {
  bool isExpanded = false;
  UserProvider _userProvider;


  FocusNode _obNameNode = FocusNode();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);

    ScreenUtil _util = ScreenUtil();
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(
                ScreenUtil().setWidth(16)),
            color: ColorConstants.CREATE_PERMISSION_COLOR_BKG,
          ),
          child: Center(
            child: Theme(
              child: CustomExpansionTile(
                  backgroundColor: Colors.white,
                  headerBackgroundColor:
                      ColorConstants.CREATE_PERMISSION_COLOR_BKG,
                  trailing: Icon(
                    isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    size: ScreenUtil().setWidth(96),
                    color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                  ),
                  onExpansionChanged: (b) {
                    setState(() {
                      // if (b) {
                      //   double heightToScollOffsetRatio =
                      //       widget.scrollController.offset /
                      //           MediaQuery.of(context).size.height;
                      //    debugPrint('--------- scrollOffsetRatio permission dropdown -- $heightToScollOffsetRatio  -offset -- ${widget.scrollController.offset}');
                      //   double limitRatio = 0.5; //0.19212079534723905;
                      //   if (heightToScollOffsetRatio <= limitRatio) {
                      //     double animateTo = widget
                      //             .scrollController.position.maxScrollExtent; //widget.scrollController.offset + util.setHeight(960);
                      //     widget.scrollController.animateTo(animateTo,
                      //         curve: Curves.linear,
                      //         duration: Duration(milliseconds: 500));
                      //   }
                      // }
                      isExpanded = b;
                    });
                  },
                  title: Text(
                    widget.permissionSet.name,
                    style: TextStyle(
                        color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                        fontSize: _util.setSp(41),
                        letterSpacing: 1.3),
                  ),
                  children: widget.permissionSet.permissions != null &&
                          widget.permissionSet.permissions.length > 0
                      ? widget.permissionSet.permissions.map((permission) {
                          return InkWell(
                              onTap: () {
                                if(widget.editBloc != null)
                                widget.editBloc.permissionChanged(true);
                                setState(() {

                                  if(permission.status.compareTo('ON')==0)
                                    permission.status = 'OFF';
                                  else
                                    permission.status = 'ON';

                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: _util.setHeight(16),
                                    horizontal: _util.setWidth(32)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    ImageIcon(
                                      AssetImage(
                                        permission.status.compareTo('ON')==0
                                          ? ImagePaths.icUnread
                                          : ImagePaths.icRead
                                          ),
                                      color: permission.status.compareTo('ON')==0
                                          ? ColorConstants
                                              .COLOR_NOTIFICATION_BUBBLE
                                          : Colors.grey, //Color(0xFF064390),
                                      size: _util.setWidth(36),
                                    ),
                                    SizedBox(
                                      width: _util.setWidth(32),
                                    ),
                                    Text(
                                      permission.name,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: ColorConstants
                                              .ACCESS_MANAGEMENT_TITLE,
                                          fontSize: _util.setSp(36)),
                                    )
                                  ],
                                ),
                              ));
                        }).toList()
                      : [Container()]),
              data: ThemeData(dividerColor: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }
}

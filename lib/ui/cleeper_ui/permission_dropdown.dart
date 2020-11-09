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

  const PermissionDropdown(this.permissionSet, this.scrollController,
      {this.editBloc});

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

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(16.w),
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
                    size: 96.w,
                    color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                  ),
                  onExpansionChanged: (b) {
                    setState(() {
                      isExpanded = b;
                    });
                  },
                  title: Text(
                    widget.permissionSet.name,
                    style: TextStyle(
                        color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                        fontSize: 41.sp,
                        letterSpacing: 1.3),
                  ),
                  children: widget.permissionSet.permissions != null &&
                          widget.permissionSet.permissions.length > 0
                      ? widget.permissionSet.permissions.map((permission) {
                          return InkWell(
                              onTap: () {
                                if (widget.editBloc != null)
                                  widget.editBloc.permissionChanged(true);
                                setState(() {
                                  if (permission.status.compareTo('ON') == 0)
                                    permission.status = 'OFF';
                                  else
                                    permission.status = 'ON';
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.h, horizontal: 32.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    ImageIcon(
                                      AssetImage(
                                          permission.status.compareTo('ON') == 0
                                              ? ImagePaths.icUnread
                                              : ImagePaths.icRead),
                                      color:
                                          permission.status.compareTo('ON') == 0
                                              ? ColorConstants
                                                  .COLOR_NOTIFICATION_BUBBLE
                                              : Colors
                                                  .grey, //Color(0xFF064390),
                                      size: 36.w,
                                    ),
                                    SizedBox(
                                      width: 32.w,
                                    ),
                                    Text(
                                      permission.name,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: ColorConstants
                                              .ACCESS_MANAGEMENT_TITLE,
                                          fontSize: 36.sp),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/profile_edit_bloc.dart';
import 'package:ocean_builder/bloc/registration_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/custom_clipper/custom_clipper.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:ocean_builder/core/models/emergency_contact.dart';

class ClipperProfileEmergencyDropdown extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  final ScrollController scrollController;
  final ProfileEditBloc editBloc;
  final User user;

  const ClipperProfileEmergencyDropdown(this.title, this.backgroundColor,
      this.scrollController, this.editBloc, this.user);

  @override
  _ClipperProfileEmergencyDropdownState createState() =>
      _ClipperProfileEmergencyDropdownState();
}

class _ClipperProfileEmergencyDropdownState
    extends State<ClipperProfileEmergencyDropdown> {
  bool isExpanded = false;
  RegistrationValidationBloc _bloc = RegistrationValidationBloc();

  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;

  FocusNode _firstNameNode = FocusNode();
  FocusNode _lastNameNode = FocusNode();
  FocusNode _phoneNode = FocusNode();
  FocusNode _emailNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.user.emergencyContact == null) {
      widget.user.emergencyContact = EmergencyContact();
    }
    widget.editBloc.emergencyInfoChanged(true);
    _setUserDataListener();
  }

  _setUserDataListener() {
    _bloc.firstNameController.listen((onData) {
      if (widget.user.emergencyContact?.firstName == null &&
          onData != null &&
          onData.length >= 3) {
        widget.editBloc.emergencyInfoChanged(true);
        widget.user.emergencyContact.firstName = onData;
      } else if (onData != null &&
          widget.user.emergencyContact.firstName != null &&
          widget.user.emergencyContact.firstName.compareTo(onData) != 0 &&
          onData.length >= 3) {
        widget.editBloc.emergencyInfoChanged(true);

        widget.user.emergencyContact.firstName = onData;
      }
    });

    _bloc.lastNameController.listen((onData) {
      if (widget.user.emergencyContact?.lastName == null &&
          onData != null &&
          onData.length >= 3) {
        widget.editBloc.emergencyInfoChanged(true);
        widget.user.emergencyContact.lastName = onData;
      } else if (onData != null &&
          widget.user.emergencyContact.lastName != null &&
          widget.user.emergencyContact.lastName.compareTo(onData) != 0 &&
          onData.length >= 3) {
        widget.editBloc.emergencyInfoChanged(true);

        widget.user.emergencyContact.lastName = onData;
      }
    });

    _bloc.emailController.listen((onData) {
      if (widget.user.emergencyContact.email == null &&
          onData != null &&
          onData.length >= 3) {
        widget.editBloc.emergencyInfoChanged(true);
        widget.user.emergencyContact.email = onData;
      } else if (onData != null &&
          widget.user.emergencyContact.email != null &&
          widget.user.emergencyContact.email.compareTo(onData) != 0 &&
          onData.length >= 3) {
        widget.editBloc.emergencyInfoChanged(true);

        widget.user.emergencyContact.email = onData;
      }
    });

    _bloc.phoneController.listen((onData) {
      if (widget.user.emergencyContact.phone == null &&
          onData != null &&
          onData.length >= 3) {
        widget.editBloc.emergencyInfoChanged(true);
        widget.user.emergencyContact.phone = onData;
      } else if (onData != null &&
          widget.user.emergencyContact.phone != null &&
          widget.user.emergencyContact.phone.compareTo(onData) != 0 &&
          onData.length >= 3) {
        widget.editBloc.emergencyInfoChanged(true);

        widget.user.emergencyContact.phone = onData;
      }
    });

    widget.editBloc.emergencyInfoController.listen((isChanged) {
      if (isChanged) {
        ProfileEditState.emergencyContactInfoChanged = true;
      } else {
        ProfileEditState.emergencyContactInfoChanged = false;
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user.emergencyContact != null) {
      _firstNameController =
          TextEditingController(text: widget.user.emergencyContact.firstName);
      _lastNameController =
          TextEditingController(text: widget.user.emergencyContact.lastName);
      _emailController =
          TextEditingController(text: widget.user.emergencyContact.email);
      _phoneController =
          TextEditingController(text: widget.user.emergencyContact.phone);

      _bloc.firstNameChanged(widget.user.emergencyContact.firstName);
      _bloc.lastNameChanged(widget.user.emergencyContact.lastName);
      _bloc.emailChanged(widget.user.emergencyContact.email);
      _bloc.phoneChanged(widget.user.emergencyContact.phone);
    }

    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomProfileDropdownClipper(),
          child: Container(
            color: widget.backgroundColor,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 164.h,
                  horizontal: 16.w),
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
                            double limitRatio = 0.6;
                            if (heightToScollOffsetRatio <= limitRatio) {
                              double animateTo = widget.scrollController
                                      .position.maxScrollExtent *
                                  3;
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
                      children: [
                        SizedBox(height: 120.h),
                        UIHelper.getProfileOBUnit(
                            context,
                            TextFieldHints.PROFILE_FIRST_NAME,
                            _bloc.firstName,
                            _bloc.firstNameChanged,
                            _firstNameController,
                            null,
                            true,
                            _firstNameNode,
                            _lastNameNode),
                        SizedBox(height: 120.h),
                        UIHelper.getProfileOBUnit(
                            context,
                            TextFieldHints.PROFILE_LAST_NAME,
                            _bloc.lastName,
                            _bloc.lastNameChanged,
                            _lastNameController,
                            null,
                            true,
                            _lastNameNode,
                            _phoneNode),
                        SizedBox(height: 120.h),
                        UIHelper.getProfileOBUnitPhone(
                            context,
                            TextFieldHints.PHONE,
                            _bloc.phone,
                            _bloc.phoneChanged,
                            _phoneController,
                            InputTypes.NUMBER,
                            true,
                            _phoneNode,
                            _emailNode),
                        SizedBox(height: 120.h),
                        UIHelper.getProfileOBUnit(
                            context,
                            TextFieldHints.PROFILE_EMAIL,
                            _bloc.email,
                            _bloc.emailChanged,
                            _emailController,
                            InputTypes.EMAIL,
                            true,
                            _emailNode,
                            null),
                        SizedBox(height: 120.h),
                      ]),
                  data: ThemeData(dividerColor: Colors.transparent),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/registration_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/core/providers/user_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_2.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/login_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/set_password_screen.dart';
import 'package:ocean_builder/ui/shared/no_internet_flush_bar.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class YourInfoScreen extends StatefulWidget {
  static const String routeName = '/yourInfo';

  @override
  _YourInfoScreenState createState() => _YourInfoScreenState();
}

class _YourInfoScreenState extends State<YourInfoScreen> {
  TextEditingController _firstNameController,
      _lastNameController,
      _emailController,
      _phoneController;

  ScrollController _controller = ScrollController();

  FocusNode _firstNameNode = FocusNode();
  FocusNode _lastNameNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _phoneNode = FocusNode();

  RegistrationValidationBloc _bloc = RegistrationValidationBloc();
  User _user = User();
  UserProvider userProvider;
  DesignDataProvider designDataProvider;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: '');
    _lastNameController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _phoneController = TextEditingController(text: '');
    _setUserDataListener();

    _phoneNode.addListener(() {
      if (_phoneNode.hasFocus) {
        _controller.animateTo(250,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    });

    _emailNode.addListener(() {
      if (_emailNode.hasFocus) {
        _controller.animateTo(100,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    });
  }

  _setUserDataListener() {
    _bloc.firstNameController.listen((onData) {
      _user.firstName = onData;
    });

    _bloc.lastNameController.listen((onData) {
      _user.lastName = onData;
    });

    _bloc.emailController.listen((onData) {
      _user.email = onData;
    });

    _bloc.phoneController.listen((onData) {
      _user.phone = onData;
    });

    _bloc.countryController.listen((onData) {
      _user.country = onData;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _emailNode.dispose();
    _phoneNode.dispose();
    _controller.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    GlobalContext.currentScreenContext = context;

    
    final UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context);

    designDataProvider = Provider.of<DesignDataProvider>(context);
    userProvider = Provider.of<UserProvider>(context);

    

    double sizedBoxHeight = 30;
    ScreenUtil _util = ScreenUtil();

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: CustomScrollView(
              shrinkWrap: true,
              controller: _controller,
              slivers: <Widget>[
                UIHelper.getTopEmptyContainer(_util.setHeight(500), false),
                SliverList(
                    delegate: SliverChildListDelegate([
                  SizedBox(height: sizedBoxHeight),
                  UIHelper.getRegistrationTextField(
                      context,
                      _bloc.firstName,
                      _bloc.firstNameChanged,
                      TextFieldHints.FIRST_NAME,
                      _firstNameController,
                      null,
                      null,
                      true,
                      TextInputAction.next,
                      _firstNameNode,
                      () => FocusScope.of(context).requestFocus(_lastNameNode)),
                  SizedBox(height: sizedBoxHeight),
                  UIHelper.getRegistrationTextField(
                      context,
                      _bloc.lastName,
                      _bloc.lastNameChanged,
                      TextFieldHints.LAST_NAME,
                      _lastNameController,
                      null,
                      null,
                      true,
                      TextInputAction.next,
                      _lastNameNode,
                      () => FocusScope.of(context).requestFocus(_emailNode)),
                  SizedBox(height: sizedBoxHeight),
                  UIHelper.getRegistrationTextField(
                      context,
                      _bloc.email,
                      _bloc.emailChanged,
                      TextFieldHints.ENTER_EMAIL,
                      _emailController,
                      InputTypes.EMAIL,
                      null,
                      true,
                      TextInputAction.next,
                      _emailNode,
                      () => FocusScope.of(context).requestFocus(_phoneNode)),
                  SizedBox(height: sizedBoxHeight),
                  UIHelper.getCountryDropdown(ListHelper.getCountryList(),
                      _bloc.country, _bloc.countryChanged, true),
                  SizedBox(height: sizedBoxHeight),
                  UIHelper.getRegistrationTextField(
                      context,
                      _bloc.phone,
                      _bloc.phoneChanged,
                      TextFieldHints.PHONE,
                      _phoneController,
                      InputTypes.NUMBER,
                      null,
                      true,
                      TextInputAction.done,
                      _phoneNode,
                      null),
                ])),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 48.0, //util.setHeight(64),
                        right: 16.0,
                        bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            goToLogInPageFromInfo();
                          },
                          child: Text(
                            'ALREADY A MEMBER ?',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: ColorConstants.PROFILE_BKG_1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                UIHelper.getTopEmptyContainer(_util.setHeight(330), false),
              ],
            ),
          ),
          Positioned(
              top: 0, left: 0, right: 0, child: Appbar(ScreenTitle.YOUR_INFO)),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: setPasswordButton(userDataProvider))
        ],
      ),
    );
  }

  goToLogInPageFromInfo() {
    Navigator.of(context).pushNamed(LoginScreen.routeName, arguments: ScreenTitle.YOUR_INFO);
  }

  Widget setPasswordButton(UserDataProvider userDataProvider) {
    return StreamBuilder(
      stream: _bloc.infoCheck,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return BottomClipper2(
            ButtonText.BACK,
            userProvider.isLoading
                ? ButtonText.CHECKING
                : ButtonText.SET_PASSWORD,
            !snapshot.hasData,
            () => goBack(),
            () => goNext(userDataProvider));
      },
    );
  }

  goBack() {
    Navigator.pop(context);
  }


  goNext(UserDataProvider userDataProvider) async {


    bool internetStatus = await DataConnectionChecker().hasConnection;
    if(!internetStatus){
      displayInternetInfoBar(context,AppStrings.noInternetConnectionTryAgain);
      // showInfoBar('NO INTERNET', AppStrings.noInternetConnection, context);
      return;
    }else{
      userDataProvider.user = _user;
      Navigator.of(context)
          .pushNamed(PasswordScreen.routeName, arguments: true);
    }


  }
  
}

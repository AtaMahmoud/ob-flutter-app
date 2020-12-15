import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/bloc/login_validation_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/buttons.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:ocean_builder/core/common_widgets/custom_checkbox.dart';
import 'package:ocean_builder/core/common_widgets/flutter_switch.dart';
import 'package:ocean_builder/core/common_widgets/radio_buttons.dart';
import 'package:ocean_builder/core/common_widgets/search_bar.dart';
import 'package:ocean_builder/core/common_widgets/select_button.dart';
import 'package:ocean_builder/core/common_widgets/sliders.dart';
import 'package:ocean_builder/core/common_widgets/space_item.dart';
import 'package:ocean_builder/core/common_widgets/text_editable.dart';
import 'package:ocean_builder/core/common_widgets/title_editable.dart';
import 'package:ocean_builder/ui/shared/drop_downs.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';

class WidgetShowCase extends StatefulWidget {
  static const String routeName = '/widgetShowCase';
  WidgetShowCase({Key key}) : super(key: key);

  @override
  _WidgetShowCaseState createState() => _WidgetShowCaseState();
}

class _WidgetShowCaseState extends State<WidgetShowCase> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isChecked = false;

  bool isPublish = false;

  TextEditingController controller;
  TextEditingController textController;
  TextEditingController searchController;
  FocusNode node, nextNode;

  LoginValidationBloc _bloc = LoginValidationBloc();

  GenericBloc<String> _selectBloc =
      GenericBloc(ListHelper.getPermissionList()[0]);

  @override
  void initState() {
    controller = new TextEditingController();
    textController = new TextEditingController();
    searchController = new TextEditingController();
    node = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    controller.dispose();
    textController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CommonTheme.greyLightest,
      body: Center(
        child: CustomScrollView(
          slivers: [
            // UIHelper.getTopEmptyContainer(8, false),
            SearchBar(
              scaffoldKey: _scaffoldKey,
              searchTextController: searchController,
              stream: _bloc.emailController,
              textChanged: (value) {
                debugPrint('Changed Search text is --- $value');
              },
              onSubmitted: (value) {
                debugPrint('Submitted Search text is --- $value');
              },
            ),
            SliverToBoxAdapter(
              child: _widgetTest(),
            )
          ],
        ),
      ),
    );
  }

  _widgetTest() {
    RadioData _radioData = new RadioData(labelVals: {
      'radio button 1': 'one',
      'radio button 2': 'two',
      'radio button 3': 'three'
    }, selectedValue: 'one');

    RadioData _radioDataSet2 = new RadioData(labelVals: {
      'radio button 1': 'one',
      'radio button 2': 'two',
    }, selectedValue: 'one');

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      PrimaryButton(
        label: 'Primary Button',
        onPressed: () {},
        isEnabled: true,
        key: Key('primary_button'),
      ),
      PrimaryButton(
        label: 'Primary Button',
        onPressed: () {},
        key: Key('primary_button2'),
      ),
      PrimaryButton(
        label: 'Primary Outlined',
        onPressed: () {},
        isEnabled: true,
        isOutlined: true,
        key: Key('primary_outline_button'),
      ),
      PrimaryButton(
        label: 'Primary Outlined',
        onPressed: () {},
        isOutlined: true,
        key: Key('primary_outline_button2'),
      ),
      PrimaryButton(
        label: 'Primary Destructive',
        onPressed: () {},
        isEnabled: true,
        isDestructive: true,
        key: Key('primary_destructive_button'),
      ),
      PrimaryButton(
        label: 'Primary Destructive',
        onPressed: () {},
        isDestructive: true,
        key: Key('primary_destructive_button2'),
      ),
      PrimaryButton(
        label: 'Primary naked',
        onPressed: () {},
        isEnabled: true,
        isNaked: true,
        key: Key('primary_naked_button'),
      ),
      PrimaryButton(
        label: 'Primary naked',
        onPressed: () {},
        isNaked: true,
        key: Key('primary_naked_button2'),
      ),
      CommonSlider(
        key: Key('common slider'),
        sliderValue: 11.0,
        hasSliderLabel: false,
        onChangedMethod: (value) {
          debugPrint(
              'I wish to print the value from here as a delegate --- $value ');
        },
      ),
      CommonSlider(
        key: Key('common slider 2'),
        sliderValue: 11.0,
        hasSliderLabel: true,
        sliderLabel: 'Slider Label',
        onChangedMethod: (value) {
          debugPrint(
              'I wish to print the value from here as a delegate --- $value');
        },
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        color: Colors.black,
        child: CommonSlider(
          key: Key('common slider 3'),
          sliderValue: 11.0,
          hasSliderLabel: true,
          isDarkBg: true,
          sliderLabel: 'Slider Label',
          onChangedMethod: (value) {
            debugPrint(
                'I wish to print the value from here as a delegate --- $value');
          },
        ),
      ),
      RadioButton(
        radioData: _radioData,
        onChangedMethod: (value) {
          debugPrint('Do whatever .. with the changed group value $value');
        },
      ),
      RadioButton(
        radioData: _radioDataSet2,
        isHorizontallyAlligned: true,
        onChangedMethod: (value) {
          debugPrint('Do whatever .. with the changed group value $value');
        },
      ),
      Container(
        child: CustomCheckbox(
            key: Key('cb without title'),
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = !_isChecked;
              });
            }),
      ),
      FlutterSwitch(
        // valueFontSize: 48,
        toggleColor: Colors.white,
        value: isPublish,
        // borderRadius: 24,
        padding: 0.0,
        showOnOff: false,
        activeColor: Colors.green,
        inactiveColor: CommonTheme.greyLighter,
        onToggle: (val) {
          setState(() {
            isPublish = val;
          });
        },
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: TitleEditable(
          title: 'TitleEditable',
          isEnabled: true,
          controller: controller,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextEditable(
          stream: _bloc.password,
          textChanged: _bloc.passwordChanged,
          controller: controller,
          title: 'Name',
          placeHolder: 'User name',
          helperText: 'Enter user name not more than 200 characters',
          hasHelperText: true,
          hasPadding: false,
          hasPlaceHolder: true,
          hasLabel: true,
          isEnabled: false,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextEditable(
          stream: _bloc.email,
          textChanged: _bloc.emailChanged,
          controller: textController,
          title: 'Email',
          placeHolder: 'Email Address',
          helperText: 'Enter a valid email',
          hasHelperText: true,
          hasPadding: false,
          hasPlaceHolder: true,
          hasLabel: true,
          isEnabled: true,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextEditable(
          stream: _bloc.email,
          textChanged: _bloc.emailChanged,
          controller: textController,
          title: 'Email',
          placeHolder: 'Email Address',
          helperText: 'Enter a valid email',
          hasHelperText: true,
          hasPadding: false,
          hasPlaceHolder: true,
          hasLabel: false,
          isEnabled: true,
        ),
      ),
      SpaceItem(
        isSelected: false,
        hasWarning: true,
        label: 'Kitchen Room',
        onPressed: () {
          debugPrint('Tapped in kitchen room');
        },
      ),
      SpaceItem(
        isSelected: true,
        hasWarning: false,
        label: 'Space Room',
        onPressed: () {
          debugPrint('Tapped in Space room');
        },
      ),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectButton(
            list: ListHelper.getPermissionList(),
            stream: _selectBloc.controller,
            changed: _selectBloc.changed,
            addPadding: false,
            label: 'Permission',
            helperText: 'Help text',
            placeHolder: 'Place holder',
            hasHelperText: true,
            hasLabel: true,
            hasPlaceHolder: true,
            isEnabled: true,
          )),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectButton(
            list: ListHelper.getPermissionList(),
            stream: _selectBloc.controller,
            changed: _selectBloc.changed,
            addPadding: false,
            label: 'Permission',
            helperText: 'Help text',
            placeHolder: 'Place holder',
            hasHelperText: true,
            hasLabel: true,
            hasPlaceHolder: true,
            isEnabled: false,
          ))
    ]);
  }

  bool isSelected = false;
}

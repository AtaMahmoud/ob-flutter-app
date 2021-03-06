import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/spar_design_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class SparFinishingScreen extends StatefulWidget {
  static const String routeName = '/sparFinishing';

  @override
  _SparFinishingScreenState createState() => _SparFinishingScreenState();
}

class _SparFinishingScreenState extends State<SparFinishingScreen> {
  List<String> list = ListHelper.getSparFinishingColorList();

  GenericBloc<String> _bloc =
      GenericBloc(ListHelper.getSparFinishingColorList()[0]);
  GenericBloc<int> _colorCountBloc = GenericBloc(8);
  GenericBloc<int> _selectedColor = GenericBloc(ListHelper.colorList()[0]);

  String _sparFinishing = ListHelper.getSparFinishingColorList()[0];
  String _sparFinishingCustom = ListHelper.colorList()[0].toString();

  @override
  void initState() {
    super.initState();
    _selectedColor.controller.listen((onData) {
      Color color = new Color(onData);
      String valueString = color.toString().split('(')[1].split(')')[0];
      _sparFinishingCustom = valueString;
    });
    _bloc.controller.listen((onData) {
      _sparFinishing = onData;
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    _colorCountBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;

    final DesignDataProvider designDataProvider =
        Provider.of<DesignDataProvider>(context);

    if (designDataProvider.oceanBuilder.sparFinishing != null) {
      if (designDataProvider.oceanBuilder.sparFinishing
              .compareTo(ListHelper.getSparFinishingColorList()[0]) ==
          0)
        _bloc.sink.add(_sparFinishing);
      else {
        _bloc.sink.add(list[1]);
        _selectedColor.sink
            .add(int.parse(designDataProvider.oceanBuilder.sparFinishing));
      }
    }
    return Container(
      decoration: BoxDecoration(gradient: blueBackgroundGradient),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _mainContent(context),
            _topBar(),
            _bottomBar(designDataProvider)
          ],
        ),
      ),
    );
  }

  Positioned _bottomBar(DesignDataProvider designDataProvider) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: BottomClipper(ButtonText.BACK, ButtonText.NEXT, () => goBack(),
            () => goNext(designDataProvider)));
  }

  Appbar _topBar() {
    return Appbar(
      ScreenTitle.SPAR_FINISHING,
      isDesignScreen: true,
    );
  }

  CustomScrollView _mainContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _startSpace(context),
        SliverToBoxAdapter(
            child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[_radioButtonSteel(), _radioButtonColor()],
            ),
          ],
        )),
        _colorGridFinish(),
        _infoText(),
        _endSpace(),
      ],
    );
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  SliverToBoxAdapter _infoText() {
    return SliverToBoxAdapter(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Text(
            InfoTexts.POLYUREA_COATING_INFO,
            style: TextStyle(
                fontSize: 44.sp, color: ColorConstants.TOP_CLIPPER_START),
          )),
    );
  }

  StreamBuilder<String> _colorGridFinish() {
    return StreamBuilder<String>(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          return snapshot.data == ListHelper.getSparFinishingColorList()[1]
              ? UIHelper.getSliverGridColor(_colorCountBloc.stream,
                  _selectedColor.stream, (data) => selectItem(data))
              : SliverPadding(padding: EdgeInsets.all(0.0));
        });
  }

  InkWell _radioButtonColor() {
    return InkWell(
      onTap: () => _bloc.sink.add(list[1]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            ImagePaths.defaultIcon,
            width: 380.w,
            height: 380.w,
          ),
          SizedBox(height: 16.0),
          UIHelper.getCustomRadioButtonVertical(_bloc.stream, list[1])
        ],
      ),
    );
  }

  InkWell _radioButtonSteel() {
    return InkWell(
      onTap: () => _bloc.sink.add(list[0]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            ImagePaths.defaultIcon,
            width: 380.w,
            height: 380.w,
          ),
          SizedBox(height: 16.0),
          UIHelper.getCustomRadioButtonVertical(_bloc.stream, list[0])
        ],
      ),
    );
  }

  _startSpace(BuildContext context) {
    return UIHelper.getTopEmptyContainer(
        MediaQuery.of(context).size.height / 4, false);
  }

  goNext(DesignDataProvider designDataProvider) {
    if (_sparFinishing.compareTo(ListHelper.getSparFinishingColorList()[0]) ==
        0) {
      designDataProvider.oceanBuilder.sparFinishing = _sparFinishing;
    } else {
      designDataProvider.oceanBuilder.sparFinishing = _sparFinishingCustom;
    }
    Navigator.of(context).pushNamed(SparDesignScreen.routeName);
    // debugPrint(
    // designDataProvider.oceanBuilder.sparFinishing.toString());
  }

  goBack() {
    Navigator.pop(context);
  }

  selectItem(int data) {
    _selectedColor.sink.add(data);
  }
}

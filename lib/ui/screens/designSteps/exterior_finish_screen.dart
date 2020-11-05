import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/exterior_color_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class ExteriorFinishScreen extends StatefulWidget {
  static const String routeName = '/exteriorFinish';

  @override
  _ExteriorFinishScreenState createState() => _ExteriorFinishScreenState();
}

class _ExteriorFinishScreenState extends State<ExteriorFinishScreen> {
  GenericBloc<String> _bloc =
      GenericBloc(ListHelper.getExteriorFinishList()[0]);

  List<String> list = ListHelper.getExteriorFinishList();
  List<String> priceList = ListHelper.getExteriorFinishPriceList();
  String _exteriorFinish; // = ListHelper.getExteriorFinishList()[0];

  @override
  void initState() {
    super.initState();

    _bloc.controller.listen((onData) {
      _exteriorFinish = onData;
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    // ScreenUtil _util = ScreenUtil();
    final DesignDataProvider designDataProvider =
        Provider.of<DesignDataProvider>(context);
    if (designDataProvider.oceanBuilder.exteriorFinish != null) {
      _bloc.sink.add(designDataProvider.oceanBuilder.exteriorFinish);
      _exteriorFinish = designDataProvider.oceanBuilder.exteriorFinish;
    }
    return Container(
      decoration: BoxDecoration(gradient: blueBackgroundGradient),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _topBar(),
            _mainContent(),
            _bottomBar(designDataProvider)
          ],
        ),
      ),
    );
  }

  Row _mainContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[_colorRadioButtonMatt(), _colorRadioButtonGloss()],
    );
  }

  Appbar _topBar() {
    return Appbar(
      ScreenTitle.EXTERIOR_FINISH,
      isDesignScreen: true,
    );
  }

  BottomClipper _bottomBar(DesignDataProvider designDataProvider) {
    return BottomClipper(ButtonText.BACK, ButtonText.NEXT, () => goBack(),
        () => goNext(designDataProvider));
  }

  InkWell _colorRadioButtonGloss() {
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
          UIHelper.getCustomRadioButtonVertical(_bloc.stream, list[1],
              price: priceList[1])
        ],
      ),
    );
  }

  InkWell _colorRadioButtonMatt() {
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

  goNext(DesignDataProvider designProvider) {
    designProvider.oceanBuilder.exteriorFinish = _exteriorFinish;
    Navigator.of(context).pushNamed(ExteriorColorScreen.routeName);
    // debugPrint(
    // designProvider.oceanBuilder.exteriorFinish.toString());
  }

  goBack() {
    Navigator.pop(context);
  }
}

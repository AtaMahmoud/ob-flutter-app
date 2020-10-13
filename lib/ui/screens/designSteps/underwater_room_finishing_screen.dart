import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/underwater_windows_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class UnderwaterRoomFinishingScreen extends StatefulWidget {
  static const String routeName = '/underwaterRoomFinishing';

  @override
  _UnderwaterRoomFinishingScreenState createState() =>
      _UnderwaterRoomFinishingScreenState();
}

class _UnderwaterRoomFinishingScreenState
    extends State<UnderwaterRoomFinishingScreen> {
  List<String> list = ListHelper.getUnderwaterRoomFinishingList();
  List<String> price = ListHelper.getUnderwaterRoomFinishPricingList();
  GenericBloc<String> _bloc =
      GenericBloc(ListHelper.getUnderwaterRoomFinishingList()[0]);

  String
      _underWaterRoomFinishing; // = ListHelper.getUnderwaterRoomFinishingList()[0];

  @override
  void initState() {
    super.initState();
    _bloc.controller.listen((onData) {
      _underWaterRoomFinishing = onData;
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

    final DesignDataProvider designDataProvider =
        Provider.of<DesignDataProvider>(context);

    if (designDataProvider.oceanBuilder.underWaterRoomFinishing != null) {
      _bloc.sink.add(designDataProvider.oceanBuilder.underWaterRoomFinishing);
      _underWaterRoomFinishing =
          designDataProvider.oceanBuilder.underWaterRoomFinishing;
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

  CustomScrollView _mainContent(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _startSpace(context),
        _radioButtonList(),
        _endSpace(),
      ],
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
      ScreenTitle.UNDERWATER_ROOM_FINISHING,
      isDesignScreen: true,
    );
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  SliverPadding _radioButtonList() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 8.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return InkWell(
          onTap: () => _bloc.sink.add(list[index]),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: UIHelper.getCustomRadioButtonHorizontal(
                _bloc.stream, list[index], price[index]),
          ),
        );
      }, childCount: list.length)),
    );
  }

  _startSpace(BuildContext context) {
    return UIHelper.getTopEmptyContainer(MediaQuery.of(context).size.height / 2, true);
  }

  goNext(DesignDataProvider designDataProvider) {
    designDataProvider.oceanBuilder.underWaterRoomFinishing =
        _underWaterRoomFinishing;
    Navigator.of(context).pushNamed(UnderwaterWindowsScreen.routeName);
  }

  goBack() {
    Navigator.pop(context);
  }
}

import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/clean_water_level_indicator_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class FathometerScreen extends StatefulWidget {
  static const String routeName = '/fathometer';

  @override
  _FathometerScreenState createState() => _FathometerScreenState();
}

class _FathometerScreenState extends State<FathometerScreen> {
  List<String> selectedItem = List();

  List<String> list = ListHelper.getFathometerList();
  List<String> price = ListHelper.getFathometerPricingList();
  String subtitle = ListHelper.getFathometerSubtitle();
  GenericBloc<List<String>> _bloc = GenericBloc(null);

  bool _hasFathometer = false;

  @override
  void initState() {
    super.initState();
    _bloc.controller.listen((onData) {
      _hasFathometer = onData != null && onData.length > 0;
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

    if (designDataProvider.oceanBuilder.hasFathometer != null) {
      _hasFathometer = designDataProvider.oceanBuilder.hasFathometer;
      if (_hasFathometer)
        _bloc.sink.add(list);
      else
        _bloc.sink.add(null);
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
        _checkBoxList(),
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
      ScreenTitle.FATHOMETER,
      isDesignScreen: true,
    );
  }

  SliverList _checkBoxList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return InkWell(
        onTap: () => selectItem(list[index]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: UIHelper.getCustomCheckbox(
              _bloc.stream, list[index], price[index],
              isVertical: true, subtitle: subtitle),
        ),
      );
    }, childCount: list.length));
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  _startSpace(BuildContext context) {
    return UIHelper.getTopEmptyContainer(MediaQuery.of(context).size.height / 2, true);
  }

  goNext(DesignDataProvider designDataProvider) {
    designDataProvider.oceanBuilder.hasFathometer = _hasFathometer;
    Navigator.of(context).pushNamed(CleanWaterLevelIndicatorScreen.routeName);
    // debugPrint(designDataProvider.oceanBuilder.hasFathometer.toString());
  }

  goBack() {
    Navigator.pop(context);
  }

  selectItem(String data) {
    selectedItem.contains(data)
        ? selectedItem.remove(data)
        : selectedItem.add(data);

    _bloc.sink.add(selectedItem);
  }
}

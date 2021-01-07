import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/underwater_room_finishing_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class PowerScreen extends StatefulWidget {
  static const String routeName = '/power';

  @override
  _PowerScreenState createState() => _PowerScreenState();
}

class _PowerScreenState extends State<PowerScreen> {
  List<String> rbList = ListHelper.getPowerRbList();
  List<String> cbList = ListHelper.getPowerCbList();
  List<String> rbPrice = ListHelper.getPowerRbPricingList();
  List<String> cbPrice = ListHelper.getPowerCbPricingList();
  List<String> selectedList = List();
  GenericBloc<String> _rbBloc = GenericBloc(ListHelper.getPowerRbList()[0]);
  GenericBloc<List<String>> _cbBloc = GenericBloc(null);

  String _power; // = ListHelper.getPowerRbList()[0];
  List<String> _additionals = []; // = ListHelper.getPowerCbList();

  @override
  void initState() {
    super.initState();
    _rbBloc.controller.listen((onData) {
      _power = onData;
    });

    _cbBloc.controller.listen((onData) {
      _additionals = onData;
    });
  }

  @override
  void dispose() {
    _rbBloc.dispose();
    _cbBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;

    final DesignDataProvider designDataProvider =
        Provider.of<DesignDataProvider>(context);

    if (designDataProvider.oceanBuilder.power != null) {
      _rbBloc.sink.add(designDataProvider.oceanBuilder.power);
      _power = designDataProvider.oceanBuilder.power;
    }
    if (designDataProvider.oceanBuilder.powerUtilities != null) {
      _cbBloc.sink.add(designDataProvider.oceanBuilder.powerUtilities);
      _additionals = designDataProvider.oceanBuilder.powerUtilities;
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
        _radioButtonRack(),
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

  Appbar _topBar() => Appbar(
        ScreenTitle.POWER,
        isDesignScreen: true,
      );

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  SliverList _checkBoxList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return InkWell(
        onTap: () => selectItem(cbList[index]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: UIHelper.getCustomCheckbox(
              _cbBloc.stream, cbList[index], cbPrice[index]),
        ),
      );
    }, childCount: cbList.length));
  }

  SliverPadding _radioButtonRack() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 8.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return InkWell(
          onTap: () => _rbBloc.sink.add(rbList[index]),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: UIHelper.getCustomRadioButtonHorizontal(
                _rbBloc.stream, rbList[index], rbPrice[index]),
          ),
        );
      }, childCount: rbList.length)),
    );
  }

  _startSpace(BuildContext context) => UIHelper.getTopEmptyContainer(
      MediaQuery.of(context).size.height / 2, true);

  selectItem(String data) {
    selectedList.contains(data)
        ? selectedList.remove(data)
        : selectedList.add(data);

    _cbBloc.sink.add(selectedList);
  }

  goNext(DesignDataProvider designDataProvider) {
    designDataProvider.oceanBuilder.power = _power;
    designDataProvider.oceanBuilder.powerUtilities = _additionals;
    if (designDataProvider.oceanBuilder.powerUtilities == null) {
      designDataProvider.oceanBuilder.powerUtilities = [];
    }
    Navigator.of(context).pushNamed(UnderwaterRoomFinishingScreen.routeName);
  }

  goBack() {
    Navigator.pop(context);
  }
}

import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/master_bedroom_floor_finishing_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class SoundSystemScreen extends StatefulWidget {
  static const String routeName = '/soundSystem';

  @override
  _SoundSystemScreenState createState() => _SoundSystemScreenState();
}

class _SoundSystemScreenState extends State<SoundSystemScreen> {
  List<String> selectedList = List();

  List<String> list = ListHelper.getSoundSystemList();
  List<String> price = ListHelper.getSoundSystemPricingList();
  GenericBloc<List<String>> _bloc = GenericBloc(null);

  List<String> _soundSystems = []; // = ListHelper.getSoundSystemList();

  @override
  void initState() {
    super.initState();
    _bloc.controller.listen((onData) {
      _soundSystems = onData;
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

    if (designDataProvider.oceanBuilder.soundSystem != null) {
      _bloc.sink.add(designDataProvider.oceanBuilder.soundSystem);
      _soundSystems = designDataProvider.oceanBuilder.soundSystem;
    }

    return Container(
      decoration: BoxDecoration(gradient: blueBackgroundGradient),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _mainContent(context),
            _topBar(),
            _bottombar(designDataProvider)
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

  SliverPadding _checkBoxList() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 8.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return InkWell(
          onTap: () => selectItem(list[index]),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: UIHelper.getCustomCheckbox(
                _bloc.stream, list[index], price[index]),
          ),
        );
      }, childCount: list.length)),
    );
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  Positioned _bottombar(DesignDataProvider designDataProvider) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: BottomClipper(ButtonText.BACK, ButtonText.NEXT, () => goBack(),
            () => goNext(designDataProvider)));
  }

  Appbar _topBar() => Appbar(
        ScreenTitle.SOUND_SYSTEM,
        isDesignScreen: true,
      );

  _startSpace(BuildContext context) {
    return UIHelper.getTopEmptyContainer(MediaQuery.of(context).size.height / 2, true);
  }

  goNext(DesignDataProvider designDataProvider) {
    designDataProvider.oceanBuilder.soundSystem = _soundSystems;
    if (designDataProvider.oceanBuilder.soundSystem == null) {
      designDataProvider.oceanBuilder.soundSystem = [];
    }
    Navigator.of(context)
        .pushNamed(MasterBedroomFloorFinishingScreen.routeName);
    // debugPrint(designDataProvider.oceanBuilder.soundSystem.toString());
  }

  goBack() {
    Navigator.pop(context);
  }

  selectItem(String data) {
    selectedList.contains(data)
        ? selectedList.remove(data)
        : selectedList.add(data);

    _bloc.sink.add(selectedList);
  }
}

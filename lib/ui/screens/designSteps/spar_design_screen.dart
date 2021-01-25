import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/deck_enclosure_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class SparDesignScreen extends StatefulWidget {
  static const String routeName = '/sparDesign';
  static const pageKey = Key('sparDesign');

  @override
  _SparDesignScreenState createState() => _SparDesignScreenState();
}

class _SparDesignScreenState extends State<SparDesignScreen> {
  List<String> list = ListHelper.getSparDesignList();
  List<String> price = ListHelper.getSparDesignPricingList();
  GenericBloc<String> _bloc = GenericBloc(ListHelper.getSparDesignList()[0]);

  String _sparDesign; // = ListHelper.getSparDesignList()[0];

  @override
  void initState() {
    super.initState();
    _bloc.controller.listen((onData) {
      _sparDesign = onData;
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

    if (designDataProvider.oceanBuilder.sparDesign != null) {
      _bloc.sink.add(designDataProvider.oceanBuilder.sparDesign);
      _sparDesign = designDataProvider.oceanBuilder.sparDesign;
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
        _topImage(context),
        _radioButtonListStrip(),
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
      ScreenTitle.SPAR_DESIGN,
      isDesignScreen: true,
    );
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  SliverPadding _radioButtonListStrip() {
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

  SliverToBoxAdapter _topImage(BuildContext context) {
    return SliverToBoxAdapter(
      child: UIHelper.getImageContainer(MediaQuery.of(context).size.height / 2,
          MediaQuery.of(context).size.width),
    );
  }

  goNext(DesignDataProvider designDataProvider) {
    designDataProvider.oceanBuilder.sparDesign = _sparDesign;
    Navigator.of(context).pushNamed(DeckEnclosureScreen.routeName);
    // debugPrint(
    // designDataProvider.oceanBuilder.sparDesign.toString());
  }

  goBack() {
    Navigator.pop(context);
  }
}

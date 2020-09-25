import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/designSteps/bed_living_room_enclosure_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class DeckEnclosureScreen extends StatefulWidget {
  static const String routeName = '/deckEnclosure';

  @override
  _DeckEnclosureScreenState createState() => _DeckEnclosureScreenState();
}

class _DeckEnclosureScreenState extends State<DeckEnclosureScreen> {
  List<String> list = ListHelper.getDeckEnclosureList();
  List<String> price = ListHelper.getDeckEnclosurePricingList();
  GenericBloc<String> _bloc = GenericBloc(ListHelper.getDeckEnclosureList()[0]);

  String _deckEnclosure; // = ListHelper.getDeckEnclosureList()[0];

  @override
  void initState() {
    super.initState();
    _bloc.controller.listen((onData) {
      _deckEnclosure = onData;
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

    if (designDataProvider.oceanBuilder.deckEnclosure != null) {
      _bloc.sink.add(designDataProvider.oceanBuilder.deckEnclosure);
      _deckEnclosure = designDataProvider.oceanBuilder.deckEnclosure;
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
        _seaPodImage(context),
        _materialList(),
        _endSpace(),
      ],
    );
  }

  SliverPadding _materialList() {
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

  SliverToBoxAdapter _seaPodImage(BuildContext context) {
    return SliverToBoxAdapter(
      child: UIHelper.getImageContainer(MediaQuery.of(context).size.height / 2,
          MediaQuery.of(context).size.width),
    );
  }

  _endSpace() => UIHelper.getTopEmptyContainer(90, false);

  Appbar _topBar() {
    return Appbar(
      ScreenTitle.DECK_ENCLOSURE,
      isDesignScreen: true,
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

  goNext(DesignDataProvider designDataProvider) {
    designDataProvider.oceanBuilder.deckEnclosure = _deckEnclosure;
    Navigator.of(context).pushNamed(BedroomLivingroomEnclosureScreen.routeName);
    // debugPrint(
    // designDataProvider.oceanBuilder.deckEnclosure.toString());
  }

  goBack() {
    Navigator.pop(context);
  }
}

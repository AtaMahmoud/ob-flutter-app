import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/singletons/headers_manager.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/home/home_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/your_info_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class DeckFloorFinishMaterialsScreen extends StatefulWidget {
  static const String routeName = '/deckFloorFinishMaterials';

  @override
  _DeckFloorFinishMaterialsScreenState createState() =>
      _DeckFloorFinishMaterialsScreenState();
}

class _DeckFloorFinishMaterialsScreenState
    extends State<DeckFloorFinishMaterialsScreen> {
  List<String> list = ListHelper.getDeckFloorFinishMaterialList();
  List<String> price = ListHelper.getDeckFloorFinishMaterialPricingList();
  GenericBloc<String> _bloc =
      GenericBloc(ListHelper.getDeckFloorFinishMaterialList()[0]);

  String _deckFloorFinishMaterials =
      ListHelper.getDeckFloorFinishMaterialList()[0];

  HeadersManager _headerManager;

  @override
  void initState() {
    super.initState();
    _bloc.controller.listen((onData) {
      _deckFloorFinishMaterials = onData;
    });
    _headerManager = HeadersManager.getInstance();
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
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    _headerManager.initalizeAuthenticatedUserHeaders();
    if (designDataProvider.oceanBuilder.deckFloorFinishMaterials != null) {
      _bloc.sink.add(designDataProvider.oceanBuilder.deckFloorFinishMaterials);
      _deckFloorFinishMaterials =
          designDataProvider.oceanBuilder.deckFloorFinishMaterials;
    }

    return Container(
      decoration: BoxDecoration(gradient: blueBackgroundGradient),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                UIHelper.getTopEmptyContainer(
                    MediaQuery.of(context).size.height / 2, true),
                userProvider.isLoading
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.only(top: 8.0),
                        sliver: SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                          return InkWell(
                            onTap: () => _bloc.sink.add(list[index]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              child: UIHelper.getCustomRadioButtonHorizontal(
                                  _bloc.stream, list[index], price[index]),
                            ),
                          );
                        }, childCount: list.length)),
                      ),
                UIHelper.getTopEmptyContainer(90, false),
              ],
            ),
            Appbar(
              ScreenTitle.DECK_FLOOR_FINISH_MATERIALS,
              isDesignScreen: true,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BottomClipper(
                    ButtonText.BACK,
                    ButtonText.NEXT,
                    () => goBack(userProvider),
                    () => goNext(designDataProvider, userProvider))),
          ],
        ),
      ),
    );
  }

  goNext(DesignDataProvider designDataProvider, UserProvider userProvider) {
    designDataProvider.oceanBuilder.deckFloorFinishMaterials =
        _deckFloorFinishMaterials;
    if (userProvider.isLoading) return;
    // debugPrint('in deck_floor_finish_material_screen --- ${userProvider.isAuthenticatedUser}');
    if (userProvider.authenticatedUser != null &&
        userProvider.isAuthenticatedUser) {
      String existingUserId = userProvider.authenticatedUser.userID;

      //  // debugPrint("authenticated user is not null --- $existingUserId  and --- ${userProvider.isAuthenticatedUser}");
      userProvider
          .createSeaPod(designDataProvider.oceanBuilder)
          .then((responseStatus) {
        if (responseStatus.status == 200) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        } else {
          // // debugPrint('Adding OB to existing user failed');
          showInfoBar(parseErrorTitle(responseStatus.code),
              responseStatus.message, context);
        }
      });
    } else {
      // designDataProvider.oceanBuilder.deckFloorFinishMaterials =
      //     _deckFloorFinishMaterials;
      Navigator.of(context).pushNamed(YourInfoScreen.routeName);
      // debugPrint(
      // designDataProvider.oceanBuilder.deckFloorFinishMaterials.toString());
    }
  }

  goBack(UserProvider userProvider) {
    // // debugPrint('deck floor -- isLoading -- ${userProvider.isLoading}');
    if (userProvider.isLoading) return;
    Navigator.pop(context);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/iot/light_control_data_provider.dart';
import 'package:ocean_builder/ui/screens/iot/model/light.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:provider/provider.dart';

class LightControllerScreen extends StatefulWidget {
  static const String routeName = '/light_screen';

  @override
  _LightControllerScreenState createState() => _LightControllerScreenState();
}

class _LightControllerScreenState extends State<LightControllerScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorConstants.BKG_GRADIENT),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Appbar(
                  ScreenTitle.LIGHTS,
                  isDesignScreen: true,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 64.w),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: SpaceH32(),
                        ),
                        FutureBuilder<List<Light>>(
                            future: Provider.of<LightControlDataProvider>(
                                    context,
                                    listen: false)
                                .getAllLigts(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SliverToBoxAdapter(
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color:
                                              ColorConstants.TOP_CLIPPER_START),
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.hasData) {
                                return Container(
                                  child: GridView.builder(
                                    itemCount: snapshot.data.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: (orientation ==
                                                    Orientation.portrait)
                                                ? 2
                                                : 3),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return new Card(
                                        child: new GridTile(
                                          footer: new Text(
                                              snapshot.data[index].desc),
                                          child: new Text(snapshot.data[index]
                                              .ata), //just for testing, will fill with image later
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }

                              return SliverToBoxAdapter(
                                child: Container(),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                BottomClipper(ButtonText.BACK, '', goBack, () {},
                    isNextEnabled: false)
              ],
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  goBack() {
    Navigator.pop(context);
  }
}

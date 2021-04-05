import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: CustomScrollView(
                      scrollDirection: Axis.vertical,
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
                                  child: _progressIndicitaorView(),
                                );
                              }

                              if (snapshot.hasData &&
                                  snapshot.data.length > 0) {
                                return SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: (orientation ==
                                                  Orientation.portrait)
                                              ? 2
                                              : 3),
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                    return _lightItemView(snapshot, index);
                                  }, childCount: snapshot.data.length),
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

  Center _progressIndicitaorView() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorConstants.TOP_CLIPPER_START_DARK.withOpacity(.9)),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Card _lightItemView(AsyncSnapshot<List<Light>> snapshot, int index) {
    return new Card(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: ColorConstants.BCKG_COLOR_END,
      child: new GridTile(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(4),
                child: SvgPicture.asset(
                  ImagePaths.svgBulbLarge,
                  width: 192.w,
                  // height: 48.w,
                  color: Color(snapshot.data[index].color),
                  fit: BoxFit.cover,
                  cacheColorFilter: true,
                  allowDrawingOutsideViewBox: true,
                  alignment: Alignment.center,
                  matchTextDirection: true,
                )),
            Container(
                child: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: new Text(snapshot.data[index].ata),
            )),
          ],
        ),
        footer: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(snapshot.data[index].status.toString()),
        ),
      ),
    );
  }

  goBack() {
    Navigator.pop(context);
  }
}

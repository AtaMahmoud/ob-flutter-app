import 'package:flutter/material.dart';
import 'package:ocean_builder/route_info/page_manager.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key key}) : super(key: key);

  static const pageKey = Key('ResultScreen');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Result Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This page shows how to return value from a page',
              textAlign: TextAlign.center,
            ),
            SpaceH32(),
            RaisedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Result with true via Navigator.pop'),
            ),
            SpaceH32(),
            RaisedButton(
              onPressed: () => PageManager.of(context).returnWith(true),
              child: Text('Result with true via custom method'),
            ),
          ],
        ),
      ),
    );
  }
}

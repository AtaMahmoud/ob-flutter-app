import 'package:flutter/material.dart';

class ProgressIndicatorBoxAdapter extends StatelessWidget {
  const ProgressIndicatorBoxAdapter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
  }
}
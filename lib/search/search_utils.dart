import 'package:flutter/material.dart';
import 'package:ocean_builder/core/models/search_item.dart';

void navigateTo(BuildContext context, SearchItem item) {
  Navigator.of(context).pop(item);
}

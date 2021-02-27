import 'package:hive/hive.dart';

part 'search_item.g.dart';

@HiveType(typeId: 0)
class SearchItem {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String routeName;
  @HiveField(2)
  final String shortDesc;
  SearchItem({this.name, this.routeName, this.shortDesc});
}

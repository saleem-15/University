import 'package:hive/hive.dart';

part 'link.g.dart';

@HiveType(typeId: 3)
class Link {
  @HiveField(1)
  String url;

  @HiveField(2)
  String description;
  //photo maybe

  Link({
    required this.url,
    required this.description,
  });
}

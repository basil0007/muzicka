// ignore: file_names
import 'package:hive/hive.dart';
part 'songModel.g.dart';

@HiveType(typeId: 0)
class Songs {
  @HiveField(0)
  String? songname;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  int? duration;
  @HiveField(3)
  String? songurl;
  @HiveField(4)
  int? id;

  Songs(
      {required this.songname,
      required this.artist,
      required this.duration,
      required this.id,
      required this.songurl,
      String? songuri});
}

String boxname = 'Songs';

class SongBox {
  static Box<Songs>? _box;
  static Box<Songs> getInstance() {
    return _box ??= Hive.box(boxname);
  }
}

@HiveType(typeId: 1)
class Favorites {
  @HiveField(0)
  String? songname;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  int? duration;
  @HiveField(3)
  String? songuri;
  @HiveField(4)
  int? id;

  // ignore: prefer_typing_uninitialized_variables
  static var values;

  Favorites(
      {required this.songname,
      required this.artist,
      required this.duration,
      required this.songuri,
      required this.id});
}

@HiveType(typeId: 2)
class Playlists {
  @HiveField(0)
  String? playlistname;
  @HiveField(1)
  List<Songs>? playlistssongs;

  Playlists({required this.playlistname, required this.playlistssongs});
}

@HiveType(typeId: 3)
class RecentlyPlayed {
  @HiveField(0)
  String? songname;

  @HiveField(1)
  String? artist;

  @HiveField(2)
  int? duration;

  @HiveField(3)
  String? songuri;

  @HiveField(4)
  int? id;

  RecentlyPlayed(
      {required this.songname,
      required this.artist,
      required this.duration,
      required this.songuri,
      required this.id});
}

@HiveType(typeId: 4)
class MostlyPlayed {
  @HiveField(0)
  String songname;

  @HiveField(1)
  String? artist;

  @HiveField(2)
  int? duration;

  @HiveField(3)
  String? songuri;

  @HiveField(4)
  int count;

  @HiveField(5)
  int? id;

  MostlyPlayed(
      {required this.songname,
      required this.songuri,
      required this.duration,
      required this.artist,
      required this.count,
      required this.id});
}

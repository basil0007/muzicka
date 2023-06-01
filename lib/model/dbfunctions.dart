import 'package:hive/hive.dart';
import 'package:muzicka/model/songModel.dart';

late Box<Favorites> favSongsBox;
openFavoriteSongsDb() async {
  favSongsBox = await Hive.openBox('favoritesongs');
}

late Box<Playlists> playlistsBox;
openPlaylist() async {
  playlistsBox = await Hive.openBox('Playlistsongs');
}

late Box<RecentlyPlayed> recentlyPlayedBox;
openrecentlyplayed() async {
  recentlyPlayedBox = await Hive.openBox('Recentlyplayedsongs');
}

late Box<MostlyPlayed> mostlyPlayedBox;
openmostlyplayed() async {
  mostlyPlayedBox = await Hive.openBox('Mostlyplayedsongs');
}

updateRecentlyPlayed(RecentlyPlayed song) {
  List<RecentlyPlayed> recentList = recentlyPlayedBox.values.toList();
  bool isNotPresent = recentList.where((element) {
    //check whether the current song is in the recently played
    //if not then isNotPresent becomes true otherwise false
    return element.songname == song.songname;
  }).isEmpty;
  if (isNotPresent == true) {
    recentlyPlayedBox.add(song); //if it is not present then add it
  } else {
    int indexRecent = recentList.indexWhere((element) =>
        element.songname == song.songname); //if it is present find its index
    recentlyPlayedBox.deleteAt(indexRecent); //delete the song at that index
    recentlyPlayedBox.add(song); // add again the song to the recentlyPlayedBox
  }
}

updateMostlyPlayed(MostlyPlayed song) {
  List<MostlyPlayed> mostlyList = mostlyPlayedBox.values.toList();
  bool isNotPresent = mostlyList.where((element) {
    //check whether the current song is in the recently played
    //if not then isNotPresent becomes true otherwise false
    return element.songname == song.songname;
  }).isEmpty;
  if (isNotPresent == true) {
    mostlyPlayedBox.add(song); //if it is not present then add it
  } else {
    int indexRecent = mostlyList.indexWhere((element) =>
        element.songname == song.songname); //if it is present find its index
    int count = mostlyList[indexRecent].count; // find the count of current song
    song.count = count + 1; // increment by 1 and update box
    mostlyPlayedBox.put(
        indexRecent, song); //update the box by the new count of the song
  }
}

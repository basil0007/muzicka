// ignore: file_names
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:muzicka/model/dbfunctions.dart';
import 'package:muzicka/pages/MusicPage.dart';
import 'package:muzicka/pages/add_to_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:lottie/lottie.dart';
import 'package:muzicka/model/songModel.dart';

final searchBox = SongBox.getInstance();
final TextEditingController searchController = TextEditingController();
late List<Songs> searchAllSong;
List<Songs> searchListingSong = List.from(searchAllSong);
List<Audio> searchedSongs = [];
final songBox = Hive.box<Songs>(boxname);
List<Songs> dbSongList = [];
List<Favorites> favDbSongs = [];
AssetsAudioPlayer searchPlayer = AssetsAudioPlayer.withId('0');

// ignore: camel_case_types
class searchScreen extends StatefulWidget {
  const searchScreen({super.key});

  @override
  State<searchScreen> createState() => _searchScreenState();
}

// ignore: camel_case_types
class _searchScreenState extends State<searchScreen> {
  @override
  void initState() {
    searchAllSong = searchBox.values.toList();
    favDbSongs = favSongsBox.values.toList();
    dbSongList = songBox.values.toList();
    for (var element in searchListingSong) {
      searchedSongs.add(Audio.file(element.songurl.toString(),
          metas: Metas(
              artist: element.artist,
              id: element.id.toString(),
              title: element.songname.toString())));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final kHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/muzicka dj image.jpg'))),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.5),
              Colors.black.withOpacity(0.2)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              CupertinoIcons.back,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search your song',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color:
                                  Colors.white, // customize border color here
                              width: 2.0, // customize border width here
                            ),
                            borderRadius: BorderRadius.circular(
                                10.0), // customize border radius here
                          ),
                          labelText: 'What you want here?',
                          labelStyle: const TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color:
                                  Colors.white, // customize border color here
                              width: 2.0, // customize border width here
                            ),
                            borderRadius: BorderRadius.circular(
                                10.0), // customize border radius here
                          ),
                        ),
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchListingSong = searchAllSong
                                .where((element) => element.songname!
                                    .toUpperCase()
                                    .contains(value.toUpperCase()))
                                .toList();
                            log(searchListingSong.toString());
                            searchedSongs.clear();
                            for (var element in searchListingSong) {
                              searchedSongs.add(
                                Audio.file(
                                  element.songurl.toString(),
                                  metas: Metas(
                                    artist: element.artist,
                                    title: element.songname,
                                    id: element.id.toString(),
                                  ),
                                ),
                              );
                            }
                          });
                          // log(searchListingSong.toString());
                        },
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      (searchListingSong.isEmpty)
                          ? Center(
                              child: Padding(
                              padding: EdgeInsets.only(top: kHeight * 0.2),
                              child: Lottie.asset(
                                  "assets/animations/127760-nothing.json"),
                            ))
                          : SizedBox(
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const Divider();
                                },
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: searchListingSong.length,
                                itemBuilder: (context, index) {
                                  favDbSongs = favSongsBox.values.toList();
                                  return ListTile(
                                    tileColor: const Color(0xFF30314D),
                                    onTap: () {
                                      searchPlayer.open(
                                          Playlist(
                                              audios: searchedSongs,
                                              startIndex: index),
                                          showNotification: true,
                                          loopMode: LoopMode.playlist,
                                          headPhoneStrategy:
                                              HeadPhoneStrategy.pauseOnUnplug);
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return MusicPage(
                                              index: searchAllSong.indexWhere(
                                                  (element) =>
                                                      element.id ==
                                                      searchListingSong[index]
                                                          .id));
                                        },
                                      ));
                                    },
                                    trailing: PopupMenuButton<String>(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(1.0),
                                      onSelected: (String value) {},
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: "Favorites",
                                          child: (favDbSongs
                                                  .where((element) =>
                                                      element.id ==
                                                      dbSongList[index].id)
                                                  .isEmpty)
                                              ? TextButton(
                                                  onPressed: () async {
                                                    await favSongsBox.add(
                                                        Favorites(
                                                            songname:
                                                                dbSongList[
                                                                        index]
                                                                    .songname,
                                                            artist:
                                                                dbSongList[
                                                                        index]
                                                                    .artist,
                                                            duration:
                                                                dbSongList[
                                                                        index]
                                                                    .duration,
                                                            songuri:
                                                                dbSongList[
                                                                        index]
                                                                    .songurl,
                                                            id: dbSongList[
                                                                    index]
                                                                .id));
                                                    // ignore: use_build_context_synchronously
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Added to Favorites'),
                                                        duration: Duration(
                                                            milliseconds: 600),
                                                      ),
                                                    );
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                    setState(() {});
                                                  },
                                                  child: const Text(
                                                      'Add to favorites'),
                                                )
                                              : TextButton(
                                                  onPressed: () async {
                                                    int delIndex = favDbSongs
                                                        .indexWhere((element) =>
                                                            element.id ==
                                                            dbSongList[index]
                                                                .id);
                                                    await favSongsBox
                                                        .deleteAt(delIndex);

                                                    // ignore: use_build_context_synchronously
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Removed from Favorites'),
                                                        duration: Duration(
                                                            milliseconds: 600),
                                                      ),
                                                    );
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                    setState(() {});
                                                  },
                                                  child: const Text(
                                                      'Remove from favorites'),
                                                ),
                                        ),
                                        PopupMenuItem<String>(
                                            value: "Playlists",
                                            child: AddToPlaylists(
                                                songIndex: index)),
                                      ],
                                    ),
                                    leading: QueryArtworkWidget(
                                      artworkFit: BoxFit.cover,
                                      id: searchListingSong[index].id!,
                                      type: ArtworkType.AUDIO,
                                      artworkQuality: FilterQuality.high,
                                      size: 2000,
                                      quality: 100,
                                      artworkBorder: BorderRadius.circular(10),
                                      nullArtworkWidget: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                  color: Colors.white)),
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(
                                            Icons.music_note,
                                            size: 40,
                                            color: Colors.white,
                                          )),
                                    ),
                                    title: MarqueeText(
                                      text: TextSpan(
                                          text:
                                              searchListingSong[index].songname,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      speed: 15,
                                      textDirection: TextDirection.ltr,
                                    ),
                                    subtitle: MarqueeText(
                                      text: TextSpan(
                                          text:
                                              searchListingSong[index].artist!,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      speed: 15,
                                      textDirection: TextDirection.ltr,
                                    ),
                                  );
                                },
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

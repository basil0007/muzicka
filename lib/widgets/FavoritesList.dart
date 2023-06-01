// ignore: file_names
import 'dart:developer';
import 'package:lottie/lottie.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:muzicka/model/dbfunctions.dart';
// ignore: depend_on_referenced_packages
import 'package:marquee_text/marquee_text.dart';
import 'package:muzicka/model/songModel.dart';
import 'package:muzicka/pages/MusicPage.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenFavorites extends StatefulWidget {
  const ScreenFavorites({super.key});

  @override
  State<ScreenFavorites> createState() => _ScreenFavoritesState();
}

class _ScreenFavoritesState extends State<ScreenFavorites> {
  late int currentIndex;
  final box = SongBox.getInstance();
  late List<Songs> allDbSongs;
  List<Audio> convertFavSongs = [];
  List<Favorites> favDbSongs = [];
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  void initState() {
    allDbSongs = box.values.toList();
    favDbSongs = favSongsBox.values.toList();
    for (var element in favDbSongs) {
      convertFavSongs.add(Audio.file(element.songuri!,
          metas: Metas(
              artist: element.artist,
              title: element.songname,
              id: element.id.toString())));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('favorite list<<<<<<<<<<<<<>>>>>>>>>>>>>>.');
    final height1 = MediaQuery.of(context).size.height;
    favDbSongs = favSongsBox.values.toList();
    setState(() {});

    return (favDbSongs.isEmpty)
        ? Center(
            child: Padding(
                padding: EdgeInsets.only(bottom: height1 * 0.08),
                child: LottieBuilder.asset(
                  "assets/animations/127760-nothing.json",
                  height:
                      300, // Adjust the height according to your desired size
                  width: 300, // Adjust the width according to your desired size
                )))
        : Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: favDbSongs.length + 1,
              itemBuilder: (context, index) {
                favDbSongs = favSongsBox.values.toList();
                if (index == favDbSongs.length) {
                  return SizedBox(
                    height: height1 * 0.08,
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF30314D),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                      onTap: () async {
                        audioPlayer.open(
                            Playlist(
                                audios: convertFavSongs, startIndex: index),
                            showNotification: true,
                            headPhoneStrategy:
                                HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                            loopMode: LoopMode.playlist);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MusicPage(
                              index: allDbSongs.indexWhere((element) =>
                                  element.id == favDbSongs[index].id),
                            ),
                          ),
                        );
                        setState(() {});
                      },
                      leading: QueryArtworkWidget(
                        artworkFit: BoxFit.cover,
                        id: favDbSongs[index].id!,
                        type: ArtworkType.AUDIO,
                        artworkQuality: FilterQuality.high,
                        size: 2000,
                        quality: 100,
                        artworkBorder: BorderRadius.circular(10),
                        nullArtworkWidget: Image.asset(
                            'assets/logo.png.png', // Replace with your custom image path
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover),
                      ),
                      title: MarqueeText(
                        text: TextSpan(
                            text: favDbSongs[index].songname,
                            style: const TextStyle(color: Colors.white)),
                        speed: 15,
                        textDirection: TextDirection.ltr,
                      ),
                      subtitle: MarqueeText(
                        text: TextSpan(
                            text: favDbSongs[index].artist!,
                            style: const TextStyle(color: Colors.white)),
                        speed: 15,
                        textDirection: TextDirection.ltr,
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext ctx) {
                                  return AlertDialog(
                                    title: const Text('Remove from Favorites'),
                                    content: const Text('Are You Sure?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: const Text('Cancel')),
                                      ElevatedButton(
                                          onPressed: () async {
                                            Navigator.of(ctx).pop();
                                            ScaffoldMessenger.of(ctx)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Removed from Favorites'),
                                                duration:
                                                    Duration(milliseconds: 600),
                                              ),
                                            );
                                            convertFavSongs.removeAt(index);
                                            favDbSongs.removeAt(index);
                                            await favSongsBox.deleteAt(index);
                                            setState(() {});
                                          },
                                          child: const Text('Remove'))
                                    ],
                                  );
                                });
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white54,
                          ))),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          );
  }
}

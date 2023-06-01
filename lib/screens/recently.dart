import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:muzicka/model/dbfunctions.dart';
import 'package:muzicka/model/songModel.dart';
import 'package:muzicka/pages/add_to_playlist.dart';
import 'package:muzicka/pages/searchScreen.dart';
import 'package:muzicka/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
// ignore: depend_on_referenced_packages
import 'package:marquee_text/marquee_text.dart';
import '../favorites/add_to_fav.dart';
import 'package:lottie/lottie.dart';

class ScreenRecently extends StatefulWidget {
  const ScreenRecently({Key? key}) : super(key: key);

  @override
  State<ScreenRecently> createState() => _ScreenRecentlyState();
}

class _ScreenRecentlyState extends State<ScreenRecently> {
  String selectedItem = "Favorites";
  late int currentIndex;
  final box = SongBox.getInstance();
  late List<Songs> allDbSongs;
  List<Audio> convertRSongs = [];
  List<RecentlyPlayed> recentlyDbSongs = [];
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");

  @override
  void initState() {
    super.initState();
    allDbSongs = box.values.toList();
    recentlyDbSongs = recentlyPlayedBox.values.toList().reversed.toList();
    for (var element in recentlyDbSongs) {
      convertRSongs.add(Audio.file(element.songuri!,
          metas: Metas(
              artist: element.artist,
              title: element.songname,
              id: element.id.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height1 = MediaQuery.of(context).size.height;
    final width1 = MediaQuery.of(context).size.width;
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const searchScreen()));
                  },
                  icon: const Icon(Icons.search_sharp,
                      size: 22, color: Colors.white),
                ),
                SizedBox(
                  width: width1 * 0.01,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title:
                                const Text('Clear Your Recently Played Songs'),
                            content: const Text('Are You Sure?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text('Cancel')),
                              ElevatedButton(
                                  onPressed: () {
                                    recentlyPlayedBox.clear();
                                    recentlyDbSongs.clear();
                                    setState(() {});
                                    Navigator.of(ctx).pop();
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      const SnackBar(
                                        content: Text('Cleared Your Songs'),
                                        duration: Duration(milliseconds: 600),
                                      ),
                                    );
                                  },
                                  child: const Text('Clear'))
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.clear_all_sharp, size: 22),
                ),
                SizedBox(
                  width: width1 * 0.02,
                ),
              ],
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 22,
                ),
              ),
              title: const Text(
                'Recently Played',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            ),
            body: recentlyDbSongs.isEmpty
                ? Center(
                    child: Padding(
                        padding: EdgeInsets.only(bottom: height1 * 0.08),
                        child: Lottie.asset(
                            "assets/animations/127760-nothing.json")),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 5.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: recentlyDbSongs.length,
                      itemBuilder: (context, index) {
                        if (index == recentlyDbSongs.length - 1) {
                          return SizedBox(
                            height: height1 * 0.08,
                          );
                        }
                        RecentlyPlayed currentSong = recentlyDbSongs[index];
                        return ListTile(
                          tileColor: const Color(0xFF30314D),
                          onTap: () {
                            RecentlyPlayed recentlySong;
                            MostlyPlayed mostlySong;
                            recentlySong = RecentlyPlayed(
                                songname: currentSong.songname,
                                artist: currentSong.artist,
                                duration: currentSong.duration,
                                songuri: currentSong.songuri,
                                id: currentSong.id);
                            mostlySong = MostlyPlayed(
                                songname: currentSong.songname!,
                                songuri: currentSong.songuri,
                                duration: currentSong.duration,
                                artist: currentSong.artist,
                                count: 1,
                                id: currentSong.id);
                            updateRecentlyPlayed(recentlySong);
                            updateMostlyPlayed(mostlySong);
                            audioPlayer.open(
                              Playlist(
                                audios: convertRSongs,
                                startIndex: index,
                              ),
                              showNotification: true,
                              headPhoneStrategy:
                                  HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                              loopMode: LoopMode.playlist,
                            );
                            setState(() {});
                            showBottomSheet(
                              context: context,
                              builder: (context) {
                                return MiniPlayer(
                                  index: allDbSongs.indexWhere((element) =>
                                      element.id == currentSong.id),
                                );
                              },
                            );
                          },
                          leading: QueryArtworkWidget(
                            artworkFit: BoxFit.cover,
                            id: currentSong.id!,
                            type: ArtworkType.AUDIO,
                            artworkQuality: FilterQuality.high,
                            size: 2000,
                            quality: 100,
                            artworkBorder: BorderRadius.circular(10),
                            nullArtworkWidget: Container(
                              width: width1 * 0.134,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/logo.png.png',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          title: MarqueeText(
                            text: TextSpan(
                              text: currentSong.songname,
                              style: const TextStyle(color: Colors.white),
                            ),
                            speed: 15,
                            textDirection: TextDirection.ltr,
                          ),
                          subtitle: currentSong.artist == '<unknown>'
                              ? const Text(
                                  'Unknown Artist',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  currentSong.artist!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                          trailing: PopupMenuButton<String>(
                            color: Colors.white,
                            padding: const EdgeInsets.all(1.0),
                            onSelected: (String value) {
                              setState(() {
                                selectedItem = value;
                              });
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: "Favorites",
                                child: AddToFavorites(
                                  index: allDbSongs.indexWhere((element) =>
                                      element.id == currentSong.id),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: "Playlists",
                                child: AddToPlaylists(
                                  songIndex: allDbSongs.indexWhere((element) =>
                                      element.id == currentSong.id),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

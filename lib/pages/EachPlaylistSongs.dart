import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:muzicka/favorites/add_to_fav.dart';
import 'package:muzicka/model/dbfunctions.dart';
import 'package:muzicka/model/songModel.dart';
import 'package:muzicka/pages/searchScreen.dart';
import 'package:muzicka/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee_text/marquee_text.dart';

class EachPlayListSongs extends StatefulWidget {
  final Playlists playlist;
  const EachPlayListSongs({super.key, required this.playlist});

  @override
  State<EachPlayListSongs> createState() => _EachPlayListSongsState();
}

class _EachPlayListSongsState extends State<EachPlayListSongs> {
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
  final songBox = Hive.box<Songs>(boxname);
  late List<Songs> dbSongList;
  List<Audio> convertPAudios = [];
  late List<Songs> playlistSongs;
  List<Playlists> allDbPlaylists = playlistsBox.values.toList();

  @override
  void initState() {
    super.initState();
    dbSongList = songBox.values.toList();
    playlistSongs = widget.playlist.playlistssongs!.toList();
    for (var element in playlistSongs) {
      convertPAudios.add(Audio.file(
        element.songurl!,
        metas: Metas(
          artist: element.artist,
          title: element.songname,
          id: element.id.toString(),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height1 = MediaQuery.of(context).size.height;
    final width1 = MediaQuery.of(context).size.width;
    playlistSongs = widget.playlist.playlistssongs!.toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.9),
        centerTitle: true,
        title: Text(
          '${widget.playlist.playlistname![0].toUpperCase()}${widget.playlist.playlistname!.substring(1)} Playlist',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const searchScreen()));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/muzicka dj image.jpg'),
          ),
        ),
        child: SingleChildScrollView(
            child: (playlistSongs.isEmpty)
                ? Container(
                    alignment: Alignment.center,
                    height: height1 * 0.9,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/muzicka dj image.jpg'))),
                    child: Center(
                      child:
                          Lottie.asset("assets/animations/127760-nothing.json"),
                    ))
                : Stack(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: height1 * 0.35,
                            width: double.infinity,
                            foregroundDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Colors.black.withOpacity(0.9),
                                  Colors.black.withOpacity(0.7),
                                  Colors.black.withOpacity(0.7),
                                  Colors.black.withOpacity(0.9),
                                ])),
                            child: QueryArtworkWidget(
                              artworkFit: BoxFit.fill,
                              id: playlistSongs.first.id!,
                              type: ArtworkType.AUDIO,
                              artworkQuality: FilterQuality.high,
                              size: 2000,
                              quality: 100,
                              artworkBorder: BorderRadius.circular(10),
                              nullArtworkWidget: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/logo.png.png')),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: height1 * 0.20,
                            left: width1 * 0.38,
                            child: Column(
                              children: [
                                Text(
                                  (widget.playlist.playlistssongs!.length <= 1)
                                      ? '${widget.playlist.playlistssongs!.length.toString()} Song'
                                      : '${widget.playlist.playlistssongs!.length.toString()} Songs',
                                  style: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.blue,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      ListView.separated(
                        padding: EdgeInsets.only(top: height1 * 0.36),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: playlistSongs.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF30314D),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              tileColor: const Color(0xFF30314D),
                              onTap: () {
                                RecentlyPlayed recentlySong;
                                MostlyPlayed mostlySong;
                                Songs currentSong = playlistSongs[index];
                                recentlySong = RecentlyPlayed(
                                    songname: currentSong.songname,
                                    artist: currentSong.artist,
                                    duration: currentSong.duration,
                                    songuri: currentSong.songurl,
                                    id: currentSong.id);
                                mostlySong = MostlyPlayed(
                                    songname: currentSong.songname!,
                                    songuri: currentSong.songurl,
                                    duration: currentSong.duration,
                                    artist: currentSong.artist,
                                    count: 1,
                                    id: currentSong.id);
                                updateRecentlyPlayed(recentlySong);
                                updateMostlyPlayed(mostlySong);
                                audioPlayer.open(
                                    Playlist(
                                        audios: convertPAudios,
                                        startIndex: index),
                                    showNotification: true,
                                    headPhoneStrategy: HeadPhoneStrategy
                                        .pauseOnUnplugPlayOnPlug,
                                    loopMode: LoopMode.playlist);
                                setState(() {});
                                showBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return MiniPlayer(
                                          index: dbSongList.indexWhere(
                                              (element) =>
                                                  element.id ==
                                                  playlistSongs[index].id));
                                    });
                              },
                              leading: QueryArtworkWidget(
                                artworkFit: BoxFit.cover,
                                id: playlistSongs[index].id!,
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
                                        image:
                                            AssetImage('assets/logo.png.png')),
                                  ),
                                ),
                              ),
                              title: MarqueeText(
                                text: TextSpan(
                                    text: playlistSongs[index].songname,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                speed: 15,
                                textDirection: TextDirection.ltr,
                              ),
                              subtitle:
                                  playlistSongs[index].artist == '<unknown>'
                                      ? const Text(
                                          'Unknown Artist',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        )
                                      : Text(
                                          playlistSongs[index].artist!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white),
                                        ),
                              trailing: PopupMenuButton<String>(
                                color: Colors.white,
                                padding: const EdgeInsets.all(1.0),
                                onSelected: (String value) {},
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: "Remove",
                                    child: TextButton(
                                        onPressed: () {
                                          int currentIndex = allDbPlaylists
                                              .indexWhere((element) =>
                                                  element.playlistname ==
                                                  widget.playlist.playlistname);
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext ctx) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Remove from ${widget.playlist.playlistname} Playlist'),
                                                  content: const Text(
                                                      'Are You Sure?'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(ctx)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Cancel')),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        convertPAudios
                                                            .removeAt(index);
                                                        playlistSongs
                                                            .removeAt(index);
                                                        widget.playlist
                                                            .playlistssongs!
                                                            .clear();
                                                        widget.playlist
                                                                .playlistssongs =
                                                            playlistSongs;
                                                        Playlists
                                                            updatedPlaylist =
                                                            Playlists(
                                                          playlistname: widget
                                                              .playlist
                                                              .playlistname,
                                                          playlistssongs:
                                                              playlistSongs,
                                                        );
                                                        playlistsBox.putAt(
                                                            currentIndex,
                                                            updatedPlaylist);
                                                        // playlistsBox.deleteAt(
                                                        //     currentIndex); // Remove the original playlist
                                                        // playlistsBox.add(
                                                        //     updatedPlaylist); // Insert the updated playlist at the end
                                                        setState(() {});
                                                        Navigator.of(ctx).pop();
                                                        ScaffoldMessenger.of(
                                                                ctx)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Removed from ${widget.playlist.playlistname} Playlist'),
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        600),
                                                          ),
                                                        );
                                                      },
                                                      child:
                                                          const Text('Remove'),
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        child: Text(
                                            'Remove from ${widget.playlist.playlistname}',
                                            style:
                                                const TextStyle(fontSize: 14))),
                                  ),
                                  PopupMenuItem<String>(
                                    value: "Favorites",
                                    child: AddToFavorites(
                                        index: dbSongList.indexWhere(
                                            (element) =>
                                                element.id ==
                                                playlistSongs[index].id)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      ),
                    ],
                  )
            //]
            //   ],
            // ),
            ),
      ),
    );
  }
}

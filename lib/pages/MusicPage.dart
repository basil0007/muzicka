import 'package:hive/hive.dart';
import 'package:marquee/marquee.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muzicka/model/dbfunctions.dart';
import 'package:muzicka/model/songModel.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class MusicPage extends StatefulWidget {
  int index;
  MusicPage({super.key, required this.index});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final assetAudio = AssetsAudioPlayer.withId('0');
  List<Favorites> favDbSongs = [];
  final songBox = Hive.box<Songs>(boxname);
  List<Songs> dbSongList = [];

  @override
  void initState() {
    super.initState();
    dbSongList = songBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final mqheight = MediaQuery.of(context).size.height;
    final mqwidth = MediaQuery.of(context).size.width;
    favDbSongs = favSongsBox.values.toList();
    return assetAudio.builderCurrent(
      builder: (context, playing) {
        return Stack(
          children: [
            Container(
              width: mqwidth,
              height: mqheight,
              decoration: const BoxDecoration(),
              child: QueryArtworkWidget(
                artworkFit: BoxFit.cover,
                id: int.parse(playing.audio.audio.metas.id!),
                type: ArtworkType.AUDIO,
                artworkQuality: FilterQuality.high,
                size: 2000,
                quality: 100,
                artworkBorder: BorderRadius.circular(10),
                nullArtworkWidget: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.white)),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.music_note,
                      size: 40,
                      color: Colors.white,
                    )),
              ),
            ),
            Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.5),
                        const Color(0xFF31314F).withOpacity(1),
                        const Color(0xFF31314F).withOpacity(1),
                      ],
                    )),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(CupertinoIcons.back,
                                    color: Colors.white, size: 30),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2.5,
                          child: Column(children: [
                            const SizedBox(height: 40),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 23, horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: mqwidth * .75,
                                        height: mqheight * 0.06,
                                        child: Marquee(
                                          blankSpace: 30,
                                          text: assetAudio.getCurrentAudioTitle,
                                          velocity: 30,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              letterSpacing: 2,
                                              wordSpacing: 2),
                                        ),
                                      ),
                                      SizedBox(
                                          width: mqwidth * .75,
                                          height: mqheight * 0.025,
                                          child: Text(
                                            assetAudio.getCurrentAudioArtist,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          )),
                                    ],
                                  ),
                                  (favDbSongs
                                          .where((element) =>
                                              element.id ==
                                              dbSongList[widget.index].id)
                                          .isEmpty)
                                      ? IconButton(
                                          onPressed: () {
                                            favSongsBox.add(Favorites(
                                                songname:
                                                    dbSongList[widget.index]
                                                        .songname,
                                                artist: dbSongList[widget.index]
                                                    .artist,
                                                duration:
                                                    dbSongList[widget.index]
                                                        .duration,
                                                songuri:
                                                    dbSongList[widget.index]
                                                        .songurl,
                                                id: dbSongList[widget.index]
                                                    .id));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('Added to Favorites'),
                                                duration:
                                                    Duration(milliseconds: 600),
                                              ),
                                            );
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.favorite_border,
                                            color: Colors.white,
                                            size: 35,
                                          ))
                                      : IconButton(
                                          onPressed: () async {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Removed from Favorites'),
                                                duration:
                                                    Duration(milliseconds: 600),
                                              ),
                                            );
                                            // ignore: non_constant_identifier_names
                                            int DelIndex = favDbSongs
                                                .indexWhere((element) =>
                                                    element.id ==
                                                    dbSongList[widget.index]
                                                        .id);
                                            await favSongsBox
                                                .deleteAt(DelIndex);

                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.favorite,
                                            color: Colors.redAccent,
                                            size: 35,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: mqwidth * 0.9,
                              child: PlayerBuilder.realtimePlayingInfos(
                                player: assetAudio,
                                builder: (context, realtimePlayingInfos) {
                                  final duration = realtimePlayingInfos
                                      .current!.audio.duration;
                                  final position =
                                      realtimePlayingInfos.currentPosition;
                                  return ProgressBar(
                                    progress: position,
                                    total: duration,
                                    progressBarColor: Colors.white,
                                    baseBarColor: Colors.white.withOpacity(0.5),
                                    thumbColor: Colors.white,
                                    barHeight: 3.0,
                                    thumbRadius: 7.0,
                                    timeLabelTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    onSeek: (duration) {
                                      assetAudio.seek(duration);
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              width: mqwidth * 0.85,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PlayerBuilder.isPlaying(
                                      player: assetAudio,
                                      builder: (context, isPlaying) {
                                        return IconButton(
                                          iconSize: 35,
                                          onPressed: playing.index == 0
                                              ? () {}
                                              : () async {
                                                  await assetAudio.previous();
                                                  if (!isPlaying) {
                                                    assetAudio.pause();
                                                    setState(() {});
                                                  }
                                                },
                                          icon: playing.index == 0
                                              ? Icon(
                                                  Icons.skip_previous,
                                                  color: Colors.white
                                                      .withOpacity(0.4),
                                                  size: 35,
                                                )
                                              : const Icon(
                                                  Icons.skip_previous,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                        );
                                      }),
                                  IconButton(
                                    iconSize: 35,
                                    onPressed: () async {
                                      assetAudio
                                          .seekBy(const Duration(seconds: -10));
                                    },
                                    icon: const Icon(Icons.replay_10,
                                        color: Colors.white, size: 35),
                                  ),
                                  PlayerBuilder.isPlaying(
                                      player: assetAudio,
                                      builder: (context, isPlaying) {
                                        return IconButton(
                                          iconSize: 55,
                                          onPressed: () {
                                            assetAudio.playOrPause();
                                          },
                                          icon: Icon(
                                            isPlaying
                                                ? Icons.pause_circle
                                                : Icons.play_circle,
                                            color: Colors.white,
                                            size: 55,
                                          ),
                                        );
                                      }),
                                  IconButton(
                                    iconSize: 35,
                                    onPressed: () async {
                                      assetAudio
                                          .seekBy(const Duration(seconds: 10));
                                    },
                                    icon: const Icon(Icons.forward_10,
                                        color: Colors.white, size: 35),
                                  ),
                                  PlayerBuilder.isPlaying(
                                      player: assetAudio,
                                      builder: (context, isPlaying) {
                                        return IconButton(
                                          iconSize: 35,
                                          onPressed: (playing.index ==
                                                  playing.playlist.audios
                                                          .length -
                                                      1)
                                              ? () {}
                                              : () async {
                                                  await assetAudio.next();
                                                  if (!isPlaying) {
                                                    assetAudio.pause();
                                                    setState(() {});
                                                  }
                                                },
                                          icon: (playing.index ==
                                                  playing.playlist.audios
                                                          .length -
                                                      1)
                                              ? Icon(
                                                  Icons.skip_next,
                                                  color: Colors.white
                                                      .withOpacity(0.4),
                                                  size: 35,
                                                )
                                              : const Icon(
                                                  Icons.skip_next,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                        );
                                      }),
                                ],
                              ),
                            )
                          ]),
                        )
                      ]),
                    ))),
          ],
        );
      },
    );
  }
}

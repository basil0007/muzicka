// ignore: file_names
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:muzicka/favorites/add_to_fav.dart';
import 'package:muzicka/model/dbfunctions.dart';
import 'package:muzicka/model/songModel.dart';
import 'package:muzicka/pages/add_to_playlist.dart';
import 'package:muzicka/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
// ignore: depend_on_referenced_packages
import 'package:marquee_text/marquee_text.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class MusicList extends StatefulWidget {
  const MusicList({super.key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  final assetAudio = AssetsAudioPlayer.withId('0');
  final songBox = Hive.box<Songs>(boxname);
  List<Songs> dbSongList = [];
  List<Audio> convertAudio = [];

  @override
  void initState() {
    super.initState();
    dbSongList = songBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    for (var item in dbSongList) {
      convertAudio.add(Audio.file(item.songurl!,
          metas: Metas(
              title: item.songname,
              artist: item.artist,
              id: item.id.toString())));
    }
    List<Favorites> favDbSongs = favSongsBox.values.toList();
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const Divider(
          height: 4,
        );
      },
      shrinkWrap: true,
      itemCount: dbSongList.length,
      itemBuilder: (context, index) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.075,
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF30314D),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            onTap: () {
              updateRecentlyPlayed(RecentlyPlayed(
                  songname: dbSongList[index].songname,
                  artist: dbSongList[index].artist,
                  duration: dbSongList[index].duration,
                  id: dbSongList[index].id,
                  songuri: dbSongList[index].songurl));
              updateMostlyPlayed(MostlyPlayed(
                  songname: dbSongList[index].songname!,
                  songuri: dbSongList[index].songurl,
                  duration: dbSongList[index].duration,
                  artist: dbSongList[index].artist,
                  count: 1,
                  id: dbSongList[index].id));
              assetAudio
                  .open(Playlist(audios: convertAudio, startIndex: index));

              showBottomSheet(
                  context: context,
                  builder: (context) {
                    return MiniPlayer(index: index);
                  });
            },
            leading: QueryArtworkWidget(
                artworkFit: BoxFit.cover,
                id: dbSongList[index].id!,
                type: ArtworkType.AUDIO,
                artworkQuality: FilterQuality.high,
                size: 2000,
                quality: 100,
                artworkBorder: BorderRadius.circular(10),
                nullArtworkWidget: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: AssetImage('assets/logo.png.png'))),
                )),
            title: MarqueeText(
              text: TextSpan(
                  text: dbSongList[index].songname,
                  style: const TextStyle(color: Colors.white)),
              speed: 15,
              textDirection: TextDirection.ltr,
            ),
            subtitle: MarqueeText(
              text: TextSpan(
                  text: dbSongList[index].artist!,
                  style: const TextStyle(color: Colors.white)),
              speed: 15,
              textDirection: TextDirection.ltr,
            ),
            trailing: PopupMenuButton<String>(
              color: Colors.white,
              padding: const EdgeInsets.all(1.0),
              onSelected: (String value) {},
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "Favorites",
                  child: AddToFavorites(index: index),
                ),
                PopupMenuItem<String>(
                    value: "Playlists",
                    child: AddToPlaylists(songIndex: index)),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:muzicka/pages/MusicPage.dart';
// ignore: depend_on_referenced_packages
import 'package:marquee_text/marquee_text.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class MiniPlayer extends StatefulWidget {
  int index;
  MiniPlayer({required this.index, super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  @override
  Widget build(BuildContext context) {
    final widthDsp = MediaQuery.of(context).size.width;
    final heightDsp = MediaQuery.of(context).size.height;
    return audioPlayer.builderCurrent(
      builder: (context, playing) {
        return Container(
          height: heightDsp * 0.088,
          width: widthDsp,
          color: Colors.blue,
          child: ListTile(
            onTap: (() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => MusicPage(index: widget.index)),
                ),
              );
            }),
            // contentPadding: const EdgeInsets.all(5),
            leading: QueryArtworkWidget(
              id: int.parse(playing.audio.audio.metas.id!),
              type: ArtworkType.AUDIO,
              artworkWidth: 50,
              artworkHeight: 50,
              artworkFit: BoxFit.fill,
              nullArtworkWidget: Container(
                width: widthDsp * 0.134,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/logo.png.png')),
                ),
                //child: Icon(Icons.abc),
              ),
            ),
            title: MarqueeText(
              text: TextSpan(
                  text: audioPlayer.getCurrentAudioTitle,
                  style: const TextStyle(color: Colors.white)),
              speed: 15,
              textDirection: TextDirection.ltr,
            ),
            subtitle: MarqueeText(
              text: TextSpan(
                  text: audioPlayer.getCurrentAudioArtist,
                  style: const TextStyle(color: Colors.white)),
              speed: 15,
              textDirection: TextDirection.ltr,
            ),

            trailing: PlayerBuilder.isPlaying(
                player: audioPlayer,
                builder: (context, isPlaying) {
                  return IconButton(
                    iconSize: 45,
                    onPressed: () {
                      audioPlayer.playOrPause();
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      color: Colors.white,
                      //size: 45,
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}

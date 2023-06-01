import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:audio_wave/audio_wave.dart';
import 'package:muzicka/pages/HomePage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../model/songModel.dart';
import 'dart:developer';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final songBox = Hive.box<Songs>(boxname);
  final audioQuery = OnAudioQuery();
  @override
  void initState() {
    requestStoragePermission();
    _gohome();
    log("wrong in initstate");
    super.initState();
  }

  requestStoragePermission() async {
    List<SongModel> fetchsongs = [];
    List<SongModel> filteredSongs = [];
    bool permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();

      fetchsongs = await audioQuery.querySongs();
      for (var element in fetchsongs) {
        if (element.fileExtension == "mp3") {
          log("fetching audio");
          filteredSongs.add(element);
        }
      }

      for (var element in filteredSongs) {
        log("adding to list");
        await songBox.put(
          element.id,
          Songs(
              songname: element.title,
              artist: element.artist,
              duration: element.duration,
              id: element.id,
              songurl: element.uri),
        );
      }
    }
  }

  _gohome() async {
    await Future.delayed(
      const Duration(milliseconds: 4000),
    );
    //Navigator.pushReplacementNamed(context, "homePage");
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                  size: 40,
                ),
                Icon(
                  Icons.pause_circle,
                  color: Colors.amber,
                  size: 60,
                ),
                Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 40,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Stack(
              children: [
                AudioWave(
                  height: 290,
                  width: 300,
                  spacing: 4.5,
                  animationLoop: 1,
                  beatRate: const Duration(milliseconds: 50),
                  bars: [
                    AudioWaveBar(heightFactor: 1, color: Colors.purple),
                    AudioWaveBar(heightFactor: 0.9, color: Colors.indigo),
                    AudioWaveBar(heightFactor: 0.8, color: Colors.blue),
                    AudioWaveBar(heightFactor: 0.7, color: Colors.green),
                    AudioWaveBar(heightFactor: 0.6, color: Colors.yellow),
                    AudioWaveBar(heightFactor: 0.5, color: Colors.orange),
                    AudioWaveBar(heightFactor: 0.4, color: Colors.red),
                    AudioWaveBar(heightFactor: 0.3, color: Colors.redAccent),
                    AudioWaveBar(heightFactor: 0.2, color: Colors.orangeAccent),
                    AudioWaveBar(heightFactor: 0.3, color: Colors.yellowAccent),
                    AudioWaveBar(heightFactor: 0.2, color: Colors.greenAccent),
                    AudioWaveBar(heightFactor: 0.3, color: Colors.blueAccent),
                    AudioWaveBar(heightFactor: 0.4, color: Colors.indigoAccent),
                    AudioWaveBar(heightFactor: 0.5, color: Colors.purpleAccent),
                    AudioWaveBar(heightFactor: 0.6, color: Colors.purple),
                    AudioWaveBar(heightFactor: 0.7, color: Colors.indigo),
                    AudioWaveBar(heightFactor: 0.8, color: Colors.blue),
                    AudioWaveBar(heightFactor: 0.9, color: Colors.green),
                    AudioWaveBar(heightFactor: 1, color: Colors.yellow),
                    AudioWaveBar(heightFactor: 1, color: Colors.orange),
                    AudioWaveBar(heightFactor: 0.9, color: Colors.red),
                    AudioWaveBar(heightFactor: 0.8, color: Colors.redAccent),
                    AudioWaveBar(heightFactor: 0.7, color: Colors.orangeAccent),
                    AudioWaveBar(heightFactor: 0.6, color: Colors.yellowAccent),
                    AudioWaveBar(heightFactor: 0.5, color: Colors.greenAccent),
                    AudioWaveBar(heightFactor: 0.4, color: Colors.blueAccent),
                    AudioWaveBar(heightFactor: 0.3, color: Colors.indigoAccent),
                    AudioWaveBar(heightFactor: 0.2, color: Colors.purpleAccent),
                    AudioWaveBar(heightFactor: 0.4, color: Colors.purple),
                    AudioWaveBar(heightFactor: 0.3, color: Colors.indigo),
                    AudioWaveBar(heightFactor: 0.2, color: Colors.blue),
                    AudioWaveBar(heightFactor: 0.3, color: Colors.green),
                    AudioWaveBar(heightFactor: 0.4, color: Colors.yellow),
                    AudioWaveBar(heightFactor: 0.5, color: Colors.orange),
                    AudioWaveBar(heightFactor: 0.6, color: Colors.red),
                    AudioWaveBar(heightFactor: 0.7, color: Colors.redAccent),
                    AudioWaveBar(heightFactor: 0.8, color: Colors.orangeAccent),
                    AudioWaveBar(heightFactor: 0.9, color: Colors.yellowAccent),
                    AudioWaveBar(heightFactor: 1, color: Colors.greenAccent),
                    AudioWaveBar(heightFactor: 1, color: Colors.blueAccent),
                    AudioWaveBar(heightFactor: 0.9, color: Colors.indigoAccent),
                    AudioWaveBar(heightFactor: 0.8, color: Colors.purpleAccent),
                    AudioWaveBar(heightFactor: 0.7, color: Colors.pink),
                    AudioWaveBar(heightFactor: 0.6, color: Colors.amber),
                    AudioWaveBar(heightFactor: 0.5, color: Colors.purple),
                    AudioWaveBar(heightFactor: 0.4, color: Colors.indigo),
                    AudioWaveBar(heightFactor: 0.3, color: Colors.blue),
                    AudioWaveBar(heightFactor: 0.2, color: Colors.green),
                    AudioWaveBar(heightFactor: 0.4, color: Colors.yellow),
                    AudioWaveBar(heightFactor: 0.3, color: Colors.orange),
                    AudioWaveBar(heightFactor: 0.2, color: Colors.red),
                    AudioWaveBar(heightFactor: 0.3, color: Colors.pink),
                    AudioWaveBar(heightFactor: 0.4, color: Colors.white),
                    AudioWaveBar(heightFactor: 0.5, color: Colors.brown),
                    AudioWaveBar(heightFactor: 0.6, color: Colors.teal),
                    AudioWaveBar(heightFactor: 0.7, color: Colors.amber),
                    AudioWaveBar(heightFactor: 0.8, color: Colors.white),
                    AudioWaveBar(
                        heightFactor: 0.9, color: Colors.lightBlueAccent),
                    AudioWaveBar(heightFactor: 1, color: Colors.white),
                  ],
                ),
                const Positioned(
                    right: 60,
                    top: 120,
                    child: SizedBox(
                      height: 50,
                      width: 170,
                      child: Text(
                        'Muzicka',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal),
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

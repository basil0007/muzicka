// ignore_for_file: unused_local_variable
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:muzicka/model/dbfunctions.dart';
import 'package:muzicka/model/songModel.dart';
import 'package:muzicka/pages/EachPlaylistSongs.dart';
// ignore: depend_on_referenced_packages
import 'package:marquee_text/marquee_text.dart';
import 'package:on_audio_query/on_audio_query.dart';
// ignore: depend_on_referenced_packages
import 'package:lottie/lottie.dart';

class ScreenPlaylists extends StatefulWidget {
  const ScreenPlaylists({super.key});

  @override
  State<ScreenPlaylists> createState() => _ScreenPlaylistsState();
}

class _ScreenPlaylistsState extends State<ScreenPlaylists> {
  String selectedItem = 'Remove';
  List<Playlists> allDbPlaylists = [];
  TextEditingController playlistController = TextEditingController();

  @override
  void initState() {
    allDbPlaylists = playlistsBox.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height1 = MediaQuery.of(context).size.height;
    final width1 = MediaQuery.of(context).size.width;
    allDbPlaylists = playlistsBox.values.toList();

    return Stack(
      children: [
        allDbPlaylists.isEmpty
            ? Center(
                child: Padding(
                    padding: EdgeInsets.only(bottom: height1 * 0.08),
                    child: LottieBuilder.asset(
                      "assets/animations/127760-nothing.json",
                      height:
                          300, // Adjust the height according to your desired size
                      width:
                          300, // Adjust the width according to your desired size
                    )))
            : Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                child: ListView.separated(
                  itemCount: allDbPlaylists.length,
                  itemBuilder: (context, index) {
                    allDbPlaylists = playlistsBox.values.toList();
                    final currentPlaylist = allDbPlaylists[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF30314D),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EachPlayListSongs(
                                      playlist: allDbPlaylists[index])));
                          setState(() {});
                        },
                        leading: allDbPlaylists[index]
                                .playlistssongs!
                                .isNotEmpty
                            ? QueryArtworkWidget(
                                artworkFit: BoxFit.cover,
                                id: allDbPlaylists[index]
                                    .playlistssongs!
                                    .first
                                    .id!,
                                type: ArtworkType.AUDIO,
                                artworkQuality: FilterQuality.high,
                                size: 2000,
                                quality: 100,
                                artworkBorder: BorderRadius.circular(10),
                                nullArtworkWidget: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/logo.png.png')))))
                            : Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/logo.png.png')))),
                        title: MarqueeText(
                          text: TextSpan(
                              text: allDbPlaylists[index].playlistname,
                              style: const TextStyle(color: Colors.white)),
                          speed: 15,
                          textDirection: TextDirection.ltr,
                        ),
                        subtitle: MarqueeText(
                          text: TextSpan(
                              text: allDbPlaylists[index]
                                  .playlistssongs!
                                  .length
                                  .toString(),
                              style: const TextStyle(color: Colors.white)),
                          speed: 15,
                          textDirection: TextDirection.ltr,
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
                              value: "Delete",
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return AlertDialog(
                                            title: Text(
                                                'Delete ${currentPlaylist.playlistname} Playlist'),
                                            content:
                                                const Text('Are You Sure?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: const Text('Cancel')),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    allDbPlaylists
                                                        .removeAt(index);
                                                    playlistsBox
                                                        .deleteAt(index);
                                                    setState(() {});
                                                    Navigator.of(ctx).pop();
                                                    ScaffoldMessenger.of(ctx)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Deleted from Playlists'),
                                                        duration: Duration(
                                                            milliseconds: 600),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text('Delete'))
                                            ],
                                          );
                                        });
                                  },
                                  child: const Text('Delete',
                                      style: TextStyle(fontSize: 14))),
                            ),
                            PopupMenuItem<String>(
                              value: "Rename",
                              child: TextButton(
                                  onPressed: () {
                                    playlistController.text =
                                        currentPlaylist.playlistname!;
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Rename the Playlist'),
                                            content: GestureDetector(
                                              child: TextField(
                                                controller: playlistController,
                                                cursorColor: Colors.black,
                                                cursorHeight: 28,
                                                onTap: () {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.playlist_add,
                                                    color: Colors.black,
                                                    size: 26,
                                                  ),
                                                  focusColor: Colors.black,
                                                  hintText:
                                                      'Enter the New Name...',
                                                  hintStyle: TextStyle(
                                                      color: Colors.black54,
                                                      fontFamily: 'Poppins'),
                                                  // filled: true,
                                                  // fillColor: Color.fromARGB(255, 14, 17, 42),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    playlistController.clear();
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  child: const Text('Cancel')),
                                              ValueListenableBuilder<
                                                  TextEditingValue>(
                                                valueListenable:
                                                    playlistController,
                                                builder:
                                                    (context, value, child) {
                                                  if (playlistController
                                                      .text.isEmpty) {
                                                    return TextButton(
                                                        onPressed: () {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'Please Enter a Name'),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      600),
                                                            ),
                                                          );
                                                        },
                                                        child: const Text(
                                                            'Rename'));
                                                  } else {
                                                    return ElevatedButton(
                                                        onPressed:
                                                            (checkIfAlreadyExists(
                                                                    playlistController
                                                                        .text))
                                                                ? () {
                                                                    playlistController
                                                                        .clear();
                                                                    //playlistController.text = currentPlaylist.playlistname!;
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        content:
                                                                            Text('Name Already Exists'),
                                                                        duration:
                                                                            Duration(milliseconds: 600),
                                                                      ),
                                                                    );
                                                                  }
                                                                : () {
                                                                    currentPlaylist
                                                                            .playlistname =
                                                                        playlistController
                                                                            .text;
                                                                    playlistsBox
                                                                        .putAt(
                                                                            index,
                                                                            currentPlaylist);
                                                                    playlistController
                                                                        .clear();
                                                                    setState(
                                                                        () {});
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        content:
                                                                            Text('Playlist Renamed'),
                                                                        duration:
                                                                            Duration(milliseconds: 800),
                                                                      ),
                                                                    );
                                                                  },
                                                        child: const Text(
                                                            'Rename'));
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: const Text('Rename',
                                      style: TextStyle(fontSize: 14))),
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
              ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            onPressed: () {
              showPlaylistAddButton();
              // setState(() {});
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  showPlaylistAddButton() {
    final playlistButtonController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Create New Playlist'),
            content: GestureDetector(
              child: TextField(
                controller: playlistButtonController,
                cursorColor: Colors.black,
                cursorHeight: 28,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {},
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  prefixIcon: Icon(
                    Icons.playlist_add,
                    color: Colors.black,
                    size: 26,
                  ),
                  focusColor: Colors.black,
                  hintText: 'Enter the Name...',
                  hintStyle:
                      TextStyle(color: Colors.black54, fontFamily: 'Poppins'),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    playlistButtonController.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: const Text('Cancel')),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: playlistButtonController,
                builder: (context, value, child) {
                  if (playlistButtonController.text.isEmpty) {
                    return TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please Enter a Name'),
                              duration: Duration(milliseconds: 600),
                            ),
                          );
                        },
                        child: const Text('Create'));
                  } else {
                    return ElevatedButton(
                        onPressed: (checkIfAlreadyExists(
                                playlistButtonController.text))
                            ? () {
                                playlistButtonController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Playlist Already Exists'),
                                    duration: Duration(milliseconds: 600),
                                  ),
                                );
                              }
                            : () async {
                                await playlistsBox.add(Playlists(
                                  playlistname: playlistButtonController.text,
                                  playlistssongs: [],
                                ));
                                playlistButtonController.clear();
                                FocusManager.instance.primaryFocus?.unfocus();
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                                log(allDbPlaylists.toString());
                                setState(() {});
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('New Playlist Created'),
                                    duration: Duration(milliseconds: 800),
                                  ),
                                );
                              },
                        child: const Text('Create'));
                  }
                },
              ),
            ],
          );
        });
  }

  bool checkIfAlreadyExists(String name) {
    bool isAlreadyAdded = allDbPlaylists
        .where((element) => element.playlistname == name.trim())
        .isNotEmpty;
    return isAlreadyAdded;
  }
}

import 'package:flutter/material.dart';
import 'package:muzicka/model/dbfunctions.dart';
import 'package:muzicka/model/songModel.dart';
import 'package:muzicka/pages/create_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class AddToPlaylists extends StatefulWidget {
  int songIndex;
  AddToPlaylists({super.key, required this.songIndex});

  @override
  State<AddToPlaylists> createState() => _AddToPlaylistsState();
}

class _AddToPlaylistsState extends State<AddToPlaylists> {
  List<Playlists> allDbPlaylists = playlistsBox.values.toList();
  final box = SongBox.getInstance();
  late List<Songs> allDbSongs;

  @override
  void initState() {
    allDbSongs = box.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widthDsp = MediaQuery.of(context).size.height;
    return TextButton(
        onPressed: (playlistsBox.isEmpty)
            ? () {
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return CreatePlaylist(currentIndex: widget.songIndex);
                    });
              }
            : () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // set this to true
                  builder: (context) {
                    return Container(
                      color: const Color.fromARGB(255, 14, 17, 42),
                      height: widthDsp * 0.4,
                      child: DraggableScrollableSheet(
                        initialChildSize: 1,
                        maxChildSize: 1,
                        minChildSize: 0.2,
                        builder: (context, controller) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  CreatePlaylist(
                                      currentIndex: widget.songIndex),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: allDbPlaylists.length,
                                    controller: controller, // set this too
                                    itemBuilder: (context, index) => ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        List<Songs> eachPlaylistSongs =
                                            allDbPlaylists[index]
                                                .playlistssongs!
                                                .toList();
                                        bool isAlreadyAdded =
                                            eachPlaylistSongs.any((element) =>
                                                element.id ==
                                                allDbSongs[widget.songIndex]
                                                    .id);

                                        if (!isAlreadyAdded) {
                                          eachPlaylistSongs.add(Songs(
                                              songname:
                                                  allDbSongs[widget.songIndex]
                                                      .songname,
                                              artist:
                                                  allDbSongs[widget.songIndex]
                                                      .artist,
                                              duration:
                                                  allDbSongs[widget.songIndex]
                                                      .duration,
                                              id: allDbSongs[widget.songIndex]
                                                  .id,
                                              songurl:
                                                  allDbSongs[widget.songIndex]
                                                      .songurl));
                                          playlistsBox.putAt(
                                              index,
                                              Playlists(
                                                  playlistname:
                                                      allDbPlaylists[index]
                                                          .playlistname,
                                                  playlistssongs:
                                                      eachPlaylistSongs));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Song Added to ${allDbPlaylists[index].playlistname}'),
                                              duration: const Duration(
                                                  milliseconds: 1000),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Song Already Exist in ${allDbPlaylists[index].playlistname}'),
                                              duration: const Duration(
                                                  milliseconds: 1000),
                                            ),
                                          );
                                        }
                                      },
                                      leading: (allDbPlaylists[index]
                                              .playlistssongs!
                                              .isEmpty)
                                          ? Container(
                                              width: widthDsp * 0.065,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        'assets/logo.png.png')),
                                              ),
                                              //child: Icon(Icons.abc),
                                            )
                                          : QueryArtworkWidget(
                                              artworkFit: BoxFit.cover,
                                              id: allDbPlaylists[index]
                                                  .playlistssongs!
                                                  .first
                                                  .id!,
                                              type: ArtworkType.AUDIO,
                                              artworkQuality:
                                                  FilterQuality.high,
                                              size: 2000,
                                              quality: 100,
                                              artworkBorder:
                                                  BorderRadius.circular(10),
                                              nullArtworkWidget: Container(
                                                width: widthDsp * 0.065,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          'assets/logo.png.png')),
                                                ),
                                                //child: Icon(Icons.abc),
                                              ),
                                            ),
                                      title: Text(
                                        allDbPlaylists[index].playlistname!,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        (allDbPlaylists[index]
                                                    .playlistssongs!
                                                    .length <=
                                                1)
                                            ? '${allDbPlaylists[index].playlistssongs!.length.toString()} Song'
                                            : '${allDbPlaylists[index].playlistssongs!.length.toString()} Songs',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            color: Colors.white),
                                      ),
                                      trailing: const Icon(Icons.add_circle,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
        child: const Text("Add to Playlists", style: TextStyle(fontSize: 14)));
  }
}

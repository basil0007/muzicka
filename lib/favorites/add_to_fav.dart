import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/dbfunctions.dart';
import '../model/songModel.dart';

class AddToFavorites extends StatelessWidget {
  final int index;
  const AddToFavorites({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    List<Favorites> favDbSongs = favSongsBox.values.toList();
    final songBox = Hive.box<Songs>(boxname);
    List<Songs> dbSongList = songBox.values.toList();

    return (favDbSongs
            .where((element) => element.id == dbSongList[index].id)
            .isEmpty)
        ? TextButton(
            onPressed: () async {
              await favSongsBox.add(Favorites(
                  songname: dbSongList[index].songname,
                  artist: dbSongList[index].artist,
                  duration: dbSongList[index].duration,
                  songuri: dbSongList[index].songurl,
                  id: dbSongList[index].id));
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to Favorites'),
                  duration: Duration(milliseconds: 600),
                ),
              );
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
              // setState(() {});
            },
            child: const Text('Add to favorites'),
          )
        : TextButton(
            onPressed: () async {
              int delIndex = favDbSongs
                  .indexWhere((element) => element.id == dbSongList[index].id);
              await favSongsBox.deleteAt(delIndex);

              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Removed from Favorites'),
                  duration: Duration(milliseconds: 600),
                ),
              );
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
              // setState(() {});
            },
            child: const Text('Remove from favorites'),
          );
  }
}

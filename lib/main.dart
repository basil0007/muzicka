import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:muzicka/model/dbfunctions.dart';
import 'package:muzicka/pages/HomePage.dart';
import 'package:muzicka/widgets/splash.dart';
import 'model/songModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(SongsAdapter());
  }
  await Hive.openBox<Songs>(boxname);
  runApp(const MyApp());

  Hive.registerAdapter(FavoritesAdapter());
  openFavoriteSongsDb();

  Hive.registerAdapter(PlaylistsAdapter());
  openPlaylist();

  Hive.registerAdapter(RecentlyPlayedAdapter());
  openrecentlyplayed();

  Hive.registerAdapter(MostlyPlayedAdapter());
  openmostlyplayed();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "homePage": (context) => const HomePage(),
      },
      home: const Splash(),
    );
  }
}

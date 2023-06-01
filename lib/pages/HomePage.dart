// ignore: file_names
import 'package:flutter/material.dart';
import 'package:muzicka/pages/searchScreen.dart';
import 'package:muzicka/screens/mostly.dart';
import 'package:muzicka/screens/privacy_policy.dart';
import 'package:muzicka/screens/recently.dart';
import 'package:muzicka/screens/terms_and_conditions.dart';
import 'package:muzicka/widgets/FavoritesList.dart';
import '../widgets/MusicList.dart';
import '../widgets/PlayList.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303151).withOpacity(0.6),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const searchScreen(),
              ));
            },
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          const SizedBox(width: 10)
        ],
        backgroundColor: const Color(0xFF303151).withOpacity(0.4),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF303151),
                ),
                child: Text(
                  'Settings',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                )),
            ListTile(
              title: const Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PrivacyPolicy()));
              },
            ),
            ListTile(
              title: const Text('Terms and Conditions',
                  style: TextStyle(fontSize: 17)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TermsAndCondition()));
              },
            ),
            ListTile(
              title: const Text('About Us', style: TextStyle(fontSize: 17)),
              onTap: () {
                aboutUsPopUp();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 200,
              color: const Color(0xFF303151).withOpacity(0.1),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Hellooo...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "What do you want here?",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ScreenMostly(),
                            ));
                          },
                          child: const Text("Mostly Played")),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ScreenRecently(),
                            ));
                          },
                          child: const Text("Recently Played"))
                    ],
                  )
                ],
              ),
            ),
            PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                labelStyle: const TextStyle(fontSize: 18),
                indicator: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  width: 3,
                  color: Color(0xFF899CCF),
                ))),
                tabs: const [
                  Tab(
                    text: "Songs",
                  ),
                  Tab(
                    text: "Playlists",
                  ),
                  Tab(
                    text: "Favorites",
                  ),
                ],
              ),
            ),
            Expanded(
              //height: MediaQuery.of(context).size.height,
              child: TabBarView(
                controller: _tabController,
                children: const [
                  MusicList(),
                  ScreenPlaylists(),
                  ScreenFavorites(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  aboutUsPopUp() {
    final widthDsp = MediaQuery.of(context).size.width;
    final heightDsp = MediaQuery.of(context).size.height;
    showAboutDialog(
        context: context,
        applicationIcon: Container(
          height: heightDsp * 0.09,
          width: widthDsp * 0.18,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('assets/logo.png.png')),
          ),
        ),
        applicationName: "Muzicka",
        applicationVersion: '1.0.0',
        applicationLegalese: 'Copyright © 2023 Muzicka',
        children: [
          const Text(
              "Muzicka is an offline music player app which allows user to hear music from their storage and also do functions like add to favorites , create playlists , recently played , mostly played etc."),
          SizedBox(
            height: heightDsp * 0.02,
          ),
          const Text("App developed by  Basil Biju   (5.47 PM).")
        ]);
  }
}

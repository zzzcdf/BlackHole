import 'package:blackhole/liked.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Box likedBox;

  @override
  void initState() {
    super.initState();
    Hive.openBox('favorites');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AppBar(
          title: Text(
            'Library',
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return Transform.rotate(
                angle: 22 / 7 * 2,
                child: IconButton(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? null
                      : Colors.grey[700],
                  icon: const Icon(
                      Icons.horizontal_split_rounded), // line_weight_rounded),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              );
            },
          ),
        ),
        ListTile(
          title: Text('Now Playing'),
          leading: Icon(
            Icons.queue_music_rounded,
            color: Theme.of(context).brightness == Brightness.dark
                ? null
                : Colors.grey[700],
          ),
          onTap: () async {
            Navigator.pushNamed(context, '/nowplaying');
          },
        ),
        ListTile(
          title: Text('Recently Played'),
          leading: Icon(
            Icons.history_rounded,
            color: Theme.of(context).brightness == Brightness.dark
                ? null
                : Colors.grey[700],
          ),
          onTap: () async {
            Navigator.pushNamed(context, '/recent');
          },
        ),
        ListTile(
          title: Text('Favorite Songs'),
          leading: Icon(
            Icons.favorite_rounded,
            color: Theme.of(context).brightness == Brightness.dark
                ? null
                : Colors.grey[700],
          ),
          onTap: () async {
            await Hive.openBox('favorites');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LikedSongs(playlistName: 'favorites')));
          },
        ),
        ListTile(
          title: Text('My Music'),
          leading: Icon(
            Icons.music_note_rounded,
            color: Theme.of(context).brightness == Brightness.dark
                ? null
                : Colors.grey[700],
          ),
          onTap: () {
            Navigator.pushNamed(context, '/mymusic');
          },
        ),
        ListTile(
          title: Text('Playlists'),
          leading: Icon(
            Icons.playlist_play_rounded,
            color: Theme.of(context).brightness == Brightness.dark
                ? null
                : Colors.grey[700],
          ),
          onTap: () {
            Navigator.pushNamed(context, '/playlists');
          },
        ),
      ],
    );
  }
}

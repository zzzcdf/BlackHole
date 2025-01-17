import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:blackhole/audioplayer.dart';
import 'package:blackhole/miniplayer.dart';
import 'package:hive/hive.dart';

class RecentlyPlayed extends StatefulWidget {
  @override
  _RecentlyPlayedState createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  List _songs = [];
  bool added = false;

  void getSongs() async {
    await Hive.openBox('recent');
    _songs = Hive.box('recent').get('recentlyPlayed');
    added = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!added) {
      getSongs();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [
                  Colors.grey[850],
                  Colors.grey[900],
                  Colors.black,
                ]
              : [
                  Colors.white,
                  Theme.of(context).canvasColor,
                ],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text('Recently Played'),
                centerTitle: true,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.transparent
                    : Theme.of(context).accentColor,
                elevation: 0,
              ),
              body: (_songs == null || _songs.length == 0)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                "Nothing to ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "Show Here",
                                  style: TextStyle(
                                    fontSize: 50,
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Go and Play Something",
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      shrinkWrap: true,
                      itemCount: _songs.length,
                      itemBuilder: (context, index) {
                        return _songs.length == 0
                            ? SizedBox()
                            : ListTile(
                                leading: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                    imageUrl: _songs[index]["image"]
                                        .replaceAll('http:', 'https:'),
                                    placeholder: (context, url) => Image(
                                      image: AssetImage('assets/cover.jpg'),
                                    ),
                                  ),
                                ),
                                title: Text(
                                    '${_songs[index]["title"].split("(")[0]}'),
                                subtitle: Text(
                                    '${_songs[index]["artist"].split("(")[0]}'),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          opaque: false,
                                          pageBuilder: (_, __, ___) =>
                                              PlayScreen(
                                                data: {
                                                  'response': _songs,
                                                  'index': index,
                                                  'offline': false,
                                                },
                                                fromMiniplayer: false,
                                              )));
                                },
                              );
                      }),
            ),
          ),
          MiniPlayer(),
        ],
      ),
    );
  }
}

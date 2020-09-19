import 'package:flutter/material.dart';
import 'package:foodies/screens/home/home.dart';


Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Home());


    // case 'trackList':
    //   var album = settings.arguments;
    //   return MaterialPageRoute(builder: (context) => TrackList(album: album));

    // case 'addTrack':
    //   var arguments = settings.arguments;
    //   return MaterialPageRoute(
    //       builder: (context) => Addtrack(tracks: arguments));

    // case 'trackInfo':
    //   List<Object> track = settings.arguments;
    //   return MaterialPageRoute(
    //       builder: (context) => TrackInfo(track: track[0], album: track[1]));

    //   break;
    // case 'addAlbum':
    //   return MaterialPageRoute(builder: (context) => AddAlbum());
    // default:
    //   return MaterialPageRoute(builder: (context) => AlbumList());
  }
}
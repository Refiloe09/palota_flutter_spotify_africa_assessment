import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/presentation/models/playlist.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/presentation/models/category.dart' as spotify_category;
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

import '../models/artist.dart';
import '../models/mini_playlist.dart';
import '../models/track.dart';

/// Contains all the functions necessary to retrieve data from the API
class APIClient {
  final String _baseURL =
      'https://palota-jobs-africa-spotify-fa.azurewebsites.net/api/';
  // final String _apiKey = '_q6Qaip9V-PShHzF8q9l5yexp-z9IqwZB_o_6x882ts3AzFuo0DxuQ==';
  static const Map<String, String> _JSON_HEADERS = {
    "x-functions-key":
        "_q6Qaip9V-PShHzF8q9l5yexp-z9IqwZB_o_6x882ts3AzFuo0DxuQ=="
  };

  Future<List<MiniPlaylist>> getMiniPlaylists(String categoryId) async {

    //we need the http client to keep retrying in-case it failed
    var client = RetryClient(http.Client());

    List<MiniPlaylist> playlists = [];
    String url = '${_baseURL}browse/categories/$categoryId/playlists';

    try {
      var response = await client.get(Uri.parse(url), headers: _JSON_HEADERS);
      //if successful
      if (response.statusCode == 200) {
        Map<String, dynamic> obj = json.decode(response.body);

        playlists = (obj['playlists']['items'] as List)
            .map((p) => MiniPlaylist.fromJson(p))
            .toList();

        return playlists;
      } else {
        if (kDebugMode) print('Something went wrong!');
        return playlists;
      }
    } catch (e) {

      if (kDebugMode) print(e);
      return playlists;

    } finally {
      client.close();
    }
    //end of try-catch-finally block
  }

  Future<Playlist?> getPlaylist(String playlistId) async {

    //we need the http client to keep retrying in-case it failed
    var client = RetryClient(http.Client());

    String url = '${_baseURL}playlists/$playlistId';

    try {
      var response = await client.get(Uri.parse(url), headers: _JSON_HEADERS);
      //if successful
      if (response.statusCode == 200) {
        Map<String, dynamic> playJson = json.decode(response.body);
        // print(playJson);
        //make object from JSON
        Playlist playlist = Playlist.fromJson(playJson);

        //add tracks to above object
        var tracks = playJson['tracks']['items'] as List;
        playlist.setTracks = await getTracks(tracks);

        //add featured artists
        List<Artist> featuredArtists = [];
        for(Track track in playlist.tracks!){
          featuredArtists.addAll(track.artists!);
        }
        var seen = <String>{};
        List<Artist> uniqueArtist = featuredArtists.where((a) => seen.add(a.name)).toList();
        //unique artists only
        playlist.setFeaturedArtists = uniqueArtist;

        return playlist;
      } else {
        if (kDebugMode) print('Something went wrong!');
        return null;
      }
    } catch (e) {

      if (kDebugMode) {
        print('Error in making playlist');
        print(e);
      }
        return null;

    } finally {
      client.close();
    }
    //end of try-catch-finally block
  }

  Future<List<Track>> getTracks(var tracksJson) async{

    List<Track> tracks = [];
    for(dynamic track in tracksJson){
      Track? tempTrack;
      try {
        tempTrack = Track.fromJson(track['track']);
      }catch(e){
        continue;
      }
      tempTrack.setArtists = await getTrackArtists(track['track']['artists'] as List);
      tracks.add(tempTrack);
    }

    return tracks;
  }
  ///From the portion of the trackJson object, use the IDs to retrieve full artist information
  Future<List<Artist>> getTrackArtists(var artistsJson) async{
      //Make artist objects from the provided JSON
      List<Artist> artists = [];
      /**
       * The json object only has the name and id, we need to retrieve the image as well, so we query the API,
       * to access the full artist JSON object using the id
       */

      for(dynamic json in artistsJson) {
        Artist? tmp = await getArtist(json['id']);
        if (tmp != null) artists.add(tmp);

      }

      return artists;
  }

  ///Retrieve Artist info: name, imageUrl, imageSizes, followers, popularity
  Future<Artist?> getArtist(String artistId) async{

    var client = RetryClient(http.Client());
    String url = '${_baseURL}artists/$artistId';
    try{

      var response = await client.get(Uri.parse(url), headers: _JSON_HEADERS);
      if(response.statusCode == 200){

        return Artist.fromJson(json.decode(response.body));

      }else{
        if(kDebugMode) {
          print('Artist id: $artistId -- Something went wrong!');
          print(response.statusCode);
          print(response.body);
        }
        return null;
      }

    }catch(e){

      if(kDebugMode) print(e);
      return null;

    }finally{
      client.close();
    }

  }

  ///Retrieve Category Info: full name and imageUrl
  Future<spotify_category.Category?> getCategory(String categoryId) async{

    //we need the http client to keep retrying in-case it failed
    var client = RetryClient(http.Client());
    String url = '${_baseURL}browse/categories/$categoryId';

    try{
      var response = await client.get(Uri.parse(url),headers: _JSON_HEADERS);
      if(response.statusCode == 200){

        return spotify_category.Category.fromJson(json.decode(response.body));
      }else{
        if(kDebugMode) print('Something went wrong!');
        return null;
      }

    }catch(e){

      if(kDebugMode) print(e);
      return null;

    }finally{
      client.close();
    }

  }
}

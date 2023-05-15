import 'package:flutter_spotify_africa_assessment/features/spotify/presentation/models/artist.dart';

import 'common_functions.dart';

class Track {
  String id;
  String imgUrl;
  double imgHeight;
  double imgWidth;
  String name;
  String duration;
  List<Artist>? artists;

  Track(
      {required this.id,
      required this.imgUrl,
      required this.imgHeight,
      required this.imgWidth,
      required this.name,
      required this.duration,
      this.artists});
  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  set setArtists(List<Artist> artists) {
    this.artists = artists;
  }

  @override
  String toString() {
    return 'Track{id: $id, imgUrl: $imgUrl, imgHeight: $imgHeight, imgWidth: $imgWidth, name: $name, duration: $duration, artists: $artists}';
  }
}

_$TrackFromJson(Map<String, dynamic> json) => Track(
    id: json['id'],
    imgUrl: json['album']['images'][2]['url'],
    imgHeight: (json['album']['images'][2]['height'] as int).toDouble(),
    imgWidth: (json['album']['images'][2]['width'] as int).toDouble(),
    name: json['name'],
    duration:
        formatDurationInMmSs(Duration(milliseconds: json['duration_ms'])));

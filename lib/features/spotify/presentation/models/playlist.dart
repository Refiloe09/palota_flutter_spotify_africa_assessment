import 'track.dart';
import 'artist.dart';

class Playlist {
  String id;
  String name;
  String description;
  String imgUrl;
  String owner;
  int followers;
  List<Track>? tracks;
  List<Artist>? featuredArtists;

  Playlist(
      {required this.id,
      required this.name,
      required this.description,
      required this.imgUrl,
      required this.owner,
      required this.followers});

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);

  set setTracks(List<Track> tracks) {
    this.tracks = tracks;
  }

  set setFeaturedArtists(List<Artist> artists) {
    featuredArtists = artists;
  }

  @override
  String toString() {
    return 'Playlist{id: $id, name: $name, description: $description, imgUrl: $imgUrl, owner: $owner, followers: $followers, tracks: $tracks, featuredArtists: $featuredArtists}';
  }
}

_$PlaylistFromJson(Map<String, dynamic> json) => Playlist(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    imgUrl: json['images'][0]['url'],
    owner: json['owner']['display_name'],
    followers: json['followers']['total'] as int);

class Artist {
  String id;
  String name;
  int followers;
  String imgUrl;
  double imgHeight;
  double imgWidth;
  int popularity;

  Artist(
      {required this.id,
      required this.name,
      required this.followers,
      required this.imgUrl,
      required this.imgHeight,
      required this.imgWidth,
      required this.popularity});

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  @override
  String toString() {
    return 'Artist{id: $id, name: $name, followers: $followers, imgUrl: $imgUrl, imgHeight: $imgHeight, imgWidth: $imgWidth, popularity: $popularity}';
  }
}

_$ArtistFromJson(Map<String, dynamic> json) => Artist(
    id: json['id'],
    name: json['name'],
    followers: json['followers']['total'],
    imgUrl: ((json['images'] as List).isNotEmpty) ? json['images'][2]['url'] : '',
    imgHeight: ((json['images'] as List).isNotEmpty) ? (json['images'][2]['height'] as int).toDouble() : 160,
    imgWidth: ((json['images'] as List).isNotEmpty) ? (json['images'][2]['width'] as int).toDouble() : 160,
    popularity: json['popularity']
);

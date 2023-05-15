
class MiniPlaylist{

    String id;
    String name;
    String imgUrl;

    MiniPlaylist({required this.id, required this.name, required this.imgUrl});

    factory MiniPlaylist.fromJson(Map<String, dynamic> json) => _$MiniPlaylistFromJson(json);

    @override
  String toString() {
    return 'MiniPlaylist{id: $id, name: $name, imgUrl: $imgUrl}';
  }
}

_$MiniPlaylistFromJson(Map<String, dynamic> json) => MiniPlaylist(
    id: json['id'],
    name: json['name'],
    imgUrl: json['images'][0]['url']
);
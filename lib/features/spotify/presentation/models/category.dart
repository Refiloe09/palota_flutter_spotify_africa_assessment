
class Category{

  String name;
  String imgUrl;

  Category({required this.name, required this.imgUrl});
  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

}

_$CategoryFromJson(Map<String, dynamic> json) => Category(
    name: json['name'],
    imgUrl: json['icons'][0]['url']
);
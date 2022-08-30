final String tableNews = 'news';

class NewsFields {
  static final List<String> values = [
    id, imageUrl, author, title
  ];
  static final String id = '_id';
  static final String imageUrl = 'img';
  static final String author = 'author';
  static final String title = 'title';
}

class NewsModel {
  final int? id;
  final String imageUrl;
  final String author;
  final String title;

  NewsModel(
      {this.id,
      required this.imageUrl,
      required this.author,
      required this.title});

  static NewsModel fromJson(Map<String, Object?> json) => NewsModel(
    id: json[NewsFields.id] as int?,
    title: json[NewsFields.title] as String,
    author: json[NewsFields.author] as String,
    imageUrl: json[NewsFields.imageUrl] as String
  );

  Map<String, Object?> toJson() => {
        NewsFields.id: id,
        NewsFields.title: title,
        NewsFields.author: author,
        NewsFields.imageUrl: imageUrl
      };
  NewsModel copy({int? id, String? title, String? author, String? imageUrl}) =>
      NewsModel(
          id: id ?? this.id,
          title: title ?? this.title,
          author: author ?? this.author,
          imageUrl: imageUrl ?? this.imageUrl);
}

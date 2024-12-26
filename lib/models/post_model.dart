class Post {
  final String id;
  final String title;
  final String content;
  final String imageURL;
  final String createdAt;
   int likesCount;
   int commentsCount;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.imageURL,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
  });

  // Chuyển đổi từ JSON sang đối tượng Post
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageURL: json['imageURL'],
      createdAt: json['createdAt'],
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
    );
  }

  // Chuyển đổi từ đối tượng Post sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageURL': imageURL,
      'createdAt': createdAt,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
    };
  }
}

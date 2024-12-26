class Comment {
  final String id;
  final String postId;
  final String text; // The API uses "Text", so we'll use that here
  final String createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'text': text, // Mapping 'text' to 'Text' for API compatibility
      'createdAt': createdAt,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',  // Ensure 'id' is not null
      postId: json['postId'] ?? '',  // Ensure 'postId' is not null
      text: json['text'] ?? '',  // Handle potential null value for 'Text'
      createdAt: json['createdAt'] ?? '',  // Handle potential null value for 'createdAt'
    );
  }
}

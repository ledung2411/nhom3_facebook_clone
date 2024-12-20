import 'dart:convert';
import 'package:bt_nhom3/models/post_comment_model.dart';
import 'package:http/http.dart' as http;
import '../env.dart';
import '../models/post_model.dart';


  // Lấy danh sách bài viết
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('${Env.baseUrl}/posts'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Error connecting to the server: $e');
    }
  }
Future<void> createPost(Post post) async {
  final url = Uri.parse('${Env.baseUrl}/posts');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'Id': post.id, // Lưu ý: Id viết hoa nếu server yêu cầu
        'Title': post.title, // Key phải là Title
        'Content': post.content, // Key phải là Content
        'imageURL': post.imageURL, // Key phải là imageURL
        'CreatedAt': post.createdAt, // Đúng định dạng ISO
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Post created successfully: ${response.body}');
    } else {
      print('Failed to create post: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to create post: ${response.body}');
    }
  } catch (e) {
    print('Error creating post: $e');
    rethrow;
  }
}


Future<int> addLike(String postId, String userId) async {
  final url = Uri.parse('${Env.baseUrl}/likes');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'postId': postId, 'userId': userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['likesCount'] ?? 0; // Trả về likesCount từ server
    } else {
      throw Exception('Failed to add like: ${response.statusCode}');
    }
  } catch (e) {
    print('Error adding like: $e');
    rethrow;
  }
}

Future<int> removeLike(String postId, String userId) async {
  final url = Uri.parse('${Env.baseUrl}/likes/$postId/$userId');
  try {
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['likesCount'] ?? 0;
    } else {
      throw Exception('Failed to remove like: ${response.statusCode}');
    }
  } catch (e) {
    print('Error removing like: $e');
    rethrow;
  }
}


Future<void> addComment(Comment comment) async {
  final url = Uri.parse('${Env.baseUrl}/comments');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(comment.toJson()),
    );

    // Log dữ liệu gửi đi
    print('Request Body: ${json.encode(comment.toJson())}');
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Comment added successfully');
    } else {
      throw Exception('Failed to add comment: ${response.statusCode}');
    }
  } catch (e) {
    print('Error adding comment: $e');
    rethrow;
  }
}

Future<List<Comment>> getCommentsByPost(String postId) async {
  final url = Uri.parse('${Env.baseUrl}/comments/post/$postId');

  try {
    final response = await http.get(url);

    print('GET Request URL: $url');
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}'); // Check the response body

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching comments: $e');
    rethrow;
  }
}


Future<void> deleteComment(String commentId) async {
  final url = Uri.parse('${Env.baseUrl}/comments/$commentId');

  try {
    final response = await http.delete(url);

    // Log request và response
    print('DELETE Request URL: $url');
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('Comment deleted successfully');
    } else {
      throw Exception('Failed to delete comment: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting comment: $e');
    rethrow;
  }
}

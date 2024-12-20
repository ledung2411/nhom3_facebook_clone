import 'package:bt_nhom3/models/post_comment_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../api/post_api.dart'; // Ensure these methods are implemented properly in your API file
import '../models/post_model.dart'; // Post model import
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> _likedPosts = {}; // Track liked posts
  final Map<String, List<Comment>> _comments = {}; // Comments for each post
  final TextEditingController _searchController = TextEditingController();
  final Uuid uuid = Uuid(); // For generating GUID
  String _searchQuery = '';
  List<Post> _posts = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isProcessing = false;
  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  // Fetch posts from API
  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      List<Post> posts = await fetchPosts(); // Ensure this function fetches posts
      setState(() {
        _posts = posts;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading posts: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch comments for a specific post
  Future<void> _fetchComments(String postId) async {
    try {
      List<Comment> comments = await getCommentsByPost(postId); // Ensure this function is implemented
      setState(() {
        _comments[postId] = comments;
      });
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  // Show modal to create new post
  void _showCreatePostModal() {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _contentController = TextEditingController();
    final TextEditingController _imageURLController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Post'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Content'),
                  maxLines: 3,
                ),
                TextField(
                  controller: _imageURLController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_titleController.text.trim().isEmpty ||
                    _contentController.text.trim().isEmpty ||
                    _imageURLController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Title, Content, and Image URL cannot be empty'),
                    ),
                  );
                  return;
                }

                final post = Post(
                  id: uuid.v4(), // Generate valid GUID
                  title: _titleController.text.trim(),
                  content: _contentController.text.trim(),
                  imageURL: _imageURLController.text.trim(),
                  createdAt: DateTime.now().toIso8601String(),
                  likesCount: 0, // Default is 0 likes
                  commentsCount: 0, // Default is 0 comments
                );

                try {
                  await createPost(post); // Ensure this function is implemented in your API
                  _fetchPosts(); // Reload posts
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post created successfully')),
                  );
                } catch (e) {
                  print('Error creating post: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error creating post: $e')),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showAddCommentModal(String postId) {
    final TextEditingController _commentController = TextEditingController();

    // Fetch comments before showing the modal
    _fetchComments(postId).then((_) {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modalSetState) {
              // Get the list of comments, default to empty if null
              final List<Comment> comments = _comments[postId] ?? [];

              return AlertDialog(
                title: const Text('Comments'),
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display comments
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 200,
                          minHeight: 50, // Minimum height
                        ),
                        child: comments.isNotEmpty
                            ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return ListTile(
                              title: Text(comment.text),
                              subtitle: Text(_formatDate(comment.createdAt)),
                            );
                          },
                        )
                            : const Center(
                          child: Text(
                            'No comments yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Comment input field
                      TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          labelText: 'Add a comment',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final commentText = _commentController.text.trim();
                      if (commentText.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Comment cannot be empty')),
                        );
                        return;
                      }

                      final comment = Comment(
                        id: uuid.v4(),
                        postId: postId,
                        text: commentText,
                        createdAt: DateTime.now().toIso8601String(),
                      );

                      try {
                        await addComment(comment); // Ensure this function is implemented

                        // Fetch updated comments
                        await _fetchComments(postId);

                        // Clear the comment input
                        _commentController.clear();

                        // Update the modal's state to show new comments
                        modalSetState(() {});

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Comment added successfully')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error adding comment: $e')),
                        );
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(
            'assets/facebook_logo.png', // Đường dẫn tới biểu tượng Facebook
            fit: BoxFit.contain,
          ),
        ),
        title: const Text(
          'Facebook',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Xử lý khi nhấn nút thêm
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Xử lý khi nhấn nút tìm kiếm
            },
          ),

        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : _posts.isEmpty
          ? const Center(child: Text('No posts found'))
          : ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return _buildPost(context, post);
        },
      ),
    );
  }

  Widget _buildPost(BuildContext context, Post post) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(post.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(_formatDate(post.createdAt)),
            trailing: IconButton(
              icon: Icon(
                _likedPosts.contains(post.id) ? Icons.favorite : Icons.favorite_border,
                color: _likedPosts.contains(post.id) ? Colors.red : null,
              ),
              onPressed: () async {
                if (_isProcessing) return; // Ngăn chặn việc nhấn liên tục

                setState(() {
                  _isProcessing = true;
                });

                try {
                  int updatedLikes;

                  // Kiểm tra trạng thái Like hiện tại
                  if (_likedPosts.contains(post.id)) {
                    // Nếu đã Like -> gửi yêu cầu Unlike
                    updatedLikes = await removeLike(post.id, 'userId');
                    setState(() {
                      _likedPosts.remove(post.id);
                      post.likesCount = updatedLikes; // Cập nhật Like count
                    });
                  } else {
                    // Nếu chưa Like -> gửi yêu cầu Like
                    try {
                      updatedLikes = await addLike(post.id, 'userId');
                      setState(() {
                        _likedPosts.add(post.id);
                        post.likesCount = updatedLikes; // Cập nhật Like count
                      });
                    } catch (e) {
                      // Kiểm tra nếu lỗi là 400 (bài đã được Like trước đó)
                      if (e.toString().contains('400')) {
                        print('Post already liked. Auto-unlike.');
                        updatedLikes = await removeLike(post.id, 'userId'); // Tự động Unlike
                        setState(() {
                          _likedPosts.remove(post.id);
                          post.likesCount = updatedLikes; // Cập nhật Like count
                        });
                      } else {
                        // Xử lý các lỗi khác
                        print('Error updating like: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error updating like: $e')),
                        );
                      }
                    }
                  }
                } catch (e) {
                  print('Error updating like: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating like: $e')),
                  );
                } finally {
                  setState(() {
                    _isProcessing = false; // Đặt lại trạng thái xử lý
                  });
                }
              },

            ),



          ),
          if (post.imageURL.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Image.network(
                post.imageURL,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200, // Explicit height for image
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(post.content),
          ),

          const SizedBox(height: 8),
          Padding(

            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [

                IconButton(
                  icon: Icon(
                    _likedPosts.contains(post.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: _likedPosts.contains(post.id) ? Colors.red : null,
                  ),
                  onPressed: () async {
                    // Gọi hàm xử lý Like/Unlike tại đây
                  },
                ),
                Text('${post.likesCount} Likes'),
                const SizedBox(width: 16),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey, // Màu sắc của đường thẳng
                ),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    _showAddCommentModal(post.id);
                  },
                ),
                Text('${post.commentsCount} Comments'),
                const SizedBox(width: 16),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey, // Màu sắc của đường thẳng
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // Gọi hàm xử lý chia sẻ tại đây
                  },

                ),
                const Text('Share'),

              ],
            ),

          ),

        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}

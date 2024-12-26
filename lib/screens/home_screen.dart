<<<<<<< Updated upstream
import 'package:flutter/material.dart';
=======
// Part 1: Core definitions and methods
import 'package:bt_nhom3/models/post_comment_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../api/post_api.dart';
import '../models/post_model.dart';
import 'dart:convert';
>>>>>>> Stashed changes

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
<<<<<<< Updated upstream
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title:const Text("Home"),
            floating: true,  // AppBar will appear when scrolling down.
            pinned: true,    // Keep AppBar visible when scrolling up.
            snap: true,      // Snap behavior when scrolling up/down.
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title:const Text("Home"),
              background: Image.asset(
                'assets/home_tab_logo.png',  // Home tab logo
                fit: BoxFit.cover,
              ),
            ),
          ),
        ];
      },
      body: ListView.builder(
        itemCount: 50,  // Example post count
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text('Post #$index'),
            subtitle:const Text('This is a post description'),
          );
        },
      ),
    );
  }
}
=======
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> _likedPosts = {};
  final Map<String, List<Comment>> _comments = {};
  final TextEditingController _searchController = TextEditingController();
  final Uuid uuid = Uuid();
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

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      List<Post> posts = await fetchPosts();
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

  Future<void> _fetchComments(String postId) async {
    try {
      List<Comment> comments = await getCommentsByPost(postId);
      setState(() {
        _comments[postId] = comments;
      });
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  void _showCreatePostModal() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final imageURLController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create New Post',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 3,
            ),
            SizedBox(height: 12),
            TextField(
              controller: imageURLController,
              decoration: InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (titleController.text.trim().isEmpty ||
                    contentController.text.trim().isEmpty ||
                    imageURLController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final post = Post(
                  id: uuid.v4(),
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  imageURL: imageURLController.text.trim(),
                  createdAt: DateTime.now().toIso8601String(),
                  likesCount: 0,
                  commentsCount: 0,
                );

                try {
                  await createPost(post);
                  _fetchPosts();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Post created successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error creating post: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Create Post'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAddCommentModal(String postId) {
    final commentController = TextEditingController();

    _fetchComments(postId).then((_) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            final comments = _comments[postId] ?? [];

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: comments.isEmpty
                        ? Center(
                      child: Text(
                        'No comments yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                        : ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return Card(
                          child: ListTile(
                            title: Text(comment.text),
                            subtitle: Text(_formatDate(comment.createdAt)),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () => _handleAddComment(
                            postId,
                            commentController,
                            setState,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Future<void> _handleAddComment(
      String postId,
      TextEditingController controller,
      StateSetter setState,
      ) async {
    final commentText = controller.text.trim();
    if (commentText.isEmpty) return;

    final comment = Comment(
      id: uuid.v4(),
      postId: postId,
      text: commentText,
      createdAt: DateTime.now().toIso8601String(),
    );

    try {
      await addComment(comment);
      controller.clear();
      await _fetchComments(postId);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding comment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }// Part 2: UI Implementation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Social Feed',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined, color: Colors.black87),
            onPressed: _showCreatePostModal,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPosts,
        child: _isLoading
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
      ),
    );
  }

  Widget _buildPost(BuildContext context, Post post) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, color: Colors.blue),
            ),
            title: Text(
              post.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              _formatDate(post.createdAt),
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            trailing: IconButton(
              icon: Icon(
                _likedPosts.contains(post.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _likedPosts.contains(post.id) ? Colors.red : null,
              ),
              onPressed: () async {
                if (_isProcessing) return;

                setState(() {
                  _isProcessing = true;
                });

                try {
                  int updatedLikes;
                  if (_likedPosts.contains(post.id)) {
                    updatedLikes = await removeLike(post.id, 'userId');
                    setState(() {
                      _likedPosts.remove(post.id);
                      post.likesCount = updatedLikes;
                    });
                  } else {
                    try {
                      updatedLikes = await addLike(post.id, 'userId');
                      setState(() {
                        _likedPosts.add(post.id);
                        post.likesCount = updatedLikes;
                      });
                    } catch (e) {
                      if (e.toString().contains('400')) {
                        updatedLikes = await removeLike(post.id, 'userId');
                        setState(() {
                          _likedPosts.remove(post.id);
                          post.likesCount = updatedLikes;
                        });
                      } else {
                        throw e;
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
                    _isProcessing = false;
                  });
                }
              },
            ),
          ),
          if (post.imageURL.isNotEmpty)
            Container(
              width: double.infinity,
              height: 250,
              child: Image.network(
                post.imageURL,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              post.content,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    _buildActionButton(
                      icon: _likedPosts.contains(post.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      label: '${post.likesCount} Likes',
                      color: _likedPosts.contains(post.id) ? Colors.red : Colors.grey[700],
                      onPressed: () async {
                        if (_isProcessing) return;
                        setState(() {
                          _isProcessing = true;
                        });
                        try {
                          if (_likedPosts.contains(post.id)) {
                            final updatedLikes = await removeLike(post.id, 'userId');
                            setState(() {
                              _likedPosts.remove(post.id);
                              post.likesCount = updatedLikes;
                            });
                          } else {
                            final updatedLikes = await addLike(post.id, 'userId');
                            setState(() {
                              _likedPosts.add(post.id);
                              post.likesCount = updatedLikes;
                            });
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error updating like: $e')),
                          );
                        } finally {
                          setState(() {
                            _isProcessing = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 24),
                    _buildActionButton(
                      icon: Icons.chat_bubble_outline,
                      label: '${post.commentsCount} Comments',
                      color: Colors.grey[700],
                      onPressed: () => _showAddCommentModal(post.id),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }}
>>>>>>> Stashed changes

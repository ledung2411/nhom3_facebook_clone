import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<int> _likedPosts = {}; // Lưu trạng thái bài viết đã like
  final TextEditingController _searchController = TextEditingController(); // Bộ lọc tìm kiếm
  String _searchQuery = ''; // Nội dung tìm kiếm

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.blue, // Màu Facebook
              floating: true,
              pinned: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/facebook_logo.png',
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Facebook",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      _showSearchBar(context); // Mở thanh tìm kiếm
                    },
                  ),
                ],
              ),
              expandedHeight: 60,
            ),
          ];
        },
        body: ListView.builder(
          itemCount: 10, // Số bài đăng (ví dụ)
          itemBuilder: (context, index) {
            // Kiểm tra bài viết có khớp với nội dung tìm kiếm
            if (_searchQuery.isNotEmpty &&
                !'This is the content of post #$index'
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase())) {
              return const SizedBox.shrink();
            }
            return _buildPost(context, index);
          },
        ),
      ),
    );
  }

  Widget _buildPost(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần trên bài đăng (ảnh đại diện và tên người dùng)
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/account_tab_logo.png'),
            ),
            title: Text('User $index',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('10 mins ago'),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
                // Thêm menu hành động
              },
            ),
          ),

          // Phần nội dung bài đăng
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'This is the content of post #$index.',
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // Ảnh trong bài đăng (nếu có)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Image.asset(
              'assets/home_tab_logo.png', // Hình ảnh bài viết (giả định)
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          ),

          // Nút hành động (Like, Comment, Share)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_likedPosts.contains(index)) {
                        _likedPosts.remove(index);
                      } else {
                        _likedPosts.add(index);
                      }
                    });
                  },
                  child: _actionButton(
                    Icons.thumb_up_alt_outlined,
                    _likedPosts.contains(index) ? 'Liked' : 'Like',
                    isActive: _likedPosts.contains(index),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showCommentDialog(context, index);
                  },
                  child: _actionButton(Icons.comment_outlined, 'Comment'),
                ),
                GestureDetector(
                  onTap: () {
                    // Xử lý chia sẻ
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Post shared!'),
                    ));
                  },
                  child: _actionButton(Icons.share_outlined, 'Share'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, {bool isActive = false}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: isActive ? Colors.blue : Colors.grey[700]),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.grey[700],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _showCommentDialog(BuildContext context, int index) {
    final TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Comment'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(hintText: 'Write your comment...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Comment added: ${commentController.text}'),
                ));
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _showSearchBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Posts'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: 'Enter search query...'),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

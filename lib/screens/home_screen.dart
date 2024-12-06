import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<int> _likedPosts = {}; // Lưu trạng thái bài viết đã like
  final Map<int, List<String>> _comments = {}; // Danh sách comment cho mỗi bài viết

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
                ],
              ),
              expandedHeight: 60,
            ),
          ];
        },
        body: ListView.builder(
          itemCount: 10, // Số bài đăng (ví dụ)
          itemBuilder: (context, index) {
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
                    _showCommentsBottomSheet(context, index);
                  },
                  child: _actionButton(Icons.comment_outlined, 'Comment'),
                ),
                GestureDetector(
                  onTap: () {
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

  void _showCommentsBottomSheet(BuildContext context, int postIndex) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Hiển thị danh sách comment
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _comments[postIndex]?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(_comments[postIndex]![index]),
                    );
                  },
                ),
              ),
              // Input để thêm comment mới
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        setState(() {
                          if (_comments[postIndex] == null) {
                            _comments[postIndex] = [];
                          }
                          _comments[postIndex]!.add(commentController.text);
                          commentController.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

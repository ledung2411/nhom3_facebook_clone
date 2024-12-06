import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                      // Tìm kiếm
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
                _actionButton(Icons.thumb_up_alt_outlined, 'Like'),
                _actionButton(Icons.comment_outlined, 'Comment'),
                _actionButton(Icons.share_outlined, 'Share'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
      ],
    );
  }
}

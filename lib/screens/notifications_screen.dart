import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,  // Thay màu nền của appbar giống Facebook
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Xử lý tìm kiếm nếu cần
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _buildNotification(
            icon: Icons.notifications,
            title: "Đã có bài đăng mới.",
            time: "2 giờ trước",
            onTap: () {
              // Xử lý khi nhấn vào thông báo
            },
          ),
          _buildNotification(
            icon: Icons.message,
            title: "Bạn có tin nhắn mới.",
            time: "4 giờ trước",
            onTap: () {
              // Xử lý khi nhấn vào thông báo
            },
          ),
          _buildNotification(
            icon: Icons.thumb_up,
            title: "Có người thích bài viết của bạn.",
            time: "6 giờ trước",
            onTap: () {
              // Xử lý khi nhấn vào thông báo
            },
          ),
          _buildNotification(
            icon: Icons.add_circle_outline,
            title: "Bạn có yêu cầu kết bạn mới.",
            time: "8 giờ trước",
            onTap: () {
              // Xử lý khi nhấn vào thông báo
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotification({
    required IconData icon,
    required String title,
    required String time,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Bo góc cho card giống Facebook
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blueAccent,
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        onTap: onTap,
      ),
    );
  }
}

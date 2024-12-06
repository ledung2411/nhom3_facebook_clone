import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Thông báo 1: Đã có bài đăng mới."),
            subtitle: const Text("2 giờ trước"),
            onTap: () {
              // Xử lý khi nhấn vào thông báo
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Thông báo 2: Bạn có tin nhắn mới."),
            subtitle: const Text("4 giờ trước"),
            onTap: () {
              // Xử lý khi nhấn vào thông báo
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Thông báo 3: Có người thích bài viết của bạn."),
            subtitle: const Text("6 giờ trước"),
            onTap: () {
              // Xử lý khi nhấn vào thông báo
            },
          ),
        ],
      ),
    );
  }
}

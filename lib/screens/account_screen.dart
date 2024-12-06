import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Thêm chức năng tìm kiếm
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Phần thông tin người dùng
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/minhtu.jpg'), // Thay ảnh đại diện
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Nguyễn Minh Tú",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text("Xem trang cá nhân"),
                      ],
                    ),
                  ),
                  const Icon(Icons.notifications, size: 30),
                ],
              ),
            ),

            const Divider(),

            // Phần shortcut
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    5,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(
                                'assets/facebook_logo.png'), // Thay ảnh shortcut
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Tên người dùng",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const Divider(),

            // Phần chức năng chính
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3.5,
              ),
              padding: const EdgeInsets.all(8.0),
              itemCount: 8, // Số lượng ô chức năng
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text("Chức năng ${index + 1}"),
                    onTap: () {
                      // Thêm chức năng khi nhấn vào
                    },
                  ),
                );
              },
            ),

            const Divider(),

            // Phần cuối menu
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Trợ giúp & hỗ trợ"),
              onTap: () {
                // Thêm chức năng
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Cài đặt & quyền riêng tư"),
              onTap: () {
                // Thêm chức năng
              },

            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Đăng Xuất"),
              onTap: () {
                // Thêm chức năng
              },

            ),
          ],
        ),
      ),
    );
  }
}

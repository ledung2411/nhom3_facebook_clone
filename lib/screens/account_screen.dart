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
                    backgroundImage: const AssetImage('assets/thanhtu.jpg'), // Thay ảnh đại diện
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Phạm Thanh Tú",
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
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage:
                            AssetImage('assets/facebook_logo.png'),

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
            const ListTile(
              leading: Icon(Icons.help_outline),
              title: Text("Trợ giúp & hỗ trợ"),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text("Cài đặt & quyền riêng tư"),
            ),
            const ListTile(
              leading: Icon(Icons.logout),
              title: Text("Đăng Xuất"),
            ),
          ],
        ),
      ),
    );
  }
}

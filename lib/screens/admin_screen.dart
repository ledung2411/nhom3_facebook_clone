import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import 'login_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await AuthService.logout();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi đăng xuất: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Quản lý người dùng'),
                onTap: () {
                  // TODO: Navigate to user management
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.post_add),
                title: const Text('Quản lý bài viết'),
                onTap: () {
                  // TODO: Navigate to post management
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Quản lý sản phẩm'),
                onTap: () {
                  // TODO: Navigate to product management
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Quản lý thông báo'),
                onTap: () {
                  // TODO: Navigate to notification management
                },
              ),
            ),
            const SizedBox(height: 20),
            // Thống kê
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thống kê hệ thống',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatItem(
                          icon: Icons.person,
                          label: 'Người dùng',
                          value: '1,234',
                        ),
                        StatItem(
                          icon: Icons.post_add,
                          label: 'Bài viết',
                          value: '456',
                        ),
                        StatItem(
                          icon: Icons.shopping_cart,
                          label: 'Sản phẩm',
                          value: '789',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30),
        const SizedBox(height: 5),
        Text(label),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
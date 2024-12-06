import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
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

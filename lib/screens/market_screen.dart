import 'package:flutter/material.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,  // Example product count
      itemBuilder: (context, index) {
        return ListTile(
          leading:const Icon(Icons.shopping_cart),
          title: Text('Product #$index'),
          subtitle:const Text('Product description'),
        );
      },
    );
  }
}


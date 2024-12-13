import 'package:bt_nhom3/api/product_api.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  final String productName;
  final double productPrice;
  final String productImage;
  final String productDescription;
  final VoidCallback onProductChanged; // Callback để làm mới danh sách

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productDescription,
    required this.onProductChanged,
  });

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.productName;
    priceController.text = widget.productPrice.toString();
    imageController.text = widget.productImage;
    descriptionController.text = widget.productDescription;
  }

  void _showEditModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Product'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text;
                final price = double.tryParse(priceController.text) ?? 0;
                final image = imageController.text;
                final description = descriptionController.text;

                if (name.isNotEmpty && image.isNotEmpty && description.isNotEmpty) {
                  try {
                    await updateProduct(
                      id: widget.productId,
                      name: name,
                      price: price,
                      image: image,
                      description: description,
                    );
                    widget.onProductChanged(); // Làm mới danh sách
                    Navigator.pop(context); // Đóng modal
                  } catch (e) {
                    print('Error updating product: $e');
                  }
                } else {
                  print('All fields are required');
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(BuildContext context) async {
    try {
      await deleteProduct(widget.productId);
      widget.onProductChanged(); // Làm mới danh sách
      Navigator.pop(context); // Đóng màn hình chi tiết
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditModal(context),
            tooltip: 'Edit Product',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteProduct(context),
            tooltip: 'Delete Product',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.productImage,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.productName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${widget.productPrice}',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.productDescription,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

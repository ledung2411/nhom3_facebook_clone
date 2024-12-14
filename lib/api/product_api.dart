import 'dart:convert';
import 'package:bt_nhom3/env.dart';
import 'package:bt_nhom3/models/product_model.dart';
import 'package:http/http.dart' as http;


Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('${Env.baseUrl}/ProductApi'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}
Future<void> createProduct({
  required String name,
  required double price,
  required String image,
  required String description,
}) async {
  final url = Uri.parse('${Env.baseUrl}/ProductApi');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'name': name,
    'price': price,
    'image': image,
    'description': description,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    print('Product created successfully');
  } else {
    throw Exception('Failed to create product: ${response.statusCode}');
  }
}
Future<Product> fetchProductById(int id) async {
  final response = await http.get(Uri.parse('${Env.baseUrl}/ProductApi/$id'));

  if (response.statusCode == 200) {
    return Product.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to fetch product with id $id');
  }
}

// API để cập nhật sản phẩm
Future<void> updateProduct({
  required int id,
  required String name,
  required double price,
  required String image,
  required String description,
}) async {
  final url = Uri.parse('${Env.baseUrl}/ProductApi/$id');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'id': id.toString(),
    'name': name,
    'price': price,
    'image': image,
    'description': description,
  });

  final response = await http.put(url, headers: headers, body: body);

  if (response.statusCode == 204) {
    print('Product updated successfully');
  } else {
    throw Exception('Failed to update product: ${response.statusCode}');
  }
}

// API để xóa sản phẩm
Future<void> deleteProduct(int id) async {
  final url = Uri.parse('${Env.baseUrl}/ProductApi/$id');

  final response = await http.delete(url);

  if (response.statusCode == 204) {
    print('Product deleted successfully');
  } else {
    throw Exception('Failed to delete product: ${response.statusCode}');
  }
}
// API để tìm kiếm sản phẩm
Future<List<Product>> fetchProductsByKeyword(String keyword) async {
  final response = await http.get(
    Uri.parse('${Env.baseUrl}/ProductApi/search?keyword=$keyword'),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Failed to search products with keyword: $keyword');
  }
}

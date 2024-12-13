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

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
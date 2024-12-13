import 'dart:convert';
import 'package:bt_nhom3/models/product_model.dart';
import 'package:http/http.dart' as http;


Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://firstorangepen38.conveyor.cloud/api/ProductApi'));

  if (response.statusCode == 200) {
    // Nếu thành công, parse dữ liệu JSON
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  } else {
    // Nếu thất bại, ném lỗi
    throw Exception('Failed to load products');
  }
}

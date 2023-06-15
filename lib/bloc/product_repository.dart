import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:online_shop/bloc/product_models.dart';

class ProductRepository {
  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://api.hiocoding.com/api/product'));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<Product> products = List<Product>.from(jsonBody['data']
          .map((product) => Product.fromJson(product)));
      return products;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<void> deleteProduct(Product product) async {
    final response = await http.delete(
        Uri.parse('https://api.hiocoding.com/api/product/${product.id}'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  Future<void> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('https://api.hiocoding.com/api/product/${product.id}'),
      body: {
        'name': product.name,
        'image': product.image,
        'description': product.description,
        'price': product.price,
        'status': product.status,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }
}

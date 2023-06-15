import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:online_shop/detail.dart';
import 'bloc/product_models.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> _searchResults = [];
  TextEditingController _searchController = TextEditingController();

  Future<void> _searchProducts(String searchQuery) async {
    final String apiUrl = 'https://api.hiocoding.com/api/product';
    final Map<String, String> queryParams = {'search': searchQuery};
    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> jsonProducts = data['data'];

      final List<Product> products = jsonProducts
          .map((jsonProduct) => Product.fromJson(jsonProduct))
          .toList();

      setState(() {
        _searchResults = products;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            ),
            style: TextStyle(
              color: Colors.black,
            ),
            onSubmitted: (value) {
              String searchQuery = value;
              _searchProducts(searchQuery);
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              String searchQuery = _searchController.text;
              _searchProducts(searchQuery);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _searchResults.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
                thickness: 0,
              ),
              itemBuilder: (context, index) {
                final product = _searchResults[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailProduk(product: product),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Image.network(
                      product.image!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name!),
                    subtitle: Text(
                      product.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text('RP${product.price}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

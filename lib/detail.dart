// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/bloc/product_bloc.dart';
import 'bloc/product_models.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailProduk extends StatefulWidget {
  final Product product;

  const DetailProduk({Key? key, required this.product}) : super(key: key);

  @override
  State<DetailProduk> createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    final ProductBloc productBloc = BlocProvider.of<ProductBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Produk", style: GoogleFonts.actor(fontSize: 20)),
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullImagePage(imageUrl: widget.product.image!),
                  ),
                );
              },
              child: Hero(
                tag: widget.product.image!,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.network(
                    widget.product.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.name!,
                        style: GoogleFonts.actor(
                            fontSize: 24,
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isLiked = !_isLiked;
                          });
                        },
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Rp${widget.product.price}",
                      style: GoogleFonts.averageSans(
                          fontSize: 24,
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Deskripsi Produk",
                    style: GoogleFonts.actor(
                        fontSize: 18,
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.product.description!,
                    style: GoogleFonts.averageSans(
                        fontSize: 16,
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, '/home', (Route<dynamic> route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berhasil di Beli'),
            ),
          );
        },
        label: const Text('Beli'),
        icon: const Icon(Icons.shopping_cart),
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
      ),
    );
  }
}

class FullImagePage extends StatelessWidget {
  final String imageUrl;

  const FullImagePage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: Image.network(
            imageUrl,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}

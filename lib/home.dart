import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/bloc/mode.dart';
import 'package:online_shop/bloc/product_bloc.dart';
import 'package:online_shop/bloc/product_models.dart';
import 'package:online_shop/detail.dart';
import 'package:online_shop/new_product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_shop/searchpage.dart';
import 'package:online_shop/update.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _switchValue = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts());
  }

  Future<void> _refreshProducts() async {
    context.read<ProductBloc>().add(FetchProducts());
  }

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed) {
      context.read<ProductBloc>().add(DeleteProduct(product));
    }
  }

  void _navigateToSearchPage() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchPage(),
      ),
    );

    // Handle the result from SearchPage if needed
  }

  @override
  Widget build(BuildContext context) {
    ThemeBloc mytheme = context.read<ThemeBloc>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
        title: Text(
          "Online Shop",
          style: GoogleFonts.actor(fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _navigateToSearchPage,
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 1, 47, 163),
              ),
              child: Text(
                'Menu',
                style: GoogleFonts.actor(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: Text(
                "Ganti Tema",
                style: GoogleFonts.actor(fontSize: 20),
              ),
              trailing: Switch(
                value: _switchValue,
                onChanged: (value) {
                  mytheme.changeTheme();
                  setState(() {
                    _switchValue = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProductLoaded) {
              final products = state.products;
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final descriptionWords = product.description?.split(' ');
                  final displayedDescription =
                      descriptionWords?.take(5).join(' ');
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return DetailProduk(product: product);
                        },
                      ));
                    },
                    child: Card(
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 120,
                                child: Center(
                                  child: Image.network(
                                    product.image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name!,
                                      style: GoogleFonts.actor(
                                        fontSize: 16,
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      displayedDescription!,
                                      style: GoogleFonts.averageSans(
                                        fontSize: 16,
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 65),
                                    Text(
                                      'RP${product.price}',
                                      style: GoogleFonts.averageSans(
                                        fontSize: 18,
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: PopupMenuButton<String>(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'detail',
                                  child: Text('Detail'),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Ubah'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Hapus'),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'detail') {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return DetailProduk(product: product);
                                    },
                                  ));
                                } else if (value == 'edit') {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return UpdateProductPage(
                                          product: product);
                                    },
                                  ));
                                } else if (value == 'delete') {
                                  _deleteProduct(product);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ProductError) {
              return const Center(
                child: Text('Failed to fetch products'),
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return const CreateProductPage();
            },
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

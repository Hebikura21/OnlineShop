// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/bloc/category_bloc.dart';
import 'package:online_shop/new_category.dart';
import 'package:online_shop/update_category.dart';
import 'bloc/category_models.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryBloc>(context).add(FetchCategories());
  }

  Future<void> _refreshCategories() async {
    BlocProvider.of<CategoryBloc>(context).add(FetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
        title: Text(
          "Category",
          style: GoogleFonts.actor(fontSize: 20),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCategories,
        child: BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryDeleted) {
              Future.delayed(const Duration(milliseconds: 500), () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Category deleted successfully'),
                  ),
                );
              });
            } else if (state is CategoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CategoryLoaded) {
              return ListView.separated(
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // Aksi saat kategori diklik
                          // Misalnya, pindah ke halaman detail kategori
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailPage(
                                category: category,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(category.name),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return UpdateCategoryPage(
                                          category: category);
                                    },
                                  ));
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  BlocProvider.of<CategoryBloc>(context)
                                      .add(DeleteCategory(category.id));
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[400],
                        height: 1,
                        thickness: 1,
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox();
                },
              );
            } else if (state is CategoryError) {
              return const Center(
                child: Text('Error: Kasihan Developernya'),
              );
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addbutton',
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return const NewCategoryPage();
            },
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CategoryDetailPage extends StatelessWidget {
  final Category category;

  const CategoryDetailPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
        title: const Text('Category Detail'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('ID'),
            subtitle: Text(category.id.toString()),
          ),
          const Divider(),
          ListTile(
            title: const Text('Name'),
            subtitle: Text(category.name),
          ),
          const Divider(),
          ListTile(
            title: const Text('Status'),
            subtitle: Text(category.status),
          ),
          const Divider(),
          ListTile(
            title: const Text('Created At'),
            subtitle: Text(category.createAt.toString()),
          ),
          const Divider(),
          ListTile(
            title: const Text('Updated At'),
            subtitle: Text(category.updateAt.toString()),
          ),
        ],
      ),
    );
  }
}

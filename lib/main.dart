import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/bloc/category_bloc.dart';
import 'package:online_shop/bloc/product_bloc.dart';
import 'package:online_shop/bloc/mode.dart';
import 'package:online_shop/navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeBloc themeBloc = ThemeBloc();
  final CategoryBloc categoryBloc = CategoryBloc();
  final ProductBloc productBloc =
      ProductBloc(); // Tambahkan ProductRepository di sini

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>.value(value: themeBloc),
        BlocProvider<CategoryBloc>.value(
            value: categoryBloc..add(FetchCategories())),
        BlocProvider<ProductBloc>(
          create: (context) => productBloc
            ..add(
                FetchProducts()), // Gunakan create untuk menginisialisasi ProductBloc
        ),
      ],
      child: BlocBuilder<ThemeBloc, bool>(
        bloc: themeBloc,
        builder: (context, state) {
          return MaterialApp(
            theme: state ? ThemeData.light() : ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            home: const NavBar(),
          );
        },
      ),
    );
  }
}

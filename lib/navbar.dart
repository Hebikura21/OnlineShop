import 'package:flutter/material.dart';
import 'package:online_shop/home.dart';
import 'package:online_shop/kategori.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const  CategoryPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_headline),
            label: 'Kategori',
          ),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
      ),
    );
  }
}

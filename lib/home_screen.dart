import 'package:crates/transactions_page.dart';
import 'package:flutter/material.dart';
import 'main_page.dart';
import 'products_page.dart';
import 'suppliers_page.dart';
import 'warehouses_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic>? currentUser; 

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return MainPage(
          onLoginChanged: (user) {
            setState(() {
              currentUser = user;
              if (currentUser == null) {
                _selectedIndex = 0; 
              }
            });
          },
        );
      case 1:
        return ProductsPage(); 
      case 2:
        return SuppliersPage(currentUser: currentUser); 
      case 3:
        return WarehousesPage(currentUser: currentUser); 
      case 4:
        return TransactionsPage(); 
      default:
        return Center(child: Text('Ошибка выбора'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crate App')),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: const Color.fromARGB(255, 94, 61, 19)),
              child: Text('Меню', style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Главная'),
              selected: _selectedIndex == 0,
              onTap: () => setState(() {
                _selectedIndex = 0;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Товары'),
              selected: _selectedIndex == 1,
              enabled: currentUser != null,
              onTap: () => setState(() {
                _selectedIndex = 1;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Поставщики'),
              selected: _selectedIndex == 2,
              enabled: currentUser != null,
              onTap: () => setState(() {
                _selectedIndex = 2;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Склады'),
              selected: _selectedIndex == 3,
              enabled: currentUser != null,
              onTap: () => setState(() {
                _selectedIndex = 3;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('История'),
              enabled: currentUser != null,
              selected: _selectedIndex == 4,
              onTap: () => setState(() {
                _selectedIndex = 4;
                Navigator.pop(context);
              }),
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }
}

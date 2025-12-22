import 'package:flutter/material.dart';
import 'main_page.dart';
import 'products_page.dart';
import 'suppliers_page.dart';
import 'warehouses_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return MainPage();
      case 1:
        return ProductsPage();
      case 2:
        return SuppliersPage();
      case 3:
        return WarehousesPage();
      default:
        return Center(child: Text('Ошибка выбора'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Warehouse App')),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Меню', style: TextStyle(fontSize: 24, color: Colors.white)),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Главное'),
              selected: _selectedIndex == 0,
              onTap: () => setState(() { _selectedIndex = 0; Navigator.pop(context); }),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Товары'),
              selected: _selectedIndex == 1,
              onTap: () => setState(() { _selectedIndex = 1; Navigator.pop(context); }),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Поставщики'),
              selected: _selectedIndex == 2,
              onTap: () => setState(() { _selectedIndex = 2; Navigator.pop(context); }),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Склады'),
              selected: _selectedIndex == 3,
              onTap: () => setState(() { _selectedIndex = 3; Navigator.pop(context); }),
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }
}

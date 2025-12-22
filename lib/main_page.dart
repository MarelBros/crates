import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  final String serverInfo = "Не подключено";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text('Статус подключения:', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text(serverInfo, style: TextStyle(fontSize: 16, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

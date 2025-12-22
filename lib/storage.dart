import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Экран 2"),
      ),
      body: Center(
        child: Text("Вы открыли экран 2"),
      ),
    );
  }
}
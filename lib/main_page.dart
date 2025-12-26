import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class MainPage extends StatefulWidget {
  final Function(Map<String, dynamic>?) onLoginChanged;

  const MainPage({required this.onLoginChanged, super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final nameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String status = "Не подключено";
  bool loading = false;
  bool connected = false;

  @override
  void initState() {
    super.initState();
    loadSavedUser();
  }

  Future<void> loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    final tier = prefs.getInt('tier');

    if (name != null && tier != null) {
      setState(() {
        connected = true;
        status = 'Подключен: $name (${tier == 1 ? 'Админ' : 'Пользователь'})';
      });
      widget.onLoginChanged({'name': name, 'tier': tier});
    }
  }

  void connect() async {
    final name = nameCtrl.text.trim();
    final password = passwordCtrl.text;

    if (name.isEmpty || password.isEmpty) return;

    setState(() => loading = true);

    final user = await AuthService.login(name, password);

    setState(() => loading = false);

    if (user != null) {
      final tier = user['tier'] == 1 ? 'Админ' : 'Пользователь';

      setState(() {
        connected = true;
        status = 'Подключен: ${user['name']} ($tier)';
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', user['name']);
      await prefs.setInt('tier', user['tier']);

      nameCtrl.clear();
      passwordCtrl.clear();

      widget.onLoginChanged(user);
    } else {
      setState(() {
        connected = false;
        status = 'Ошибка подключения: неверный логин или пароль';
      });
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('tier');

    setState(() {
      connected = false;
      status = 'Не подключено';
    });

    widget.onLoginChanged(null);
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: true,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Логин'),
                  enabled: !connected,
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: passwordCtrl,
                  decoration: const InputDecoration(labelText: 'Пароль'),
                  obscureText: true,
                  enabled: !connected,
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: loading
                      ? null
                      : connected
                          ? logout
                          : connect,
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(connected ? 'Выйти' : 'Подключиться'),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Статус подключения:',
                  style: TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 10),

                Text(
                  status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: connected ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}

import 'package:flutter/material.dart';
import 'screens/todos_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color myAppDefaultBackround = Color(0xFF3D84A7);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: myAppDefaultBackround,
          brightness: Brightness.light,
        ),
        // scaffoldBackgroundColor: myAppDefaultBackround, // ✅ all Scaffold backgrounds
        appBarTheme: const AppBarTheme(
          // backgroundColor: myAppDefaultBackround, // ✅ all AppBars
          // foregroundColor: Colors.white, // text/icons on appbar
          elevation: 80,
        ),
        useMaterial3: true,
      ),
      home: const TodoScreen(),
    );
  }
}

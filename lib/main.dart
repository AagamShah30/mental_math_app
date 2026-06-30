import 'package:flutter/material.dart';
import 'package:mental_math_app/course_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Math',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xfff8f9fa),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff00d2ff),
          brightness: Brightness.light,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff121824),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff00d2ff),
          brightness: Brightness.dark,
        ),
      ),

      themeMode: _themeMode,

      home: MyHomePage(
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {

  final VoidCallback onThemeToggle;

  const MyHomePage({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Minds Pro'),
        actions: [
       
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: onThemeToggle, 
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: CourseList()),
          ],
        ),
      ),
    );
  }
}
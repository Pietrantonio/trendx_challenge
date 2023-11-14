import 'package:flutter/material.dart';
import 'package:trendx_challenge/colors.dart';
import 'package:trendx_challenge/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trendx',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colours.backgroundColor,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

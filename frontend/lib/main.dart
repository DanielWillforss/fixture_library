import 'package:app_core_widget/theme.dart';
import 'package:flutter/material.dart';
import 'package:lights_app/pages/fixtures_page.dart';

void main() {
  runApp(const MyApp());
}

class GlobalConstants {
  //static const String baseUrl = 'https://danielwillforss.site/fixture_library';
  //static const String baseUrl = 'http://192.168.0.130/fixture_library';
  static const String baseUrl = 'http://localhost:8080';
  static const String version = '1.1.0';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fixtures',
      theme: RedTheme.appTheme,
      color: const Color(0xFF121212),
      home: FixturesPage(),
    );
  }
}

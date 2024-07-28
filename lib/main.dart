import 'package:cineconnect/bottom_navigation_scaffold.dart';
import 'package:cineconnect/custom_error_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineConnect',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      builder: (context, widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return CustomErrorScreenInFlutter(
            errorDetails: errorDetails.toString(),
          );
        };

        return widget!;
      },
      home: const BottomNavigationScaffold(),
    );
  }
}

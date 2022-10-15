import 'package:flutter/material.dart';
import 'package:windows_note/app_cubit.dart';
import 'package:windows_note/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppCubit.createDB();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
          primarySwatch: Colors.grey,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF15202B),
          ),
          scaffoldBackgroundColor: const Color(0xFF15202B)),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

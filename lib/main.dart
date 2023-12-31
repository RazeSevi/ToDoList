import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do',
      theme: ThemeData(
        brightness: setLightTheme(true),
        primarySwatch: Colors.grey,
        primaryColor: const Color.fromARGB(255, 37, 157, 255),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

Brightness setLightTheme(bool lightTheme){
  if(lightTheme){
    return Brightness.light;
  }
  return Brightness.dark;
}


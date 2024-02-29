import 'package:flutter/material.dart';
import 'package:pomodoro_app/pomodoro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro App',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 20, 199, 80)),
        useMaterial3: true,
      ),
      home: const TelaInicial(title: 'Hora de Focar'),
    );
  }
}
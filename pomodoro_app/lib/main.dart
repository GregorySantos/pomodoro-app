import 'package:flutter/material.dart';
import 'package:pomodoro_app/pomodoro.dart';

/*
Pomodoro App v.1.0
Autor:Gregory Silva Gley Santos
Sobre o aplicativo:
  # Apresenta na tela inicial um contador regressivo que alterna entre ciclos de foco e descanso;
  # Emite um alerta sonoro ao fim de cada ciclo;
  # É possível iniciar, pausar e resetar o contador através de botões na tela inicial;
  # Os tempos de cada ciclo podem ser ajustados individualmente na tela de configurações;
  # Mantém na tela inicial um registro de quantas sessões de foco já foram completadas;
  # As configurações e o registro de sessões completadas são persistentes (usando SharedPreferences).
*/

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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 20, 199, 80)),
        useMaterial3: true,
      ),
      home: const TelaInicial(title: 'Hora de Focar'),
    );
  }
}

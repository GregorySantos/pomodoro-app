import 'package:flutter/material.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Sobre Mim'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Versão do Aplicativo: 1.0",
              style: TextStyle(fontSize: 25),
            ),
            Text("Autor: Gregory Silva Gley Santos"),
            Text("email: gregory.sgsantos@gmail.com"),
            SizedBox(
              height: 100,
            ),
            Text(
                "Melhorias a serem feitas:\n Colocar um alerta sonoro quando o timer zerar,\n difícil para versão web.")
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TelaConfig extends StatefulWidget {
  final int tempoSessao;
  final int tempoDescanso;
  final Function(int, int) onSave;

  const TelaConfig({
    super.key,
    required this.tempoSessao,
    required this.tempoDescanso,
    required this.onSave,
  });

  @override
  _TelaConfigState createState() => _TelaConfigState();
}

class _TelaConfigState extends State<TelaConfig> {
  late int _tempoSessao;
  late int _tempoDescanso;

  @override
  void initState() {
    super.initState();
    _tempoSessao = widget.tempoSessao;
    _tempoDescanso = widget.tempoDescanso;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              child: Text("Tempo da sessão de foco",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Slider(
              value: _tempoSessao.toDouble(),
              min: 1,
              max: 60,
              onChanged: (value) {
                setState(() {
                  _tempoSessao = value.toInt();
                });
              },
              label: 'Duração da Sessão: $_tempoSessao minutos',
              divisions: 59,
            ),
            const SizedBox(
              height: 40,
            ),
            const SizedBox(
              child: Text("Tempo de descanso",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Slider(
              value: _tempoDescanso.toDouble(),
              min: 1,
              max: 60,
              onChanged: (value) {
                setState(() {
                  _tempoDescanso = value.toInt();
                });
              },
              label: 'Duração do Descanso: $_tempoDescanso minutos',
              divisions: 59,
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                widget.onSave(_tempoSessao, _tempoDescanso);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save_alt, size: 50),
              label: const Text(
                "Salvar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

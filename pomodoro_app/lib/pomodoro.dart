import 'package:flutter/material.dart';
import 'package:pomodoro_app/tela_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key, required this.title});

  final String title;

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial>
    with TickerProviderStateMixin {
  late AnimationController controller;
  bool isPlaying = false;
  int _counter = 0;
  bool counterJaIncrementado = false;
  bool isSessaoFoco = true;
  late int tempoSessao = 25;
  late int tempoDescanso = 5;
  final player = AudioPlayer();

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${(controller.duration!.inMinutes).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${(count.inMinutes).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  void _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = (prefs.getInt('counter') ?? 0);
    setState(() {
      _counter++;
      prefs.setInt('counter', _counter);
    });
  }

  _leContador() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0);
    });
  }

  Future<void> _carregarConfiguracoes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tempoSessao = prefs.getInt('sessionDuration') ?? 25;
      tempoDescanso = prefs.getInt('breakDuration') ?? 5;
    });
  }

  Future<void> _salvarConfiguracoes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sessionDuration', tempoSessao);
    await prefs.setInt('breakDuration', tempoDescanso);
    setState(() {});
  }

  void notify() {
    if ((countText == '00:00') && !counterJaIncrementado) {
      if (isSessaoFoco) {
        _incrementCounter();
      }
      player.setAsset('assets/assets_audio_ring.wav');
      player.play();
      counterJaIncrementado = true;
      isSessaoFoco = !isSessaoFoco;
      _restartTimer();
    } else if (countText != '00:00') {
      counterJaIncrementado = false;
    }
  }

  Widget _buildTimerLabel() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: isSessaoFoco
          ? Text(
              'Foco',
              style: TextStyle(
                color: Colors.green.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            )
          : Text(
              'Descanso',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
    );
  }

  void _restartTimer() {
    setState(() {
      if (isSessaoFoco) {
        controller.duration = Duration(minutes: tempoSessao);
      } else {
        controller.duration = Duration(minutes: tempoDescanso);
      }
      controller.reset();
    });
  }

  @override
  void initState() {
    _leContador();
    _carregarConfiguracoes().then((value) {
      _restartTimer();
    });
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: isSessaoFoco
            ? Duration(minutes: tempoSessao)
            : Duration(seconds: tempoDescanso));
    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                if (controller.isAnimating) {
                  controller.stop();
                  setState(() {
                    isPlaying = false;
                  });
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TelaConfig(
                              tempoSessao: tempoSessao,
                              tempoDescanso: tempoDescanso,
                              onSave:
                                  (int newTempoSessao, int newTempoDescanso) {
                                setState(() {
                                  tempoSessao = newTempoSessao;
                                  tempoDescanso = newTempoDescanso;
                                  _salvarConfiguracoes();
                                });
                                _restartTimer();
                              },
                            )));
              },
              icon: const Icon(
                Icons.settings,
                size: 30,
              ))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(alignment: Alignment.center, children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  color: isSessaoFoco
                      ? Colors.green.shade900
                      : Colors.blue.shade900,
                  backgroundColor: Colors.grey.shade400,
                  value: progress,
                  strokeWidth: 10,
                ),
              ),
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) => Text(countText,
                    style: const TextStyle(
                        fontSize: 60, fontWeight: FontWeight.bold)),
              ),
            ]),
            SizedBox(
              child: _buildTimerLabel(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      controller.reverse(
                          from: controller.value == 0 ? 1.0 : controller.value);
                      setState(() {
                        isPlaying = true;
                      });
                    },
                    icon: const Icon(
                      Icons.play_circle_outline,
                      size: 50,
                    )),
                IconButton(
                    onPressed: () {
                      if (controller.isAnimating) {
                        controller.stop();
                        setState(() {
                          isPlaying = false;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.pause_circle_outline,
                      size: 50,
                    )),
                IconButton(
                    onPressed: () {
                      controller.reset();
                      setState(() {
                        isPlaying = false;
                      });
                    },
                    icon: const Icon(
                      Icons.restore,
                      size: 50,
                    ))
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        spreadRadius: 3)
                  ]),
              child: Text(
                _counter == 1
                    ? 'Você já completou $_counter sessão de foco'
                    : 'Você já completou $_counter sessões de foco',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

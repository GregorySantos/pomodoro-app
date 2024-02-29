import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
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

  void notify() {
    if ((countText == '00:00') && !counterJaIncrementado) {
      _incrementCounter();
      counterJaIncrementado = true;
    } else if (countText != '00:00') {
      counterJaIncrementado = false;
    }
  }

  @override
  void initState() {
    _leContador();
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TelaConfig()));
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
              child: Text(
                "Foco",
                style: TextStyle(
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
              ),
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
                    icon: const Icon(Icons.play_arrow)),
                IconButton(
                    onPressed: () {
                      if (controller.isAnimating) {
                        controller.stop();
                        setState(() {
                          isPlaying = false;
                        });
                      }
                    },
                    icon: const Icon(Icons.pause)),
                IconButton(
                    onPressed: () {
                      controller.reset();
                      setState(() {
                        isPlaying = false;
                      });
                    },
                    icon: const Icon(Icons.restore))
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
                'Você completou $_counter sessões',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TelaConfig extends StatelessWidget {
  const TelaConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(15.0),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

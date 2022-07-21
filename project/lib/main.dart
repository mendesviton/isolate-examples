import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController rotationController;
  late Animation<double> animation;
  List<int> results = [];

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..addListener(() => setState(() {}));
    animation = Tween(begin: 0.0, end: 1.0).animate(rotationController);
    rotationController.forward(from: 0.0);
    //loop the animation for clarity
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        rotationController.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text("Demonstração Isolates"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          Center(
            child: RotationTransition(
              turns: animation,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.orange,
                ),
                width: 200,
                height: 200,
              ),
            ),
          ),
          const SizedBox(height: 100),
          MaterialButton(
            color: Colors.pink,
            onPressed: () {
              final result = calcFibonacci(40);
              setState(() {
                results.add(result);
              });
            },
            child: const Text("fib(40) no ISOLATE PRINCIPAL"),
          ),
          MaterialButton(
            color: Colors.purple,
            onPressed: () async {
              final result = await compute(calcFibonacci, 42);
              setState(() {
                results.add(result);
              });
            },
            child: const Text("fib(40) em um NOVO ISOLATE"),
          ),
          Text("Number of results: ${results.length.toString()}")
        ],
      ),
    );
  }
}

int calcFibonacci(int n) {
  // calculo matematico
  if (n < 2) {
    return n;
  }
  return calcFibonacci(n - 2) + calcFibonacci(n - 1);
}

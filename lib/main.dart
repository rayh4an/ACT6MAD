import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(ChangeNotifierProvider(
    create: (context) => Counter(),
    child: const MyApp(),
  ));
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Age Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    if (value < 99) {
      value += 1;
      notifyListeners();
    }
  }

  void decrement() {
    if (value > 0) {
      value -= 1;
      notifyListeners();
    }
  }

  void updateValue(double newValue) {
    value = newValue.toInt();
    notifyListeners();
  }

  Color get backgroundColor {
    if (value <= 12) return Colors.lightBlue;
    if (value <= 19) return Colors.lightGreen;
    if (value <= 30) return Colors.yellow.shade200;
    if (value <= 50) return Colors.orange;
    return Colors.grey.shade300;
  }

  String get message {
    if (value <= 12) return "You're a child!";
    if (value <= 19) return "Teenager time!";
    if (value <= 30) return "You're a young adult!";
    if (value <= 50) return "You're an adult now!";
    return "Golden years!";
  }

  Color get sliderColor {
    if (value <= 33) return Colors.green;
    if (value <= 67) return Colors.yellow;
    return Colors.red;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var counter = context.watch<Counter>();

    return Scaffold(
      backgroundColor: counter.backgroundColor,
      appBar: AppBar(
        title: const Text('Age Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Your age is:'),
            Text(
              '${counter.value}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              counter.message,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Slider(
              value: counter.value.toDouble(),
              min: 0,
              max: 99,
              divisions: 99,
              activeColor: counter.sliderColor,
              label: counter.value.toString(),
              onChanged: (value) => counter.updateValue(value),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  onPressed: () => counter.decrement(),
                  label: const Text('Decrease Age'),
                  tooltip: 'Decrease Age',
                ),
                const SizedBox(width: 20),
                FloatingActionButton.extended(
                  onPressed: () => counter.increment(),
                  label: const Text('Increase Age'),
                  tooltip: 'Increase Age',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

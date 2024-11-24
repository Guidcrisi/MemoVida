import 'package:flutter/material.dart';
import 'package:memovida/interface/SplashPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  static Color primary = const Color(0xFF4A90E2);
  static Color secondary = const Color(0xFFD0021B);
  static Color textColor = Colors.black;
  static Color backgroundColor = Colors.white;
  static double fontSize = 18.0;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "MemoVida",
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}

import 'dart:async';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memovida/interface/HomePage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Timer(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(color: Colors.white),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
                child: Entry.all(
              duration: const Duration(seconds: 2),
              child: SizedBox(
                width: 250,
                child: Image.asset("assets/img/logo.png"),
              ),
            ))));
  }
}

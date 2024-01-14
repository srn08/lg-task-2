import 'package:flutter/material.dart';
import 'package:lg_kiss_app/pages/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MyHomePage(title: 'LG KISS App')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Image.asset('assets/images/splash.png'));
  }
}

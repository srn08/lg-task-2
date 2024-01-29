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
              builder: (context) => const MyHomePage(
                  title: 'LG KISS App - Liquid Galaxy Control Tool')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('assets/images/splash.png'),
          const Text(
            "Liquid Galaxy Pre-Selection Task for GSoC 2024",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          const Text(
            "Developed by: Shaunak Nagrecha",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          const Text(
            "REPO GOES HERE",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ],
      )),
    );
  }
}

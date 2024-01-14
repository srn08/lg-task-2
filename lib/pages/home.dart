import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:lg_kiss_app/connections/ssh.dart';
import 'package:lg_kiss_app/constants/theme.dart';
import 'package:lg_kiss_app/pages/settings.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lg_kiss_app/providers/connection_providers.dart';
import 'package:lg_kiss_app/components/connection_flag.dart';

enum Planet {
  isEarth,
  isMoon,
  isMars,
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage>
    with TickerProviderStateMixin {
  Planet planet = Planet.isEarth;
  late AnimationController _earthController;
  late AnimationController _moonController;
  late AnimationController _marsController;

  @override
  void initState() {
    super.initState();
    _earthController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _moonController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _marsController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _earthController.stop();
    _moonController.stop();
    _marsController.stop();
    // _connectToLG();
  }

  Future<void> _execute() async {
    SSHSession? session = await SSH(ref: ref).execute();
    if (session != null) {
      print(session.stdout);
    }
  }

  Future<void> _planetMoon() async {
    SSHSession? session = await SSH(ref: ref).planetMoon();
    if (session != null) {
      print(session.stdout);
    }
    setState(() {
      planet = Planet.isMoon;
    });
  }

  Future<void> _planetMars() async {
    SSHSession? session = await SSH(ref: ref).planetMars();
    if (session != null) {
      print(session.stdout);
    }
    setState(() {
      planet = Planet.isMars;
    });
  }

  Future<void> _planetEarth() async {
    SSHSession? session = await SSH(ref: ref).planetEarth();
    if (session != null) {
      print(session.stdout);
    }
    setState(() {
      planet = Planet.isEarth;
    });
  }

  @override
  void dispose() {
    _earthController.dispose();
    _moonController.dispose();
    _marsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool connected = ref.watch(connectedProvider);
    return Scaffold(
      backgroundColor: ThemesDark().normalColor,
      appBar: AppBar(
        backgroundColor: ThemesDark().tabBarColor,
        title: Text(
          widget.title,
          style: TextStyle(color: ThemesDark().oppositeColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Settings(),
                ));
          },
          color: ThemesDark().oppositeColor,
        ),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ConnectionFlag(status: connected),
            Container(
              height: 400,
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: Lottie.asset('assets/animations/earth.json',
                        controller: _earthController),
                    onTap: () {
                      _earthController.repeat();
                      _moonController.stop();
                      _marsController.stop();
                      _planetEarth();
                    },
                  ),
                  GestureDetector(
                    child: Lottie.asset('assets/animations/moon.json',
                        controller: _moonController),
                    onTap: () {
                      _earthController.stop();
                      _moonController.repeat();
                      _marsController.stop();
                      _planetMoon();
                    },
                  ),
                  GestureDetector(
                    child: Lottie.asset('assets/animations/mars.json',
                        controller: _marsController),
                    onTap: () {
                      _earthController.stop();
                      _moonController.stop();
                      _marsController.repeat();
                      _planetMars();
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 150,
                    width: 200,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ThemesDark().tabBarColor),
                            foregroundColor: MaterialStateProperty.all(
                                ThemesDark().oppositeColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(40.0)))),
                        onPressed: () {},
                        child: const Text("Navigate To Lleida")),
                  ),
                  Container(
                    height: 150,
                    width: 200,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ThemesDark().tabBarColor),
                            foregroundColor: MaterialStateProperty.all(
                                ThemesDark().oppositeColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(40.0)))),
                        onPressed: () {},
                        child: const Text("Shutdown LG")),
                  ),
                  Container(
                    height: 150,
                    width: 200,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ThemesDark().tabBarColor),
                            foregroundColor: MaterialStateProperty.all(
                                ThemesDark().oppositeColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(40.0)))),
                        onPressed: () {},
                        child: const Text("Reboot LG")),
                  ),
                  Container(
                    height: 150,
                    width: 200,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ThemesDark().tabBarColor),
                            foregroundColor: MaterialStateProperty.all(
                                ThemesDark().oppositeColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(40.0)))),
                        onPressed: () {},
                        child: const Text("Disconnect from LG")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

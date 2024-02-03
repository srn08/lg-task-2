// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:lg_kiss_app/connections/ssh.dart';
import 'package:lg_kiss_app/constants/constants.dart';
import 'package:lg_kiss_app/pages/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lg_kiss_app/providers/connection_providers.dart';
import 'package:lg_kiss_app/components/connection_flag.dart';
import 'package:lg_kiss_app/constants/kml_makers.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  orbitPlay() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    for (int i = 0; i <= 360; i += 10) {
      // ignore: use_build_context_synchronously
      SSH(ref: ref)
          .flyToOrbit(context, 19.076090, 72.877426, 1000, 60, i.toDouble());
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  Future<void> _navigateToMumbai() async {
    SSHSession? session = await SSH(ref: ref).search("Mumbai");
    if (session != null) {
      print(session.stdout);
    }
  }

  Future<void> _relaunchLG() async {
    SSHSession? session = await SSH(ref: ref).relaunchLG(context);
    if (session != null) {
      print(session.stdout);
    }
  }

  Widget menuButton(String text, Function onPressed) {
    return Container(
      height: 150,
      width: 200,
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFF1E2026)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)))),
          onPressed: () {
            onPressed();
          },
          child: Text(
            text,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          )),
    );
  }

  showAlertDialog(BuildContext context, int ind) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
        if (ind == 1) {
          _relaunchLG();
        } else if (ind == 2) {
          ref.read(connectedProvider.notifier).state = false;
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Are you sure you want to reboot LG?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool connected = ref.watch(connectedProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF15151A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2026),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
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
          color: Colors.white,
        ),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ConnectionFlag(status: connected),
            SizedBox(
              height: 400,
              child: Image.asset('assets/images/splash.png'),
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menuButton("Reboot LG", () {
                    showAlertDialog(context, 1);
                  }),
                  menuButton("Navigate To Mumbai", _navigateToMumbai),
                  menuButton("Orbit on Mumbai", orbitPlay),
                  Container(
                    height: 150,
                    width: 200,
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF1E2026)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(40.0)))),
                        onPressed: () async {
                          print("Triggered");
                          await SSH(ref: ref).renderInSlave(
                              context,
                              ref.read(rightmostRigProvider),
                              KMLStrings.screenOverlayImage(Constants.customImg,
                                  Constants.splashAspectRatio));
                        },
                        child: const Text(
                          "Show HTML Bubble on the right screen",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

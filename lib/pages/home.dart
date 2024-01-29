import 'package:flutter/material.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:lg_kiss_app/connections/ssh.dart';
import 'package:lg_kiss_app/constants/constants.dart';
import 'package:lg_kiss_app/constants/theme.dart';
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

  bool orbitPlaying = false;

  // Future<void> _execute() async {
  //   SSHSession? session = await SSH(ref: ref).execute();
  //   if (session != null) {
  //     print(session.stdout);
  //   }
  // }
  orbitPlay() async {
    setState(() {
      orbitPlaying = true;
    });
    // SSH(ref: ref).flyTo(context, newMapPosition.target.latitude,
    //     newMapPosition.target.longitude, Const.appZoomScale.zoomLG, 0, 0);
    await Future.delayed(const Duration(milliseconds: 1000));
    for (int i = 0; i <= 360; i += 10) {
      if (!mounted) {
        return;
      }
      if (!orbitPlaying) {
        break;
      }
      SSH(ref: ref)
          .flyToOrbit(context, 19.076090, 72.877426, 1000, 60, i.toDouble());
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    if (!mounted) {
      return;
    }
    // SSH(ref: ref).flyTo(context, newMapPosition.target.latitude,
    //     newMapPosition.target.longitude, Const.appZoomScale.zoomLG, 0, 0);
    setState(() {
      orbitPlaying = false;
    });
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
                  MaterialStateProperty.all(ThemesDark().tabBarColor),
              foregroundColor:
                  MaterialStateProperty.all(ThemesDark().oppositeColor),
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
      content: Text((ind == 1)
          ? "Are you sure you want to relaunch LG?"
          : "Are you sure you want to disconnect from LG?"),
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
            Container(child: ConnectionFlag(status: connected)),
            Container(
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
                                ThemesDark().tabBarColor),
                            foregroundColor: MaterialStateProperty.all(
                                ThemesDark().oppositeColor),
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
                              KMLMakers.screenOverlayImage(Constants.customImg,
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

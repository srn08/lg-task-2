import 'package:flutter/material.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:lg_kiss_app/connections/ssh.dart';
import 'package:lg_kiss_app/constants/theme.dart';
import 'package:lg_kiss_app/pages/settings.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lg_kiss_app/providers/connection_providers.dart';
import 'package:lg_kiss_app/components/connection_flag.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
  late TextEditingController _searchController;

  late TutorialCoachMark tutorialCoachMark;
  GlobalKey settingsKey = GlobalKey();
  GlobalKey connectedKey = GlobalKey();
  GlobalKey navigateToLleidaKey = GlobalKey();

  @override
  void initState() {
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
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
    _searchController = TextEditingController(text: '');
    _earthController.stop();
    _moonController.stop();
    _marsController.stop();
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.white,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "settingsKey",
        keyTarget: settingsKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Settings",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 30.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Liquid Galaxy Connection Manager",
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "connectedKey",
        keyTarget: connectedKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Connection Status",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 30.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "This shows the connection status of the Liquid Galaxy.",
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "navigateToLleidaKey",
        keyTarget: navigateToLleidaKey,
        contents: [
          TargetContent(
            align: ContentAlign.right,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Navigate to Lleida",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 30.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "This button will navigate the Liquid Galaxy to Lleida.",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    return targets;
  }

  Future<void> _execute() async {
    SSHSession? session = await SSH(ref: ref).execute();
    if (session != null) {
      print(session.stdout);
    }
  }

  Future<void> _navigateToMumbai() async {
    SSHSession? session = await SSH(ref: ref).search("Mumbai");
    if (session != null) {
      print(session.stdout);
    }
  }

  Future<void> _relaunchLG() async {
    SSHSession? session = await SSH(ref: ref).relunchLG();
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

  Widget menuButton(String text, Function onPressed) {
    return Container(
      height: 150,
      width: 200,
      padding: EdgeInsets.all(10),
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
            style: TextStyle(fontSize: 20),
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
    _earthController.dispose();
    _moonController.dispose();
    _marsController.dispose();
    _searchController.dispose();
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
          key: settingsKey,
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
            Container(
                key: connectedKey, child: ConnectionFlag(status: connected)),
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
              height: 200,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    key: navigateToLleidaKey,
                    child: menuButton("Navigate To Lleida", _execute),
                  ),
                  menuButton("Navigate To Mumbai", _navigateToMumbai),
                  menuButton("Relaunch LG", () {
                    showAlertDialog(context, 1);
                  }),
                  menuButton("Disconnect from LG", () {
                    showAlertDialog(context, 2);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

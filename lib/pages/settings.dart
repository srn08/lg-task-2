import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lg_kiss_app/providers/connection_providers.dart';
import 'package:lg_kiss_app/connections/ssh.dart';
import 'package:lg_kiss_app/components/connection_flag.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  TextEditingController ipController = TextEditingController(text: '');
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController portController = TextEditingController(text: '');
  TextEditingController rigsController = TextEditingController(text: '');
  late SSH ssh;

  initTextControllers() {
    ipController.text = ref.read(ipProvider);
    usernameController.text = ref.read(usernameProvider);
    passwordController.text = ref.read(passwordProvider);
    portController.text = ref.read(portProvider).toString();
    rigsController.text = ref.read(rigsProvider).toString();
  }

  updateProviders() {
    ref.read(ipProvider.notifier).state = ipController.text;
    ref.read(usernameProvider.notifier).state = usernameController.text;
    ref.read(passwordProvider.notifier).state = passwordController.text;
    ref.read(portProvider.notifier).state = int.parse(portController.text);
    ref.read(rigsProvider.notifier).state = int.parse(rigsController.text);
  }

  Future<void> _connectToLG() async {
    bool? result = await ssh.connectToLG(context);
    ref.read(connectedProvider.notifier).state = result!;
  }

  @override
  void initState() {
    super.initState();
    initTextControllers();
    ssh = SSH(ref: ref);
  }

  Widget customInput(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    ipController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    portController.dispose();
    rigsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isConnectedToLg = ref.watch(connectedProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF15151A),
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              ConnectionFlag(status: isConnectedToLg),
              customInput(ipController, "IP Address"),
              customInput(usernameController, "Username"),
              customInput(passwordController, "Password"),
              customInput(portController, "Port"),
              customInput(rigsController, "Rigs"),
              ElevatedButton(
                onPressed: () {
                  updateProviders();
                  if (!isConnectedToLg) _connectToLG();
                },
                child: const Text('Connect to LG'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

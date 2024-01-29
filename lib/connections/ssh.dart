import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lg_kiss_app/providers/connection_providers.dart';
import 'package:lg_kiss_app/constants/kml_makers.dart';

class SSH {
  final WidgetRef ref;

  SSH({required this.ref});

  SSHClient? _client;

  showSnackBar(
          {required BuildContext context,
          required String message,
          int duration = 3,
          Color color = Colors.green}) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontSize: 14, color: color),
          ),
          backgroundColor: Colors.black.withOpacity(0.9),
          duration: Duration(seconds: duration),
        ),
      );

  // function to connect to liquid galaxy rig
  Future<bool?> connectToLG(BuildContext context) async {
    try {
      final socket = await SSHSocket.connect(
          ref.read(ipProvider), ref.read(portProvider),
          timeout: const Duration(seconds: 5));
      ref.read(sshClientProvider.notifier).state = SSHClient(
        socket,
        username: ref.read(usernameProvider),
        onPasswordRequest: () => ref.read(passwordProvider),
      );
      ref.read(connectedProvider.notifier).state = true;
      return true;
    } catch (e) {
      ref.read(connectedProvider.notifier).state = false;
      print('Failed to connect: $e');
      showSnackBar(context: context, message: e.toString(), color: Colors.red);
      return false;
    }
  }

  flyToOrbit(context, double latitude, double longitude, double zoom,
      double tilt, double bearing) async {
    try {
      await ref.read(sshClientProvider)?.run(
          'echo "flytoview=${KMLMakers.orbitLookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
    } catch (error) {
      print(error);
    }
  }

  relaunchLG(context) async {
    try {
      for (var i = 1; i <= ref.read(rigsProvider); i++) {
        String cmd = """RELAUNCH_CMD="\\
          if [ -f /etc/init/lxdm.conf ]; then
            export SERVICE=lxdm
          elif [ -f /etc/init/lightdm.conf ]; then
            export SERVICE=lightdm
          else
            exit 1
          fi
          if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
            echo ${ref.read(passwordProvider)} | sudo -S service \\\${SERVICE} start
          else
            echo ${ref.read(passwordProvider)} | sudo -S service \\\${SERVICE} restart
          fi
          " && sshpass -p ${ref.read(passwordProvider)} ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";
        await ref.read(sshClientProvider)?.run(
            '"/home/${ref.read(usernameProvider)}/bin/lg-relaunch" > /home/${ref.read(usernameProvider)}/log.txt');
        await ref.read(sshClientProvider)?.run(cmd);
      }
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  Future<String> renderInSlave(context, int slaveNo, String kml) async {
    try {
      await ref
          .read(sshClientProvider)
          ?.run("echo '$kml' > /var/www/html/kml/slave_$slaveNo.kml");
      return kml;
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
      // return BalloonMakers.blankBalloon();
      return "";
    }
  }

  Future<SSHSession?> execute() async {
    try {
      _client = ref.read(sshClientProvider);
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final session =
          await _client!.execute('echo "search=Lleida" >/tmp/query.txt');
      return session;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> search(String place) async {
    try {
      _client = ref.read(sshClientProvider);
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final session =
          await _client!.execute('echo "search=$place" >/tmp/query.txt');
      return session;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }
}

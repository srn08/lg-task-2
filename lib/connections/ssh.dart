import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lg_kiss_app/providers/connection_providers.dart';

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
          timeout: Duration(seconds: 5));
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

  Future<SSHSession?> relunchLG() async {
    try {
      _client = ref.read(sshClientProvider);
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final session = await _client!.execute('lg-relaunch');
      return session;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> execute() async {
    try {
      _client = ref.read(sshClientProvider);
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      //   TODO 4: Execute a demo command: echo "search=Lleida" >/tmp/query.txt
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

  Future<SSHSession?> planetMoon() async {
    try {
      _client = ref.read(sshClientProvider);
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final session =
          await _client!.execute('echo "planet=moon" >/tmp/query.txt');
      return session;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> planetMars() async {
    try {
      _client = ref.read(sshClientProvider);
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final session = await ref
          .read(sshClientProvider)!
          .execute('echo "planet=mars" >/tmp/query.txt');
      return session;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> planetEarth() async {
    try {
      _client = ref.read(sshClientProvider);
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final session =
          await _client!.execute('echo "planet=earth" >/tmp/query.txt');
      return session;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartssh2/dartssh2.dart';

StateProvider<SSHClient?> sshClientProvider = StateProvider(
  (ref) => null,
);

StateProvider<String> ipProvider = StateProvider((ref) => '192.168.23.3');
StateProvider<String> usernameProvider = StateProvider((ref) => 'lg');
StateProvider<String> passwordProvider = StateProvider((ref) => 'lg1234');
StateProvider<int> portProvider = StateProvider((ref) => 22);
StateProvider<int> rigsProvider = StateProvider((ref) => 3);
StateProvider<bool> connectedProvider = StateProvider((ref) => false);

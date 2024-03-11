import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' as pc;

abstract class Argon2 {
  const Argon2();

  Uint8List argon2(Argon2Arguments args);

  Future<Uint8List> argon2Async(Argon2Arguments args);

  /*
  The format is defined in Argon2 C implementation
    echo -n "password" | ./argon2 somesalt -t 2 -m 16 -p 4 -l 24
    Type:           Argon2i
    Iterations:     2
    Memory:         65536 KiB
    Parallelism:    4
    Hash:           45d7ac72e76f242b20b77b9bf9bf9d5915894e669a24e6c6
    Encoded:        $argon2i$v=19$m=65536,t=2,p=4$c29tZXNhbHQ$RdescudvJCsgt3ub+b+dWRWJTmaaJObG
    0.188 seconds
    Verification ok
  */
  static String formatArgon2Hash(
    Argon2Arguments args,
    Uint8List derivedKey,
  ) {
    String argon2Type = '';
    switch (args.type) {
      case ARGON2_i:
        argon2Type = 'argon2i';
      case ARGON2_d:
        argon2Type = 'argon2d';
      case ARGON2_id:
        argon2Type = 'argon2id';
    }
    final String version = 'v=${args.version}';
    final String memory = 'm=${args.memory}';
    final String iterations = 't=${args.iterations}';
    final String parallelism = 'p=${args.parallelism}';
    final String saltString = base64.encode(args.salt).replaceAll('=', '');
    final String hashString = base64.encode(derivedKey).replaceAll('=', '');

    return '\$$argon2Type\$$version\$$memory,$iterations,$parallelism\$$saltString\$$hashString';
  }
}

const int ARGON2_i = pc.Argon2Parameters.ARGON2_i;
const int ARGON2_d = pc.Argon2Parameters.ARGON2_d;
const int ARGON2_id = pc.Argon2Parameters.ARGON2_id;

class Argon2Arguments {
  Argon2Arguments(this.key, this.salt, this.memory, this.iterations,
      this.length, this.parallelism, this.type, this.version);

  final Uint8List key;
  final Uint8List salt;
  final int memory;
  final int iterations;
  final int length;
  final int parallelism;
  final int type;
  final int version;

  @override
  String toString() {
    String argon2Type = '';
    switch (type) {
      case ARGON2_i:
        argon2Type = 'argon2i';
      case ARGON2_d:
        argon2Type = 'argon2d';
      case ARGON2_id:
        argon2Type = 'argon2id';
    }
    final String version = 'v=${this.version}';
    final String memory = 'm=${this.memory}';
    final String iterations = 't=${this.iterations}';
    final String parallelism = 'p=${this.parallelism}';
    final String saltString = base64.encode(salt).replaceAll('=', '');
    final String keyString = base64.encode(key).replaceAll('=', '');

    return '\$$argon2Type\$$version\$$memory,$iterations,$parallelism\$$saltString\$$keyString';
  }

  static String _addPadding(String encodedString) {
    final int paddingLength = 4 - (encodedString.length % 4);
    final String padding = '=' * paddingLength;
    return encodedString + padding;
  }

  static Argon2Arguments parse(String args) {
    final regex = RegExp(
        r'^\$argon2(i|d|id)\$v=(\d+)\$m=(\d+),t=(\d+),p=(\d+)\$([A-Za-z0-9+/=]+)\$([A-Za-z0-9+/=]+)$');

    final Match? match = regex.firstMatch(args);

    if (match == null) {
      throw const FormatException('Invalid argon2 hash string');
    }
    final String variant = match.group(1)!;
    final int version = int.parse(match.group(2)!);
    final int memory = int.parse(match.group(3)!);
    final int iterations = int.parse(match.group(4)!);
    final int parallelism = int.parse(match.group(5)!);
    final String salt = _addPadding(match.group(6)!);
    final String hash = _addPadding(match.group(7)!);

    final key = base64Decode(hash);
    int type;
    if (variant == 'i') {
      type = ARGON2_i;
    } else if (variant == 'd') {
      type = ARGON2_d;
    } else {
      type = ARGON2_id;
    }
    return Argon2Arguments(key, base64Decode(salt), memory, iterations,
        key.length, parallelism, type, version);
  }

  @override
  bool operator ==(dynamic other) =>
      other is Argon2Arguments && other.toString() == toString();

  @override
  int get hashCode => toString().hashCode;
}

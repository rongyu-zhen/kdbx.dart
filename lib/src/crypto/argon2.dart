import 'dart:typed_data';
import 'package:pointycastle/export.dart' as pc;

abstract class Argon2 {
  const Argon2();

  Uint8List argon2(Argon2Arguments args);

  Future<Uint8List> argon2Async(Argon2Arguments args);
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
}

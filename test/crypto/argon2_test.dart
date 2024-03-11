import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:kdbx/src/crypto/argon2.dart';
import 'package:kdbx/src/crypto/pointycastle_argon2.dart';
import 'package:test/test.dart';

void main() {
  test('should return argon2 derived key when use argon2d', () async {
    final salt = hex.decode(
            '3f09ea13ceffb8e867a4af3ab17854f9f5f152591653c737a8962b94356e2c0f')
        as Uint8List;
    final password = hex.decode(
            'bfa11b4e4376cf1b17088a3de375f1df6a9c4cb3eb36f3ce2416b10481eb619f')
        as Uint8List;
    //  argon2: seed=kef.seed, version=19, rounds=2, memory=1024, parallelism=2
    const argon2 = PointyCastleArgon2();
    final key = await argon2.argon2Async(
      Argon2Arguments(password, salt, 1024, 2, 32, 2, ARGON2_d, 19),
    );
    expect(
        key,
        equals(hex.decode(
            '104e9ba7b6b4479eec1a8fe3f9ca285fd10e0f33435fcabd8edf3e16380a98c7')));
  });

  test('should return argon2 derived key when use argon2i', () async {
    /*
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
    final salt = utf8.encode('somesalt');
    final password = utf8.encode('password');
    final args = Argon2Arguments(password, salt, 65536, 2, 24, 4, ARGON2_i, 19);
    const argon2 = PointyCastleArgon2();
    final key = await argon2.argon2Async(args);
    final hash = Argon2.formatArgon2Hash(args, key);
    expect(
        hash,
        equals(
            '\$argon2i\$v=19\$m=65536,t=2,p=4\$c29tZXNhbHQ\$RdescudvJCsgt3ub+b+dWRWJTmaaJObG'));
  });

  test('should return argon2key with parameters', () async {
    final salt = hex.decode(
            '3f09ea13ceffb8e867a4af3ab17854f9f5f152591653c737a8962b94356e2c0f')
        as Uint8List;
    final password = hex.decode(
            'bfa11b4e4376cf1b17088a3de375f1df6a9c4cb3eb36f3ce2416b10481eb619f')
        as Uint8List;
    final args = Argon2Arguments(password, salt, 1024, 2, 32, 2, ARGON2_d, 19);
    const argon2 = PointyCastleArgon2();
    final key = await argon2.argon2Async(args);
    final hash = Argon2.formatArgon2Hash(args, key);
    expect(
        hash,
        equals(
            '\$argon2d\$v=19\$m=1024,t=2,p=2\$PwnqE87/uOhnpK86sXhU+fXxUlkWU8c3qJYrlDVuLA8\$EE6bp7a0R57sGo/j+cooX9EODzNDX8q9jt8+FjgKmMc'));
  });

  test('should serializeto string', () async {
    final salt = hex.decode(
            '3f09ea13ceffb8e867a4af3ab17854f9f5f152591653c737a8962b94356e2c0f')
        as Uint8List;
    final password = hex.decode(
            'bfa11b4e4376cf1b17088a3de375f1df6a9c4cb3eb36f3ce2416b10481eb619f')
        as Uint8List;
    final args = Argon2Arguments(password, salt, 1024, 2, 32, 2, ARGON2_d, 19);
    final serialized = args.toString();
    expect(
        serialized,
        equals(
            '\$argon2d\$v=19\$m=1024,t=2,p=2\$PwnqE87/uOhnpK86sXhU+fXxUlkWU8c3qJYrlDVuLA8\$v6EbTkN2zxsXCIo943Xx32qcTLPrNvPOJBaxBIHrYZ8'));
  });

  test('should parse from string given valid', () async {
    final salt = hex.decode(
            '3f09ea13ceffb8e867a4af3ab17854f9f5f152591653c737a8962b94356e2c0f')
        as Uint8List;
    final password = hex.decode(
            'bfa11b4e4376cf1b17088a3de375f1df6a9c4cb3eb36f3ce2416b10481eb619f')
        as Uint8List;
    final args = Argon2Arguments(password, salt, 1024, 2, 32, 2, ARGON2_d, 19);
    final parsed = Argon2Arguments.parse(
        '\$argon2d\$v=19\$m=1024,t=2,p=2\$PwnqE87/uOhnpK86sXhU+fXxUlkWU8c3qJYrlDVuLA8\$v6EbTkN2zxsXCIo943Xx32qcTLPrNvPOJBaxBIHrYZ8');
    expect(parsed, equals(args));
  });
}

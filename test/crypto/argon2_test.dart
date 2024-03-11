import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:kdbx/src/crypto/argon2.dart';
import 'package:test/test.dart';

void main() {
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

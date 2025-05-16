import 'package:kdbx/src/kdbx_object.dart';
import 'package:kdbx/src/kdbx_xml.dart';
import 'package:quiver/iterables.dart';

class KdbxAutoType extends KdbxNode {
  KdbxAutoType.create() : super.create('AutoType') {
    dataTransferObfuscation.set(0);
  }
  KdbxAutoType.read(super.node) : super.read();

  BooleanNode get enabled => BooleanNode(this, 'Enabled');

  IntNode get dataTransferObfuscation =>
      IntNode(this, 'DataTransferObfuscation');

  StringNode get defaultSequence => StringNode(this, 'DefaultSequence');

  List<KdbxSubNode<dynamic>> get _nodes => [
        enabled,
        dataTransferObfuscation,
        defaultSequence,
      ];

  void overwriteFrom(KdbxAutoType other) {
    for (final pair in zip([_nodes, other._nodes])) {
      final me = pair[0];
      final other = pair[1];
      me.set(other.get());
    }
  }
}

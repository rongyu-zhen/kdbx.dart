import 'package:kdbx/src/internal/extension_utils.dart';
import 'package:kdbx/src/kdbx_object.dart';
import 'package:kdbx/src/kdbx_xml.dart';
import 'package:quiver/iterables.dart';

class KdbxAutoTypeNode extends KdbxNode {
  KdbxAutoTypeNode._create(this._parent) : super.create('AutoType') {
    dataTransferObfuscation.set(0);
  }
  KdbxAutoTypeNode._read(super.node, this._parent) : super.read();

  factory KdbxAutoTypeNode.create(KdbxNode parent) {
    return parent.node
            .singleElement(KdbxXml.NODE_AUTO_TYPE)
            ?.let((e) => KdbxAutoTypeNode._read(e, parent)) ??
        KdbxAutoTypeNode._create(parent);
  }

  final KdbxNode _parent;

  BooleanNode get enabled => BooleanNode(this, 'Enabled');

  IntNode get dataTransferObfuscation =>
      IntNode(this, 'DataTransferObfuscation');

  StringNode get defaultSequence => StringNode(this, 'DefaultSequence');

  @override
  RET modify<RET>(RET Function() modify) {
    return _parent.modify(modify);
  }

  List<KdbxSubNode<dynamic>> get _nodes => [
        enabled,
        dataTransferObfuscation,
        defaultSequence,
      ];

  void overwriteFrom(KdbxAutoTypeNode other) {
    for (final pair in zip([_nodes, other._nodes])) {
      final me = pair[0];
      final other = pair[1];
      me.set(other.get());
    }
  }
}

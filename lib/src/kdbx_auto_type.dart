import 'package:collection/collection.dart';
import 'package:kdbx/src/internal/extension_utils.dart';
import 'package:kdbx/src/kdbx_object.dart';
import 'package:kdbx/src/kdbx_xml.dart';
import 'package:xml/xml.dart';

class DefaultSequenceNode extends KdbxSubNode<String?> {
  DefaultSequenceNode(KdbxNode node) : super(node, 'DefaultSequence');

  @override
  String? get() {
    final parent = node.node.singleElement(KdbxXml.NODE_AUTO_TYPE);
    if (parent != null) {
      final value = parent.findElements(name).singleWhereOrNull((x) => true);
      return value?.innerXml;
    }
    return null;
  }

  @override
  bool set(String? value, {bool force = false}) {
    if (get() == value && force != true) {
      return false;
    }
    node.modify(() {
      final parent = node.node.singleElement(
        KdbxXml.NODE_AUTO_TYPE,
        orElse: () {
          return XmlElement(XmlName(KdbxXml.NODE_AUTO_TYPE));
        },
      )!;
      final el = parent.singleElement(
        name,
        orElse: () {
          return XmlElement(XmlName(name));
        },
      )!;
      el.children.clear();
      if (value == null) {
        return false;
      }
      el.children.add(XmlText(value));
    });
    return true;
  }
}

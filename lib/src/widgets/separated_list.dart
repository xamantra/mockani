import 'package:flutter/material.dart';

class SeparatedList extends StatelessWidget {
  const SeparatedList({
    super.key,
    required this.children,
    required this.separator,
    required this.builder,
  });

  final List<Widget> children;
  final Widget separator;
  final Widget Function(BuildContext context, List<Widget> children) builder;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i > 0 || i < (children.length - 1)) {
        items.add(separator);
      }
    }
    return builder(context, items);
  }
}

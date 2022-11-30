import 'package:flutter/widgets.dart';

bool isSmallScreen(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  return w <= 768;
}

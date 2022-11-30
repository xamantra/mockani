import 'package:flutter/widgets.dart';
import 'package:mockani/src/utils/theme_extension.dart';

const lightTheme = CustomTheme(
  primaryBackground: Color(0xffFFFFFF),
  secondaryBackground: Color.fromARGB(255, 250, 250, 250),
  tertiaryBackground: Color(0xffE5E5E5),
  onBackground: Color(0xff333333),
  primary: Color(0xffF52BA7),
  success: Color(0xff88CC00),
  danger: Color(0xffFF0033),
  radical: Color(0xff009AE7),
  kanji: Color(0xffE50098),
  vocabulary: Color(0xff9E00ED),
);

const darkTheme = CustomTheme(
  primaryBackground: Color(0xff1E1E1E),
  secondaryBackground: Color(0xff252526),
  tertiaryBackground: Color(0xff333333),
  onBackground: Color(0xffE8EAED),
  primary: Color(0xffF52BA7),
  success: Color(0xff88CC00),
  danger: Color(0xffFF0033),
  radical: Color(0xff009AE7),
  kanji: Color(0xffE50098),
  vocabulary: Color(0xff9E00ED),
);

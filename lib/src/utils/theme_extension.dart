import 'package:flutter/material.dart';

class CustomTheme extends ThemeExtension<CustomTheme> {
  final Color primaryBackground;
  final Color secondaryBackground;
  final Color tertiaryBackground;
  final Color onBackground;

  // WaniKani colors
  final Color primary;
  final Color success;
  final Color danger;
  final Color radical;
  final Color kanji;
  final Color vocabulary;

  const CustomTheme({
    required this.primaryBackground,
    required this.secondaryBackground,
    required this.tertiaryBackground,
    required this.onBackground,
    required this.primary,
    required this.success,
    required this.danger,
    required this.radical,
    required this.kanji,
    required this.vocabulary,
  });

  @override
  CustomTheme copyWith({
    Color? primaryBackground,
    Color? secondaryBackground,
    Color? tertiaryBackground,
    Color? onBackground,
    Color? primary,
    Color? success,
    Color? danger,
    Color? radical,
    Color? kanji,
    Color? vocabulary,
  }) {
    return CustomTheme(
      primaryBackground: primaryBackground ?? this.primaryBackground,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      tertiaryBackground: tertiaryBackground ?? this.tertiaryBackground,
      onBackground: onBackground ?? this.onBackground,
      primary: primary ?? this.primary,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      radical: radical ?? this.radical,
      kanji: kanji ?? this.kanji,
      vocabulary: vocabulary ?? this.vocabulary,
    );
  }

  @override
  CustomTheme lerp(ThemeExtension<CustomTheme>? other, double t) {
    if (other is! CustomTheme) {
      return this;
    }

    return CustomTheme(
      primaryBackground: Color.lerp(primaryBackground, other.primaryBackground, t)!,
      secondaryBackground: Color.lerp(secondaryBackground, other.secondaryBackground, t)!,
      tertiaryBackground: Color.lerp(tertiaryBackground, other.tertiaryBackground, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      radical: Color.lerp(radical, other.radical, t)!,
      kanji: Color.lerp(kanji, other.kanji, t)!,
      vocabulary: Color.lerp(vocabulary, other.vocabulary, t)!,
    );
  }

  Color getColorFrom(String subjectType) {
    switch (subjectType) {
      case "kanji":
        return kanji;
      case "radical":
        return radical;
      case "vocabulary":
        return vocabulary;
      default:
        return kanji;
    }
  }
}

CustomTheme getCustomTheme(BuildContext context) {
  return Theme.of(context).extension<CustomTheme>()!;
}

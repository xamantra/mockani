import 'package:kana_kit/kana_kit.dart';

const kana = KanaKit();

String toHiragana(String romaji) {
  return kana.toHiragana(romaji);
}

/// Does the current input end with two nn.
bool isDoubleNN(String input) {
  final str = input.toLowerCase();
  if (str.length <= 1) return false;
  final last = str.length - 1;
  final last2nd = last - 1;
  return str[last] == "n" && str[last2nd] == "n";
}

/// Does the current input starts or ends with `other`.
bool startsOrEndsWith(String input, String other) {
  return input == other || input.endsWith(other);
}

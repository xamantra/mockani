import 'package:kana_kit/kana_kit.dart';

const kana = KanaKit();

String toHiragana(String romaji) {
  return kana.toHiragana(romaji);
}

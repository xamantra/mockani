import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mockani/src/data/kanji.dart';

class KanjiApiRepository {
  Future<List<Kanji>> getKanjiList() async {
    try {
      final file = await rootBundle.loadString("kanjiapi/kanjiapi_data.json");
      final data = jsonDecode(file) as List<dynamic>;
      final kanjiList = data.map((e) => Kanji.fromMap(e)).toList();
      return kanjiList;
    } catch (e) {
      return [];
    }
  }
}

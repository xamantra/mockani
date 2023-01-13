// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mockani/src/data/kanji.dart';
import 'package:mockani/src/repositories/kanjiapi_repository.dart';

class NameGeneratorProvider {
  final kanjiApiRepository = KanjiApiRepository();

  final StreamController<NameGeneratorProvider> _state = StreamController.broadcast();
  Stream<NameGeneratorProvider> get stream => _state.stream;

  List<Kanji> kanjiList = [];
  bool loading = false;

  /* User input */
  List<String> keywords = [];

  Map<String, List<Kanji>> originalSelectedKanji = {};
  Map<String, List<Kanji>> selectedKanji = {};
  List<List<Kanji>> combinations = [];
  List<List<Kanji>> allPossibleCombinations = [];

  void init() async {
    loading = true;
    _state.add(this);

    kanjiList = await kanjiApiRepository.getKanjiList();

    loading = false;
    _state.add(this);
  }

  void addKeyword(String keyword) {
    keywords.add(keyword);
    _state.add(this);
  }

  void removeKeyword(String keyword) {
    keywords.remove(keyword);
    if (selectedKanji.containsKey(keyword)) {
      selectedKanji.remove(keyword);
    }
    _state.add(this);
  }

  void addKanji(String keyword, Kanji kanji) {
    selectedKanji[keyword] = (selectedKanji[keyword] ?? [])..add(kanji);
    _state.add(this);
  }

  void removeKanji(String keyword, Kanji kanji) {
    selectedKanji[keyword] = (selectedKanji[keyword] ?? [])..removeWhere((k) => k.kanji == kanji.kanji);
    _state.add(this);
  }

  bool isKanjiAdded(String keyword, Kanji kanji) {
    return (selectedKanji[keyword] ?? []).any((k) => k.kanji == kanji.kanji);
  }

  List<Kanji> getKanji(String keyword) {
    return kanjiList.where((k) => k.hasMeaning(keyword)).toList()..sort((a, b) => a.sortKey().compareTo(b.sortKey()));
  }

  void resetGenerator() {
    originalSelectedKanji = {};
    selectedKanji = {};
    combinations = [];
    allPossibleCombinations = [];
  }

  void warmupGenerator() {
    combinations = [];
    allPossibleCombinations = [];
    _shiftedKanjiSet = [];
    originalSelectedKanji = Map<String, List<Kanji>>.from(selectedKanji);
  }

  void generateNames() {
    var keys = selectedKanji.keys.toList();
    keys.sort((a, b) => selectedKanji[b]!.length.compareTo(selectedKanji[a]!.length));

    final max = selectedKanji[keys.first]!.length;
    final lastKey = keys.last;

    for (var i = 0; i < max; i++) {
      var combination = <Kanji>[];
      for (final key in keys) {
        final kanjiSet = selectedKanji[key]!;
        try {
          combination.add(kanjiSet[i]);
        } catch (e) {
          combination.add(kanjiSet[0]);
        }
        if (key == lastKey) {
          final cmb = List<Kanji>.from(combination);
          if (!combinations.any((c) => c.map((e) => e.kanji).join(",") == cmb.map((e) => e.kanji).join(","))) {
            combinations.add(cmb);
          }
          combination.clear();
          combination = [];
        }
      }
    }

    if (_shiftNext()) {
      generateNames();
    } else {
      selectedKanji = Map.from(originalSelectedKanji);
      shiftCombinations();
      _state.add(this);
      for (var combination in allPossibleCombinations) {
        if (kDebugMode) {
          print(combination);
        }
      }
    }
  }

  List<String> _shiftedKanjiSet = [];
  bool _shiftNext() {
    var keys = selectedKanji.keys.toList();
    keys.sort((a, b) => selectedKanji[b]!.length.compareTo(selectedKanji[a]!.length));

    for (final key in keys) {
      if (!_shiftedKanjiSet.contains(key)) {
        if (kDebugMode) {
          print([key, selectedKanji[key]!.map((e) => e.kanji)]);
        }

        var items = List<Kanji>.from(selectedKanji[key]!);
        final item = items[0];
        items.removeAt(0);
        selectedKanji[key] = items..insert(items.length, item);

        final originalSet = originalSelectedKanji[key]!.map((e) => e.kanji).join(", ");
        final shiftedSet = selectedKanji[key]!.map((e) => e.kanji).join(", ");

        if (shiftedSet == originalSet) {
          _shiftedKanjiSet.add(key);
        }
        break;
      }
    }

    return _shiftedKanjiSet.length != keys.length;
  }

  void shiftCombinations() {
    for (var combination in combinations) {
      var items = List<Kanji>.from(combination);
      _addCombination(List<Kanji>.from(items));
      for (var i = 0; i < keywords.length; i++) {
        final item = items[0];
        items.removeAt(0);
        items = items..insert(keywords.length - 1, item);
        _addCombination(List<Kanji>.from(items));
      }
    }
  }

  void _addCombination(List<Kanji> combination) {
    if (allPossibleCombinations.any((ac) => ac.map((e) => e.kanji).join(",") == combination.map((c) => c.kanji).join(","))) {
      if (kDebugMode) {
        print("Already added ${combination.map((e) => e.kanji).join(", ")}");
      }
    } else {
      allPossibleCombinations.add(combination);
    }
  }
}

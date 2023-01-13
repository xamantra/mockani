// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, unused_import

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:mockani/src/utils/kana_kit.dart';

/// Model is taken from: https://kanjiapi.dev/
class Kanji {
  final String kanji;
  final int grade;
  final int stroke_count;
  final List<String> meanings;
  final List<String> kun_readings;
  final List<String> on_readings;
  final List<String> name_readings;
  final int jlpt;
  final String unicode;
  final String heisig_en;

  Kanji({
    required this.kanji,
    required this.grade,
    required this.stroke_count,
    required this.meanings,
    required this.kun_readings,
    required this.on_readings,
    required this.name_readings,
    required this.jlpt,
    required this.unicode,
    required this.heisig_en,
  });

  List<String> allReadings({
    List<String> types = const ["kun", "on", "name"],
  }) {
    var readings = <String>[];
    if (types.contains("kun")) {
      for (final r in kun_readings) {
        if (r.contains(".")) {
          final split = r.split(".");
          readings.add(split[0]);
        } else {
          readings.add(r);
        }
      }
    }
    if (types.contains("on")) {
      readings.addAll(on_readings.map((e) => toHiragana(e)));
    }
    if (types.contains("name")) {
      readings.addAll(name_readings);
    }

    return readings.map((e) => e.replaceAll("-", "")).toSet().toList();
  }

  bool hasMeaning(String meaning) {
    return meanings.map((e) => e.toLowerCase()).contains(meaning);
  }

  bool hasKeyword(String keyword) {
    return meanings.any((e) => e.toLowerCase().contains(keyword));
  }

  int sortKey() {
    if (grade == 0) return 999999;
    return grade;
  }

  Kanji copyWith({
    String? kanji,
    int? grade,
    int? stroke_count,
    List<String>? meanings,
    List<String>? kun_readings,
    List<String>? on_readings,
    List<String>? name_readings,
    int? jlpt,
    String? unicode,
    String? heisig_en,
  }) {
    return Kanji(
      kanji: kanji ?? this.kanji,
      grade: grade ?? this.grade,
      stroke_count: stroke_count ?? this.stroke_count,
      meanings: meanings ?? this.meanings,
      kun_readings: kun_readings ?? this.kun_readings,
      on_readings: on_readings ?? this.on_readings,
      name_readings: name_readings ?? this.name_readings,
      jlpt: jlpt ?? this.jlpt,
      unicode: unicode ?? this.unicode,
      heisig_en: heisig_en ?? this.heisig_en,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'kanji': kanji});
    result.addAll({'grade': grade});
    result.addAll({'stroke_count': stroke_count});
    result.addAll({'meanings': meanings});
    result.addAll({'kun_readings': kun_readings});
    result.addAll({'on_readings': on_readings});
    result.addAll({'name_readings': name_readings});
    result.addAll({'jlpt': jlpt});
    result.addAll({'unicode': unicode});
    result.addAll({'heisig_en': heisig_en});

    return result;
  }

  factory Kanji.fromMap(Map<String, dynamic> map) {
    return Kanji(
      kanji: map['kanji'] ?? '',
      grade: map['grade']?.toInt() ?? 0,
      stroke_count: map['stroke_count']?.toInt() ?? 0,
      meanings: List<String>.from(map['meanings']),
      kun_readings: List<String>.from(map['kun_readings'] ?? []),
      on_readings: List<String>.from(map['on_readings'] ?? []),
      name_readings: List<String>.from(map['name_readings'] ?? []),
      jlpt: map['jlpt']?.toInt() ?? 0,
      unicode: map['unicode'] ?? '',
      heisig_en: map['heisig_en'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Kanji.fromJson(String source) => Kanji.fromMap(json.decode(source));

  // @override
  // String toString() {
  //   return 'Kanji(kanji: $kanji, grade: $grade, stroke_count: $stroke_count, meanings: $meanings, kun_readings: $kun_readings, on_readings: $on_readings, name_readings: $name_readings, jlpt: $jlpt, unicode: $unicode, heisig_en: $heisig_en)';
  // }


  @override
  String toString() {
    return kanji;
  }

  @override
  bool operator ==(Object other) {
    return other is Kanji && other.kanji == kanji;
  }

  @override
  int get hashCode {
    return kanji.hashCode;
  }
}

// ignore_for_file: non_constant_identifier_names, unnecessary_cast

import 'dart:convert';

import 'package:mockani/src/data/answer.dart';
import 'package:mockani/src/utils/list_equals.dart';

class SubjectDetails {
  final int id;
  final String object;
  final String url;
  final String data_updated_at;
  final SubjectItemDetails data;

  List<String> get getMeaningAnswers {
    final meanings = data.meanings.where((m) => m.accepted_answer).map((e) => e.answer.toLowerCase());
    final alternatives = data.auxiliary_meanings.where((a) => a.type == "whitelisted").map((e) => e.answer.toLowerCase());
    return meanings.toList()..addAll(alternatives..toList());
  }

  List<String> get getReadingAnswers {
    return data.readings.where((r) => r.accepted_answer).map((e) => e.reading.toLowerCase()).toList();
  }

  bool get isRadical => object == "radical";

  SubjectDetails({
    required this.id,
    required this.object,
    required this.url,
    required this.data_updated_at,
    required this.data,
  });

  SubjectDetails copyWith({
    int? id,
    String? object,
    String? url,
    String? data_updated_at,
    SubjectItemDetails? data,
  }) {
    return SubjectDetails(
      id: id ?? this.id,
      object: object ?? this.object,
      url: url ?? this.url,
      data_updated_at: data_updated_at ?? this.data_updated_at,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'object': object});
    result.addAll({'url': url});
    result.addAll({'data_updated_at': data_updated_at});
    result.addAll({'data': data.toMap()});

    return result;
  }

  factory SubjectDetails.fromMap(Map<String, dynamic> map) {
    return SubjectDetails(
      id: map['id']?.toInt() ?? 0,
      object: map['object'] ?? '',
      url: map['url'] ?? '',
      data_updated_at: map['data_updated_at'] ?? '',
      data: SubjectItemDetails.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectDetails.fromJson(String source) => SubjectDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubjectDetails(id: $id, object: $object, url: $url, data_updated_at: $data_updated_at, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubjectDetails && other.id == id && other.object == object && other.url == url && other.data_updated_at == data_updated_at && other.data == data;
  }

  @override
  int get hashCode {
    return id.hashCode ^ object.hashCode ^ url.hashCode ^ data_updated_at.hashCode ^ data.hashCode;
  }
}

class SubjectItemDetails {
  final String created_at;
  final int level;
  final String slug;
  final String document_url;
  final String characters;
  final List<Meaning> meanings;
  final List<AuxiliaryMeaning> auxiliary_meanings;
  final List<Reading> readings;
  final List<int> component_subject_ids;
  final List<int> amalgamation_subject_ids;
  final String meaning_mnemonic;
  final String meaning_hint;
  final String reading_mnemonic;
  final String reading_hint;
  final int lesson_position;
  final int spaced_repetition_system_id;
  SubjectItemDetails({
    required this.created_at,
    required this.level,
    required this.slug,
    required this.document_url,
    required this.characters,
    required this.meanings,
    required this.auxiliary_meanings,
    required this.readings,
    required this.component_subject_ids,
    required this.amalgamation_subject_ids,
    required this.meaning_mnemonic,
    required this.meaning_hint,
    required this.reading_mnemonic,
    required this.reading_hint,
    required this.lesson_position,
    required this.spaced_repetition_system_id,
  });

  SubjectItemDetails copyWith({
    String? created_at,
    int? level,
    String? slug,
    String? document_url,
    String? characters,
    List<Meaning>? meanings,
    List<AuxiliaryMeaning>? auxiliary_meanings,
    List<Reading>? readings,
    List<int>? component_subject_ids,
    List<int>? amalgamation_subject_ids,
    String? meaning_mnemonic,
    String? meaning_hint,
    String? reading_mnemonic,
    String? reading_hint,
    int? lesson_position,
    int? spaced_repetition_system_id,
  }) {
    return SubjectItemDetails(
      created_at: created_at ?? this.created_at,
      level: level ?? this.level,
      slug: slug ?? this.slug,
      document_url: document_url ?? this.document_url,
      characters: characters ?? this.characters,
      meanings: meanings ?? this.meanings,
      auxiliary_meanings: auxiliary_meanings ?? this.auxiliary_meanings,
      readings: readings ?? this.readings,
      component_subject_ids: component_subject_ids ?? this.component_subject_ids,
      amalgamation_subject_ids: amalgamation_subject_ids ?? this.amalgamation_subject_ids,
      meaning_mnemonic: meaning_mnemonic ?? this.meaning_mnemonic,
      meaning_hint: meaning_hint ?? this.meaning_hint,
      reading_mnemonic: reading_mnemonic ?? this.reading_mnemonic,
      reading_hint: reading_hint ?? this.reading_hint,
      lesson_position: lesson_position ?? this.lesson_position,
      spaced_repetition_system_id: spaced_repetition_system_id ?? this.spaced_repetition_system_id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'created_at': created_at});
    result.addAll({'level': level});
    result.addAll({'slug': slug});
    result.addAll({'document_url': document_url});
    result.addAll({'characters': characters});
    result.addAll({'meanings': meanings.map((x) => x.toMap()).toList()});
    result.addAll({'auxiliary_meanings': auxiliary_meanings.map((x) => x.toMap()).toList()});
    result.addAll({'readings': readings.map((x) => x.toMap()).toList()});
    result.addAll({'component_subject_ids': component_subject_ids});
    result.addAll({'amalgamation_subject_ids': amalgamation_subject_ids});
    result.addAll({'meaning_mnemonic': meaning_mnemonic});
    result.addAll({'meaning_hint': meaning_hint});
    result.addAll({'reading_mnemonic': reading_mnemonic});
    result.addAll({'reading_hint': reading_hint});
    result.addAll({'lesson_position': lesson_position});
    result.addAll({'spaced_repetition_system_id': spaced_repetition_system_id});

    return result;
  }

  factory SubjectItemDetails.fromMap(Map<String, dynamic> map) {
    return SubjectItemDetails(
      created_at: map['created_at'] ?? '',
      level: map['level']?.toInt() ?? 0,
      slug: map['slug'] ?? '',
      document_url: map['document_url'] ?? '',
      characters: map['characters'] ?? '',
      meanings: List<Meaning>.from(map['meanings']?.map((x) => Meaning.fromMap(x)) ?? []),
      auxiliary_meanings: List<AuxiliaryMeaning>.from(map['auxiliary_meanings']?.map((x) => AuxiliaryMeaning.fromMap(x)) ?? []),
      readings: List<Reading>.from(map['readings']?.map((x) => Reading.fromMap(x)) ?? []),
      component_subject_ids: List<int>.from(map['component_subject_ids'] ?? []),
      amalgamation_subject_ids: List<int>.from(map['amalgamation_subject_ids'] ?? []),
      meaning_mnemonic: map['meaning_mnemonic'] ?? '',
      meaning_hint: map['meaning_hint'] ?? '',
      reading_mnemonic: map['reading_mnemonic'] ?? '',
      reading_hint: map['reading_hint'] ?? '',
      lesson_position: map['lesson_position']?.toInt() ?? 0,
      spaced_repetition_system_id: map['spaced_repetition_system_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectItemDetails.fromJson(String source) => SubjectItemDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Data(created_at: $created_at, level: $level, slug: $slug, document_url: $document_url, characters: $characters, meanings: $meanings, auxiliary_meanings: $auxiliary_meanings, readings: $readings, component_subject_ids: $component_subject_ids, amalgamation_subject_ids: $amalgamation_subject_ids, meaning_mnemonic: $meaning_mnemonic, meaning_hint: $meaning_hint, reading_mnemonic: $reading_mnemonic, reading_hint: $reading_hint, lesson_position: $lesson_position, spaced_repetition_system_id: $spaced_repetition_system_id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubjectItemDetails &&
        other.created_at == created_at &&
        other.level == level &&
        other.slug == slug &&
        other.document_url == document_url &&
        other.characters == characters &&
        listEquals(other.meanings, meanings) &&
        listEquals(other.auxiliary_meanings, auxiliary_meanings) &&
        listEquals(other.readings, readings) &&
        listEquals(other.component_subject_ids, component_subject_ids) &&
        listEquals(other.amalgamation_subject_ids, amalgamation_subject_ids) &&
        other.meaning_mnemonic == meaning_mnemonic &&
        other.meaning_hint == meaning_hint &&
        other.reading_mnemonic == reading_mnemonic &&
        other.reading_hint == reading_hint &&
        other.lesson_position == lesson_position &&
        other.spaced_repetition_system_id == spaced_repetition_system_id;
  }

  @override
  int get hashCode {
    return created_at.hashCode ^
        level.hashCode ^
        slug.hashCode ^
        document_url.hashCode ^
        characters.hashCode ^
        meanings.hashCode ^
        auxiliary_meanings.hashCode ^
        readings.hashCode ^
        component_subject_ids.hashCode ^
        amalgamation_subject_ids.hashCode ^
        meaning_mnemonic.hashCode ^
        meaning_hint.hashCode ^
        reading_mnemonic.hashCode ^
        reading_hint.hashCode ^
        lesson_position.hashCode ^
        spaced_repetition_system_id.hashCode;
  }
}

class Meaning extends MeaningInterface {
  final String meaning;
  final bool primary;
  final bool accepted_answer;

  @override
  String get answer {
    return meaning.toLowerCase();
  }

  Meaning({
    required this.meaning,
    required this.primary,
    required this.accepted_answer,
  });

  Meaning copyWith({
    String? meaning,
    bool? primary,
    bool? accepted_answer,
  }) {
    return Meaning(
      meaning: meaning ?? this.meaning,
      primary: primary ?? this.primary,
      accepted_answer: accepted_answer ?? this.accepted_answer,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'meaning': meaning});
    result.addAll({'primary': primary});
    result.addAll({'accepted_answer': accepted_answer});

    return result;
  }

  factory Meaning.fromMap(Map<String, dynamic> map) {
    return Meaning(
      meaning: map['meaning'] ?? '',
      primary: map['primary'] ?? false,
      accepted_answer: map['accepted_answer'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Meaning.fromJson(String source) => Meaning.fromMap(json.decode(source));

  @override
  String toString() => 'Meaning(meaning: $meaning, primary: $primary, accepted_answer: $accepted_answer)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Meaning && other.meaning == meaning && other.primary == primary && other.accepted_answer == accepted_answer;
  }

  @override
  int get hashCode => meaning.hashCode ^ primary.hashCode ^ accepted_answer.hashCode;
}

class AuxiliaryMeaning extends MeaningInterface {
  final String type;
  final String meaning;

  @override
  String get answer {
    return meaning.toLowerCase();
  }

  AuxiliaryMeaning({
    required this.type,
    required this.meaning,
  });

  AuxiliaryMeaning copyWith({
    String? type,
    String? meaning,
  }) {
    return AuxiliaryMeaning(
      type: type ?? this.type,
      meaning: meaning ?? this.meaning,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'type': type});
    result.addAll({'meaning': meaning});

    return result;
  }

  factory AuxiliaryMeaning.fromMap(Map<String, dynamic> map) {
    return AuxiliaryMeaning(
      type: map['type'] ?? '',
      meaning: map['meaning'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AuxiliaryMeaning.fromJson(String source) => AuxiliaryMeaning.fromMap(json.decode(source));

  @override
  String toString() => 'Auxiliary_meaning(type: $type, meaning: $meaning)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuxiliaryMeaning && other.type == type && other.meaning == meaning;
  }

  @override
  int get hashCode => type.hashCode ^ meaning.hashCode;
}

class Reading {
  final String type;
  final bool primary;
  final String reading;
  final bool accepted_answer;
  Reading({
    required this.type,
    required this.primary,
    required this.reading,
    required this.accepted_answer,
  });

  Reading copyWith({
    String? type,
    bool? primary,
    String? reading,
    bool? accepted_answer,
  }) {
    return Reading(
      type: type ?? this.type,
      primary: primary ?? this.primary,
      reading: reading ?? this.reading,
      accepted_answer: accepted_answer ?? this.accepted_answer,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'type': type});
    result.addAll({'primary': primary});
    result.addAll({'reading': reading});
    result.addAll({'accepted_answer': accepted_answer});

    return result;
  }

  factory Reading.fromMap(Map<String, dynamic> map) {
    return Reading(
      type: map['type'] ?? '',
      primary: map['primary'] ?? false,
      reading: map['reading'] ?? '',
      accepted_answer: map['accepted_answer'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reading.fromJson(String source) => Reading.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Reading(type: $type, primary: $primary, reading: $reading, accepted_answer: $accepted_answer)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Reading && other.type == type && other.primary == primary && other.reading == reading && other.accepted_answer == accepted_answer;
  }

  @override
  int get hashCode {
    return type.hashCode ^ primary.hashCode ^ reading.hashCode ^ accepted_answer.hashCode;
  }
}

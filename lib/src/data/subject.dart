// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:mockani/src/data/answer.dart';

class Subjects {
  final String object;
  final String url;
  final Pages pages;
  final int total_count;
  final String data_updated_at;
  final List<SubjectData> data;
  Subjects({
    required this.object,
    required this.url,
    required this.pages,
    required this.total_count,
    required this.data_updated_at,
    required this.data,
  });

  Subjects copyWith({
    String? object,
    String? url,
    Pages? pages,
    int? total_count,
    String? data_updated_at,
    List<SubjectData>? data,
  }) {
    return Subjects(
      object: object ?? this.object,
      url: url ?? this.url,
      pages: pages ?? this.pages,
      total_count: total_count ?? this.total_count,
      data_updated_at: data_updated_at ?? this.data_updated_at,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'object': object});
    result.addAll({'url': url});
    result.addAll({'pages': pages.toMap()});
    result.addAll({'total_count': total_count});
    result.addAll({'data_updated_at': data_updated_at});
    result.addAll({'data': data.map((x) => x.toMap()).toList()});

    return result;
  }

  factory Subjects.fromMap(Map<String, dynamic> map) {
    return Subjects(
      object: map['object'] ?? '',
      url: map['url'] ?? '',
      pages: Pages.fromMap(map['pages']),
      total_count: map['total_count']?.toInt() ?? 0,
      data_updated_at: map['data_updated_at'] ?? '',
      data: List<SubjectData>.from(map['data']?.map((x) => SubjectData.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Subjects.fromJson(String source) => Subjects.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Subjects(object: $object, url: $url, pages: $pages, total_count: $total_count, data_updated_at: $data_updated_at, data: $data)';
  }
}

class Pages {
  final int per_page;
  Pages({
    required this.per_page,
  });

  Pages copyWith({
    int? per_page,
  }) {
    return Pages(
      per_page: per_page ?? this.per_page,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'per_page': per_page});

    return result;
  }

  factory Pages.fromMap(Map<String, dynamic> map) {
    return Pages(
      per_page: map['per_page']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pages.fromJson(String source) => Pages.fromMap(json.decode(source));

  @override
  String toString() => 'Pages(per_page: $per_page)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pages && other.per_page == per_page;
  }

  @override
  int get hashCode => per_page.hashCode;
}

class SubjectData {
  final int id;
  final String object;
  final String url;
  final String data_updated_at;
  final SubjectItem data;

  List<String> get getMeaningAnswers {
    final meanings = data.meanings.where((m) => m.accepted_answer).map((e) => e.answer.toLowerCase());
    final alternatives = data.auxiliary_meanings.where((a) => a.type == "whitelist").map((e) => e.answer.toLowerCase());
    return meanings.toList()..addAll(alternatives..toList());
  }

  List<String> get getReadingAnswers {
    return data.readings.where((r) => r.accepted_answer).map((e) => e.reading.toLowerCase()).toList();
  }

  CharacterImage? get getCharacterImage {
    if (data.character_images.isNotEmpty) {
      return data.character_images.firstWhere((x) => x.inlineStyles && x.content_type.contains("svg+xml"));
    }
    return null;
  }

  bool get isRadical => object == "radical";

  SubjectData({
    required this.id,
    required this.object,
    required this.url,
    required this.data_updated_at,
    required this.data,
  });

  SubjectData copyWith({
    int? id,
    String? object,
    String? url,
    String? data_updated_at,
    SubjectItem? data,
  }) {
    return SubjectData(
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

  factory SubjectData.fromMap(Map<String, dynamic> map) {
    return SubjectData(
      id: map['id']?.toInt() ?? 0,
      object: map['object'] ?? '',
      url: map['url'] ?? '',
      data_updated_at: map['data_updated_at'] ?? '',
      data: SubjectItem.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectData.fromJson(String source) => SubjectData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Data(id: $id, object: $object, url: $url, data_updated_at: $data_updated_at, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubjectData && other.id == id && other.object == object && other.url == url && other.data_updated_at == data_updated_at && other.data == data;
  }

  @override
  int get hashCode {
    return id.hashCode ^ object.hashCode ^ url.hashCode ^ data_updated_at.hashCode ^ data.hashCode;
  }
}

class SubjectItem {
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
  final List<CharacterImage> character_images;
  final String meaning_mnemonic;
  final int lesson_position;
  final int spaced_repetition_system_id;

  List<String> get getTypes => auxiliary_meanings.map((a) => a.type).toSet().toList();

  SubjectItem({
    required this.created_at,
    required this.level,
    required this.slug,
    required this.document_url,
    required this.characters,
    required this.meanings,
    required this.auxiliary_meanings,
    required this.meaning_mnemonic,
    required this.lesson_position,
    required this.spaced_repetition_system_id,
    required this.readings,
    required this.component_subject_ids,
    required this.amalgamation_subject_ids,
    required this.character_images,
  });

  SubjectItem copyWith({
    String? created_at,
    int? level,
    String? slug,
    String? document_url,
    String? characters,
    List<Meaning>? meanings,
    List<AuxiliaryMeaning>? auxiliary_meanings,
    String? meaning_mnemonic,
    int? lesson_position,
    int? spaced_repetition_system_id,
    List<int>? amalgamation_subject_ids,
    List<CharacterImage>? character_images,
    List<int>? component_subject_ids,
    List<Reading>? readings,
  }) {
    return SubjectItem(
      created_at: created_at ?? this.created_at,
      level: level ?? this.level,
      slug: slug ?? this.slug,
      document_url: document_url ?? this.document_url,
      characters: characters ?? this.characters,
      meanings: meanings ?? this.meanings,
      auxiliary_meanings: auxiliary_meanings ?? this.auxiliary_meanings,
      meaning_mnemonic: meaning_mnemonic ?? this.meaning_mnemonic,
      lesson_position: lesson_position ?? this.lesson_position,
      spaced_repetition_system_id: spaced_repetition_system_id ?? this.spaced_repetition_system_id,
      amalgamation_subject_ids: amalgamation_subject_ids ?? this.amalgamation_subject_ids,
      character_images: character_images ?? this.character_images,
      component_subject_ids: component_subject_ids ?? this.component_subject_ids,
      readings: readings ?? this.readings,
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
    result.addAll({'character_images': character_images.map((x) => x.toMap()).toList()});
    result.addAll({'readings': readings.map((x) => x.toMap()).toList()});
    result.addAll({'component_subject_ids': component_subject_ids});
    result.addAll({'amalgamation_subject_ids': amalgamation_subject_ids});
    result.addAll({'meaning_mnemonic': meaning_mnemonic});
    result.addAll({'lesson_position': lesson_position});
    result.addAll({'spaced_repetition_system_id': spaced_repetition_system_id});

    return result;
  }

  factory SubjectItem.fromMap(Map<String, dynamic> map) {
    return SubjectItem(
      created_at: map['created_at'] ?? '',
      level: map['level']?.toInt() ?? 0,
      slug: map['slug'] ?? '',
      document_url: map['document_url'] ?? '',
      characters: map['characters'] ?? '',
      meanings: List<Meaning>.from(map['meanings']?.map((x) => Meaning.fromMap(x)) ?? []),
      auxiliary_meanings: List<AuxiliaryMeaning>.from(map['auxiliary_meanings']?.map((x) => AuxiliaryMeaning.fromMap(x)) ?? []),
      character_images: List<CharacterImage>.from(map['character_images']?.map((x) => CharacterImage.fromMap(x)) ?? []),
      readings: List<Reading>.from(map['readings']?.map((x) => Reading.fromMap(x)) ?? []),
      component_subject_ids: List<int>.from(map['component_subject_ids'] ?? []),
      amalgamation_subject_ids: List<int>.from(map['amalgamation_subject_ids'] ?? []),
      meaning_mnemonic: map['meaning_mnemonic'] ?? '',
      lesson_position: map['lesson_position']?.toInt() ?? 0,
      spaced_repetition_system_id: map['spaced_repetition_system_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectItem.fromJson(String source) => SubjectItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubjectItem(created_at: $created_at, level: $level, slug: $slug, document_url: $document_url, characters: $characters, meanings: $meanings, auxiliary_meanings: $auxiliary_meanings, readings: $readings, component_subject_ids: $component_subject_ids, amalgamation_subject_ids: $amalgamation_subject_ids, meaning_mnemonic: $meaning_mnemonic, lesson_position: $lesson_position, spaced_repetition_system_id: $spaced_repetition_system_id)';
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

class AuxiliaryMeaning extends MeaningInterface {
  final String type;
  final String meaning;

  @override
  String get answer {
    return meaning.toLowerCase();
  }

  AuxiliaryMeaning({required this.type, required this.meaning});

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
}

class CharacterImage {
  final String url;
  final String content_type;
  final Map<String, dynamic> metadata;

  bool get inlineStyles {
    try {
      return metadata["inline_styles"] ?? false;
    } catch (e) {
      return false;
    }
  }

  CharacterImage({
    required this.url,
    required this.content_type,
    required this.metadata,
  });

  CharacterImage copyWith({
    String? url,
    String? content_type,
    Map<String, dynamic>? metadata,
  }) {
    return CharacterImage(
      url: url ?? this.url,
      content_type: content_type ?? this.content_type,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'url': url});
    result.addAll({'content_type': content_type});
    result.addAll({'metadata': metadata});

    return result;
  }

  factory CharacterImage.fromMap(Map<String, dynamic> map) {
    return CharacterImage(
      url: map['url'] ?? '',
      content_type: map['content_type'] ?? '',
      metadata: map['metadata'] ?? {},
    );
  }

  String toJson() => json.encode(toMap());

  factory CharacterImage.fromJson(String source) => CharacterImage.fromMap(json.decode(source));

  @override
  String toString() => 'Character_image(url: $url, content_type: $content_type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CharacterImage && other.url == url && other.content_type == content_type;
  }

  @override
  int get hashCode => url.hashCode ^ content_type.hashCode;
}

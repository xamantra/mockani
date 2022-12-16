// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'dart:convert';

class ReviewStatistics {
  final String object;
  final String url;
  final _Pages pages;
  final int total_count;
  final String data_updated_at;
  final List<_Data> data;
  ReviewStatistics({
    required this.object,
    required this.url,
    required this.pages,
    required this.total_count,
    required this.data_updated_at,
    required this.data,
  });

  ReviewStatistics copyWith({
    String? object,
    String? url,
    _Pages? pages,
    int? total_count,
    String? data_updated_at,
    List<_Data>? data,
  }) {
    return ReviewStatistics(
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

  factory ReviewStatistics.fromMap(Map<String, dynamic> map) {
    return ReviewStatistics(
      object: map['object'] ?? '',
      url: map['url'] ?? '',
      pages: _Pages.fromMap(map['pages']),
      total_count: map['total_count']?.toInt() ?? 0,
      data_updated_at: map['data_updated_at'] ?? '',
      data: List<_Data>.from(map['data']?.map((x) => _Data.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewStatistics.fromJson(String source) => ReviewStatistics.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReviewStatistics(object: $object, url: $url, pages: $pages, total_count: $total_count, data_updated_at: $data_updated_at, data: $data)';
  }
}

class _Pages {
  final int per_page;
  final String? next_url;
  final String? previous_url;
  _Pages({
    required this.per_page,
    required this.next_url,
    required this.previous_url,
  });

  _Pages copyWith({
    int? per_page,
    String? next_url,
    String? previous_url,
  }) {
    return _Pages(
      per_page: per_page ?? this.per_page,
      next_url: next_url ?? this.next_url,
      previous_url: previous_url ?? this.previous_url,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'per_page': per_page});
    result.addAll({'next_url': next_url});
    result.addAll({'previous_url': previous_url});

    return result;
  }

  factory _Pages.fromMap(Map<String, dynamic> map) {
    return _Pages(
      per_page: map['per_page']?.toInt() ?? 0,
      next_url: map['next_url'],
      previous_url: map['previous_url'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Pages(per_page: $per_page, next_url: $next_url, previous_url: $previous_url)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _Pages && other.per_page == per_page && other.next_url == next_url && other.previous_url == previous_url;
  }

  @override
  int get hashCode => per_page.hashCode ^ next_url.hashCode ^ previous_url.hashCode;
}

class _Data {
  final int id;
  final String object;
  final String url;
  final String data_updated_at;
  final ReviewStat data;
  _Data({
    required this.id,
    required this.object,
    required this.url,
    required this.data_updated_at,
    required this.data,
  });

  _Data copyWith({
    int? id,
    String? object,
    String? url,
    String? data_updated_at,
    ReviewStat? data,
  }) {
    return _Data(
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

  factory _Data.fromMap(Map<String, dynamic> map) {
    return _Data(
      id: map['id']?.toInt() ?? 0,
      object: map['object'] ?? '',
      url: map['url'] ?? '',
      data_updated_at: map['data_updated_at'] ?? '',
      data: ReviewStat.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Data(id: $id, object: $object, url: $url, data_updated_at: $data_updated_at, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _Data && other.id == id && other.object == object && other.url == url && other.data_updated_at == data_updated_at && other.data == data;
  }

  @override
  int get hashCode {
    return id.hashCode ^ object.hashCode ^ url.hashCode ^ data_updated_at.hashCode ^ data.hashCode;
  }
}

class ReviewStat {
  final String created_at;
  final int subject_id;
  final String subject_type;
  final int meaning_correct;
  final int meaning_incorrect;
  final int meaning_max_streak;
  final int meaning_current_streak;
  final int reading_correct;
  final int reading_incorrect;
  final int reading_max_streak;
  final int reading_current_streak;
  final int percentage_correct;
  final bool hidden;
  ReviewStat({
    required this.created_at,
    required this.subject_id,
    required this.subject_type,
    required this.meaning_correct,
    required this.meaning_incorrect,
    required this.meaning_max_streak,
    required this.meaning_current_streak,
    required this.reading_correct,
    required this.reading_incorrect,
    required this.reading_max_streak,
    required this.reading_current_streak,
    required this.percentage_correct,
    required this.hidden,
  });

  ReviewStat copyWith({
    String? created_at,
    int? subject_id,
    String? subject_type,
    int? meaning_correct,
    int? meaning_incorrect,
    int? meaning_max_streak,
    int? meaning_current_streak,
    int? reading_correct,
    int? reading_incorrect,
    int? reading_max_streak,
    int? reading_current_streak,
    int? percentage_correct,
    bool? hidden,
  }) {
    return ReviewStat(
      created_at: created_at ?? this.created_at,
      subject_id: subject_id ?? this.subject_id,
      subject_type: subject_type ?? this.subject_type,
      meaning_correct: meaning_correct ?? this.meaning_correct,
      meaning_incorrect: meaning_incorrect ?? this.meaning_incorrect,
      meaning_max_streak: meaning_max_streak ?? this.meaning_max_streak,
      meaning_current_streak: meaning_current_streak ?? this.meaning_current_streak,
      reading_correct: reading_correct ?? this.reading_correct,
      reading_incorrect: reading_incorrect ?? this.reading_incorrect,
      reading_max_streak: reading_max_streak ?? this.reading_max_streak,
      reading_current_streak: reading_current_streak ?? this.reading_current_streak,
      percentage_correct: percentage_correct ?? this.percentage_correct,
      hidden: hidden ?? this.hidden,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'created_at': created_at});
    result.addAll({'subject_id': subject_id});
    result.addAll({'subject_type': subject_type});
    result.addAll({'meaning_correct': meaning_correct});
    result.addAll({'meaning_incorrect': meaning_incorrect});
    result.addAll({'meaning_max_streak': meaning_max_streak});
    result.addAll({'meaning_current_streak': meaning_current_streak});
    result.addAll({'reading_correct': reading_correct});
    result.addAll({'reading_incorrect': reading_incorrect});
    result.addAll({'reading_max_streak': reading_max_streak});
    result.addAll({'reading_current_streak': reading_current_streak});
    result.addAll({'percentage_correct': percentage_correct});
    result.addAll({'hidden': hidden});

    return result;
  }

  factory ReviewStat.fromMap(Map<String, dynamic> map) {
    return ReviewStat(
      created_at: map['created_at'] ?? '',
      subject_id: map['subject_id']?.toInt() ?? 0,
      subject_type: map['subject_type'] ?? '',
      meaning_correct: map['meaning_correct']?.toInt() ?? 0,
      meaning_incorrect: map['meaning_incorrect']?.toInt() ?? 0,
      meaning_max_streak: map['meaning_max_streak']?.toInt() ?? 0,
      meaning_current_streak: map['meaning_current_streak']?.toInt() ?? 0,
      reading_correct: map['reading_correct']?.toInt() ?? 0,
      reading_incorrect: map['reading_incorrect']?.toInt() ?? 0,
      reading_max_streak: map['reading_max_streak']?.toInt() ?? 0,
      reading_current_streak: map['reading_current_streak']?.toInt() ?? 0,
      percentage_correct: map['percentage_correct']?.toInt() ?? 0,
      hidden: map['hidden'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewStat.fromJson(String source) => ReviewStat.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReviewStat(created_at: $created_at, subject_id: $subject_id, subject_type: $subject_type, meaning_correct: $meaning_correct, meaning_incorrect: $meaning_incorrect, meaning_max_streak: $meaning_max_streak, meaning_current_streak: $meaning_current_streak, reading_correct: $reading_correct, reading_incorrect: $reading_incorrect, reading_max_streak: $reading_max_streak, reading_current_streak: $reading_current_streak, percentage_correct: $percentage_correct, hidden: $hidden)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReviewStat &&
        other.created_at == created_at &&
        other.subject_id == subject_id &&
        other.subject_type == subject_type &&
        other.meaning_correct == meaning_correct &&
        other.meaning_incorrect == meaning_incorrect &&
        other.meaning_max_streak == meaning_max_streak &&
        other.meaning_current_streak == meaning_current_streak &&
        other.reading_correct == reading_correct &&
        other.reading_incorrect == reading_incorrect &&
        other.reading_max_streak == reading_max_streak &&
        other.reading_current_streak == reading_current_streak &&
        other.percentage_correct == percentage_correct &&
        other.hidden == hidden;
  }

  @override
  int get hashCode {
    return created_at.hashCode ^
        subject_id.hashCode ^
        subject_type.hashCode ^
        meaning_correct.hashCode ^
        meaning_incorrect.hashCode ^
        meaning_max_streak.hashCode ^
        meaning_current_streak.hashCode ^
        reading_correct.hashCode ^
        reading_incorrect.hashCode ^
        reading_max_streak.hashCode ^
        reading_current_streak.hashCode ^
        percentage_correct.hashCode ^
        hidden.hashCode;
  }
}

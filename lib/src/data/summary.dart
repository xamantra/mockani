// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

class Summary {
  final String data_updated_at;
  final SummaryData data;

  List<Review> get getReviews {
    return data.reviews.where((r) => r.subject_ids.isNotEmpty).toList();
  }

  Summary({
    required this.data_updated_at,
    required this.data,
  });

  Summary copyWith({
    String? data_updated_at,
    SummaryData? data,
  }) {
    return Summary(
      data_updated_at: data_updated_at ?? this.data_updated_at,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'data_updated_at': data_updated_at});
    result.addAll({'data': data.toMap()});

    return result;
  }

  factory Summary.fromMap(Map<String, dynamic> map) {
    return Summary(
      data_updated_at: map['data_updated_at'] ?? '',
      data: SummaryData.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Summary.fromJson(String source) => Summary.fromMap(json.decode(source));

  @override
  String toString() => 'Summary(data_updated_at: $data_updated_at, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Summary && other.data_updated_at == data_updated_at && other.data == data;
  }

  @override
  int get hashCode => data_updated_at.hashCode ^ data.hashCode;
}

class SummaryData {
  final String next_reviews_at;
  final List<Review> reviews;
  SummaryData({
    required this.next_reviews_at,
    required this.reviews,
  });

  SummaryData copyWith({
    String? next_reviews_at,
    List<Review>? reviews,
  }) {
    return SummaryData(
      next_reviews_at: next_reviews_at ?? this.next_reviews_at,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'next_reviews_at': next_reviews_at});
    result.addAll({'reviews': reviews.map((x) => x.toMap()).toList()});

    return result;
  }

  factory SummaryData.fromMap(Map<String, dynamic> map) {
    return SummaryData(
      next_reviews_at: map['next_reviews_at'] ?? '',
      reviews: List<Review>.from(map['reviews']?.map((x) => Review.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory SummaryData.fromJson(String source) => SummaryData.fromMap(json.decode(source));

  @override
  String toString() => 'Data(next_reviews_at: $next_reviews_at, reviews: $reviews)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SummaryData && other.next_reviews_at == next_reviews_at && listEquals(other.reviews, reviews);
  }

  @override
  int get hashCode => next_reviews_at.hashCode ^ reviews.hashCode;
}

class Review {
  final String available_at;
  final List<int> subject_ids;

  DateTime get availableAt {
    return DateTime.parse(available_at).toLocal();
  }

  Review({
    required this.available_at,
    required this.subject_ids,
  });

  Review copyWith({
    String? available_at,
    List<int>? subject_ids,
  }) {
    return Review(
      available_at: available_at ?? this.available_at,
      subject_ids: subject_ids ?? this.subject_ids,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'available_at': available_at});
    result.addAll({'subject_ids': subject_ids});

    return result;
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      available_at: map['available_at'] ?? '',
      subject_ids: List<int>.from(map['subject_ids']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));

  @override
  String toString() => 'Review(available_at: $available_at, subject_ids: $subject_ids)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Review && other.available_at == available_at && listEquals(other.subject_ids, subject_ids);
  }

  @override
  int get hashCode => available_at.hashCode ^ subject_ids.hashCode;
}

import 'dart:async';

import 'package:mockani/src/data/summary.dart';
import 'package:mockani/src/repositories/wanikani_repository.dart';

class SummaryProvider {
  final WanikaniRepository repository;

  final StreamController<SummaryProvider> _state = StreamController.broadcast();
  Stream<SummaryProvider> get stream => _state.stream;

  bool loading = false;
  Summary? summary;

  int get getSummaryCount => summary?.getReviews.length ?? 0;
  int get getTotalReviews {
    var total = 0;
    for (final review in getReviews) {
      total += review.subject_ids.length;
    }
    return total;
  }

  List<int> get getAvailableReviews {
    var result = <int>[];
    for (final review in getReviews) {
      if (review.isAvailableNow) {
        result.addAll(review.subject_ids);
      }
    }
    return result.toSet().toList();
  }

  List<int> get getUnavailableReviews {
    var result = <int>[];
    for (final review in getReviews) {
      if (!review.isAvailableNow) {
        result.addAll(review.subject_ids);
      }
    }
    return result.toSet().toList();
  }

  List<Review> get getReviews => summary?.getReviews ?? [];

  SummaryProvider(this.repository);

  Future<void> fetchSummary() async {
    if (loading) return;

    loading = true;
    _state.add(this);

    summary = await repository.getSummary();

    loading = false;
    _state.add(this);
  }
}

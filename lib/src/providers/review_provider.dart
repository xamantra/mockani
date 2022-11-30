import 'dart:async';
import 'dart:math';

import 'package:mockani/src/data/subject.dart';
import 'package:mockani/src/data/summary.dart';
import 'package:mockani/src/repositories/wanikani_repository.dart';
import 'package:mockani/src/utils/review_type.dart';

class ReviewProvider {
  final WanikaniRepository repository;

  final StreamController<ReviewProvider> _state = StreamController.broadcast();
  Stream<ReviewProvider> get stream => _state.stream;

  Summary? summary;
  List<int> reviewIds = [];

  bool loading = false;
  List<SubjectData> reviewSubjects = [];
  SubjectData get getCurrent => reviewSubjects[0];
  bool get completed => reviewIds.length == results.values.where((correct) => correct).length;
  Map<int, bool> results = {};

  bool nothingToReview = false;

  ReviewProvider(this.repository);

  Future<void> init(ReviewType reviewType) async {
    if (reviewIds.isNotEmpty) return;

    loading = true;
    _state.add(this);

    summary = await repository.getSummary();

    loading = false;
    _state.add(this);

    final reviews = summary?.getReviews ?? [];
    if (reviews.isEmpty) {
      nothingToReview = true;
      _state.add(this);
    }

    switch (reviewType) {
      case ReviewType.available:
        reviewIds = reviews.where((x) => x.isAvailableNow).expand((r) => r.subject_ids).toSet().toList();
        break;
      case ReviewType.advanceReview:
        reviewIds = reviews.where((x) => !x.isAvailableNow).expand((r) => r.subject_ids).toSet().toList();
        break;
    }

    if (reviews.isNotEmpty) {
      await loadItems();
    }
  }

  bool isPassed(int id) {
    return results[id] ?? false;
  }

  void saveResult(int id, bool correct) {
    results[id] = correct;
    reviewSubjects.removeWhere((r) => r.id == id);
    reAddMistakes();
    _state.add(this);
  }

  void reAddMistakes() {
    final hasMistake = results.values.any((correct) => !correct);
    if (reviewSubjects.isEmpty && hasMistake) {
      reviewIds = results.entries.where((item) => !item.value).map((e) => e.key).toList();
      results = {};
      loadItems();
    }
  }

  bool answerMeaning(SubjectData item, String answer) {
    final matched = item.getMeaningAnswers.any((a) => a.toLowerCase() == answer.toLowerCase());
    return matched;
  }

  bool answerReading(SubjectData item, String answer) {
    final matched = item.getReadingAnswers.any((a) => a.toLowerCase() == answer.toLowerCase());
    return matched;
  }

  Future<void> loadItems() async {
    if (loading) return;

    loading = true;
    _state.add(this);

    final seed = Random(DateTime.now().millisecondsSinceEpoch);

    reviewSubjects = (await repository.getSubjects(ids: reviewIds))..shuffle(seed);

    loading = false;
    _state.add(this);
  }
}

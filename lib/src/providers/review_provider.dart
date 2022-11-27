import 'dart:async';

import 'package:mockani/src/data/subject.dart';
import 'package:mockani/src/data/summary.dart';
import 'package:mockani/src/repositories/wanikani_repository.dart';

class ReviewProvider {
  final WanikaniRepository repository;

  final StreamController<ReviewProvider> _state = StreamController.broadcast();
  Stream<ReviewProvider> get stream => _state.stream;

  Summary? summary;
  List<int> shuffledReviews = [];

  bool loading = true;
  List<SubjectData> reviewSubjects = [];
  SubjectData get getCurrent => reviewSubjects[0];
  bool get completed => shuffledReviews.length == results.values.where((correct) => correct).length;
  Map<int, bool> results = {};

  bool nothingToReview = false;

  ReviewProvider(this.repository);

  Future<void> init(bool isAll) async {
    summary = await repository.getSummary();

    final reviews = summary?.getReviews ?? [];
    if (reviews.isEmpty) {
      nothingToReview = true;
      _state.add(this);
    }

    if (isAll) {
      shuffledReviews = reviews.expand((r) => r.subject_ids).toSet().toList()..shuffle();
    } else {
      shuffledReviews = reviews.where((x) => x.isAvailableNow).expand((r) => r.subject_ids).toSet().toList()..shuffle();
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
      shuffledReviews = results.entries.where((item) => !item.value).map((e) => e.key).toList();
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
    loading = true;
    _state.add(this);

    reviewSubjects = await repository.getSubjects(ids: shuffledReviews);

    loading = false;
    _state.add(this);
  }
}

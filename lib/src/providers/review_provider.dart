import 'dart:async';

import 'package:mockani/src/data/subject_details.dart';
import 'package:mockani/src/data/summary.dart';
import 'package:mockani/src/repositories/wanikani_repository.dart';

class ReviewProvider {
  final WanikaniRepository repository;

  final StreamController<ReviewProvider> _state = StreamController.broadcast();
  Stream<ReviewProvider> get stream => _state.stream;

  Summary? summary;
  List<int> shuffledReviews = [];
  List<int> loadedIds = [];

  /// This is the variables that should be used in the UI.
  bool loadingMore = true;
  List<SubjectDetails> reviewSubjects = [];
  SubjectDetails get getCurrent => reviewSubjects[0];
  bool get completed => shuffledReviews.length == results.length;
  Map<int, bool> results = {};

  ReviewProvider(this.repository);

  Future<void> init(bool isAll) async {
    summary = await repository.getSummary();

    final reviews = summary?.getReviews ?? [];

    if (isAll) {
      shuffledReviews = reviews.expand((r) => r.subject_ids).toSet().toList()..shuffle();
    } else {
      shuffledReviews = reviews.where((x) => x.isAvailableNow).expand((r) => r.subject_ids).toSet().toList()..shuffle();
    }

    await loadItems();
  }

  bool isPassed(int id) {
    return results[id] ?? false;
  }

  void saveResult(int id, bool correct) {
    results[id] = correct;
    reviewSubjects.removeWhere((r) => r.id == id);
    _state.add(this);
    loadItems();
  }

  bool answerMeaning(SubjectDetails item, String answer) {
    final matched = item.getMeaningAnswers.any((a) => a.toLowerCase() == answer.toLowerCase());
    return matched;
  }

  bool answerReading(SubjectDetails item, String answer) {
    final matched = item.getReadingAnswers.any((a) => a.toLowerCase() == answer.toLowerCase());
    return matched;
  }

  /// Load 3 review items per call.
  Future<void> loadItems() async {
    loadingMore = true;
    _state.add(this);

    var loaded = 0;
    for (var i = 0; i < shuffledReviews.length; i++) {
      if (loaded == 3) {
        loadingMore = false;
        _state.add(this);
        break;
      }
      final id = shuffledReviews[i];
      if (!loadedIds.any((l) => l == id)) {
        reviewSubjects.add(await repository.getSubjectDetail(id));
        loadedIds.add(id);
        loaded++;
        _state.add(this);
      } else {
        continue;
      }
    }
  }
}

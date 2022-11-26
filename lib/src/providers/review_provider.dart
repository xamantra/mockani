import 'dart:async';

import 'package:mockani/src/data/subject_details.dart';
import 'package:mockani/src/data/summary.dart';
import 'package:mockani/src/repositories/wanikani_repository.dart';

class ReviewProvider {
  final WanikaniRepository repository;

  final StreamController<ReviewProvider> _state = StreamController.broadcast();
  Stream<ReviewProvider> get stream => _state.stream;

  bool loadingMore = false;
  List<SubjectDetails> passedItems = [];
  Summary? summary;
  List<int> shuffledReviews = [];
  List<int> loadedIds = [];

  /// This is the variable that should be used in the UI.
  List<SubjectDetails> reviewSubjects = [];

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
    return passedItems.any((element) => element.id == id);
  }

  void passItem(int id) {
    passedItems.add(reviewSubjects.firstWhere((element) => element.id == id));
    loadItems();
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
      } else {
        continue;
      }
    }
  }
}

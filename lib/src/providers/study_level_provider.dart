import 'package:mockani/src/providers/review_provider.dart';
import 'package:mockani/src/utils/array_slice.dart';
import 'package:mockani/src/utils/review_type.dart';

class StudyLevelProvider extends ReviewProvider {
  StudyLevelProvider(
    super.repository,
    this.selectedLevels,
    this.selectedTypes,
  );

  final List<int> selectedLevels;
  final List<String> selectedTypes;

  List<List<int>> studySets = [];

  @override
  bool get completed => studySets.isEmpty;

  @override
  Future<void> init(ReviewType reviewType) async {
    if (reviewIds.isNotEmpty) return;

    loading = true;
    updateState();

    final subjectIds = await repository.getAssignments(
      levels: selectedLevels,
      subject_types: selectedTypes,
    );

    studySets = sliceListToRows(source: subjectIds..shuffle(), columnCount: 5);

    loading = false;
    updateState();

    if (subjectIds.isEmpty) {
      nothingToReview = true;
      updateState();
    }

    addSet();

    if (subjectIds.isNotEmpty) {
      await loadItems();
    }
  }

  void addSet() {
    if (studySets.isNotEmpty) {
      reviewIds = studySets[0];
    }
    updateState();
  }

  @override
  void validateResults() {
    final hasMistake = results.values.any((correct) => !correct);

    if (reviewSubjects.isEmpty) {
      results = {};
      if (hasMistake) {
        loadItems();
      } else {
        studySets.removeAt(0);
        addSet();
        loadItems();
      }
    }
  }
}

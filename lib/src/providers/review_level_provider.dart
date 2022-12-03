import 'package:mockani/src/providers/review_provider.dart';
import 'package:mockani/src/utils/review_type.dart';

class ReviewLevelProvider extends ReviewProvider {
  ReviewLevelProvider(
    super.repository,
    this.selectedLevels,
    this.selectedTypes,
  );

  final List<int> selectedLevels;
  final List<String> selectedTypes;

  @override
  Future<void> init(ReviewType reviewType) async {
    if (reviewIds.isNotEmpty) return;

    loading = true;
    updateState();

    final subjects = await repository.getSubjectsByLevel(
      levels: selectedLevels,
      subject_types: selectedTypes,
    );

    loading = false;
    updateState();

    if (subjects.isEmpty) {
      nothingToReview = true;
      updateState();
    }

    switch (reviewType) {
      case ReviewType.level:
        reviewIds = subjects.map((e) => e.id).toList();
        break;
      default:
        break;
    }

    if (subjects.isNotEmpty) {
      await loadItems();
    }
  }
}

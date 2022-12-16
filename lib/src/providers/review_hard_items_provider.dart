import 'package:mockani/src/providers/review_provider.dart';
import 'package:mockani/src/utils/review_type.dart';

class ReviewHardItemsProvider extends ReviewProvider {
  ReviewHardItemsProvider(super.repository);

  @override
  Future<void> init(ReviewType reviewType) async {
    if (reviewIds.isNotEmpty) return;

    loading = true;
    updateState();

    final subjectIds = await repository.getHardItems(percentLessThan: 100);

    loading = false;
    updateState();

    if (subjectIds.isEmpty) {
      nothingToReview = true;
      updateState();
    }

    reviewIds = subjectIds.map((e) => e.id).toList()..shuffle();
    updateState();

    if (subjectIds.isNotEmpty) {
      await loadItems();
    }
  }
}

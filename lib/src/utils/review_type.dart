import 'package:mockani/src/providers/review_level_provider.dart';
import 'package:mockani/src/providers/review_provider.dart';

enum ReviewType {
  available,
  advanceReview,
  level,
}

String getReviewTypeLabel(ReviewType type, {ReviewProvider? reviewProvider}) {
  switch (type) {
    case ReviewType.available:
      return "Mock WaniKani Review";
    case ReviewType.advanceReview:
      return "Advance Review";
    case ReviewType.level:
      if (reviewProvider != null && reviewProvider is ReviewLevelProvider) {
        return "Review Level ${reviewProvider.selectedLevels.join(',')}";
      }
      return "Level Review";
  }
}

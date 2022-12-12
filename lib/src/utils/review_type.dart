import 'package:mockani/src/providers/study_level_provider.dart';
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
      if (reviewProvider != null && reviewProvider is StudyLevelProvider) {
        var types = "(${reviewProvider.selectedTypes.join(', ')})";
        if (reviewProvider.selectedTypes.length == 3) {
          types = "";
        }
        return "Study Level ${reviewProvider.selectedLevels.join(', ')} $types".trim();
      }
      return "Level Review";
  }
}

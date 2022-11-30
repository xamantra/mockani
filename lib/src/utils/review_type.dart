enum ReviewType {
  available,
  advanceReview,
}

String getReviewTypeLabel(ReviewType type) {
  switch (type) {
    case ReviewType.available:
      return "Mock WaniKani Review";
    case ReviewType.advanceReview:
      return "Advance Review";
  }
}

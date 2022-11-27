// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// // ignore_for_file: avoid_print

// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockani/src/providers/review_provider.dart';
// import 'package:mockani/src/repositories/wanikani_repository.dart';

// import 'token.dart';

// void main() {
//   test('Review loads 3 items per call (ALL)', () async {
//     final reviewProvider = ReviewProvider(const WanikaniRepository(TEST_TOKEN));

//     await reviewProvider.init(true);
//     final max = reviewProvider.shuffledReviews.length;
//     final loop = ((max ~/ 3) + 1).clamp(0, 10);

//     _testReviewItems(reviewProvider, 3 > max ? max : 3);

//     for (var i = 2; i < loop; i++) {
//       await reviewProvider.loadItems();
//       final expected = i * 3;
//       _testReviewItems(reviewProvider, expected > max ? max : expected);
//     }
//   }, timeout: const Timeout(Duration(minutes: 60)));

//   test('Review loads 3 items per call (only available)', () async {
//     final reviewProvider = ReviewProvider(const WanikaniRepository(TEST_TOKEN));

//     await reviewProvider.init(false);
//     final max = reviewProvider.shuffledReviews.length;
//     final loop = ((max ~/ 3) + 1).clamp(0, 10);

//     _testReviewItems(reviewProvider, 3 > max ? max : 3);

//     for (var i = 2; i < loop; i++) {
//       await reviewProvider.loadItems();
//       final expected = i * 3;
//       _testReviewItems(reviewProvider, expected > max ? max : expected);
//     }
//   }, timeout: const Timeout(Duration(minutes: 60)));
// }

// void _testReviewItems(ReviewProvider provider, int expectedLength) {
//   var reviews = provider.reviewSubjects.toSet().toList();
//   print("expect(${reviews.length}, $expectedLength)");
//   expect(reviews.length, expectedLength);
//   for (var i = 0; i < reviews.length; i++) {
//     expect(reviews[i].id, provider.shuffledReviews[i]);
//   }
// }

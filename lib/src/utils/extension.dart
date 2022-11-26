import 'package:string_similarity/string_similarity.dart';

extension StringExtension on String {
  double similarity(String other) {
    final dice = similarityTo(other);

    var similarity = 0;
    var expected = other.length > length ? other.length : length;

    for (var i = 0; i < length; i++) {
      if (i <= other.length - 1) {
        if (other[i] == this[i]) {
          similarity++;
        }
      } else {
        break;
      }
    }

    var percent = (similarity / expected);

    if (dice > percent) return dice;
    return percent;
  }
}

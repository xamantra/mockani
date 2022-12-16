// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/data/review_stats.dart';
import 'package:mockani/src/data/subject.dart';
import 'package:mockani/src/data/summary.dart';
import 'package:mockani/src/data/user.dart';
import 'package:mockani/src/utils/storage.dart';

class WanikaniRepository {
  const WanikaniRepository([this._token]);

  final String? _token;

  Future<User> getUser([String? token]) async {
    try {
      final wanikaniToken = _token ?? token ?? await getString(WANIKANI_TOKEN) ?? '';
      final response = await http.get(
        Uri.parse("https://api.wanikani.com/v2/user"),
        headers: {
          "Authorization": "Bearer $wanikaniToken",
        },
      );
      final user = User.fromJson(response.body);
      saveString(WANIKANI_TOKEN, wanikaniToken);
      return user;
    } catch (e) {
      return User.empty();
    }
  }

  Future<Summary?> getSummary() async {
    try {
      final wanikaniToken = _token ?? await getString(WANIKANI_TOKEN);
      if (wanikaniToken != null) {
        final response = await http.get(
          Uri.parse("https://api.wanikani.com/v2/summary"),
          headers: {
            "Authorization": "Bearer $wanikaniToken",
          },
        );
        return Summary.fromJson(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<SubjectData>> getSubjects({
    List<int>? levels,
    List<int>? ids,
    List<String>? types,
  }) async {
    try {
      final wanikaniToken = _token ?? await getString(WANIKANI_TOKEN);

      var url = "https://api.wanikani.com/v2/subjects?";
      final parameters = <String>[];
      if (levels != null && levels.isNotEmpty) {
        parameters.add("levels=${levels.join(",")}");
      }
      if (ids != null && ids.isNotEmpty) {
        parameters.add("ids=${ids.join(",")}");
      }
      if (types != null && types.isNotEmpty) {
        parameters.add("types=${types.join(",")}");
      }
      final response = await http.get(
        Uri.parse(url + parameters.join("&")),
        headers: {
          "Authorization": "Bearer $wanikaniToken",
        },
      );
      final subjects = Subjects.fromJson(response.body);
      return subjects.data;
    } catch (e) {
      return [];
    }
  }

  /// Return subject IDs of specific levels where the lessons are completed.
  Future<List<int>> getAssignments({
    required List<int> levels,
    List<String> subject_types = const ["radical", "kanji", "vocabulary"],
  }) async {
    try {
      final wanikaniToken = _token ?? await getString(WANIKANI_TOKEN);

      var url = "https://api.wanikani.com/v2/assignments?";
      final parameters = <String>["started=true"];
      if (levels.isNotEmpty) {
        parameters.add("levels=${levels.join(",")}");
      }
      if (subject_types.isNotEmpty) {
        parameters.add("subject_types=${subject_types.join(",")}");
      }
      final response = await http.get(
        Uri.parse(url + parameters.join("&")),
        headers: {
          "Authorization": "Bearer $wanikaniToken",
        },
      );
      final list = jsonDecode(response.body)["data"] as List;
      final ids = list.map((item) => item["data"]["subject_id"] as int).toList();
      return ids;
    } catch (e) {
      return [];
    }
  }

  Future<List<SubjectData>> getHardItems({
    String? next,
    List<ReviewStat> currentResults = const [],
    int percentLessThan = 90,
    int count = 30,
  }) async {
    try {
      var results = List<ReviewStat>.from(currentResults);

      final wanikaniToken = _token ?? await getString(WANIKANI_TOKEN);
      final response = await http.get(
        Uri.parse(next ?? "https://api.wanikani.com/v2/review_statistics?percentages_less_than=$percentLessThan"),
        headers: {
          "Authorization": "Bearer $wanikaniToken",
        },
      );

      final reviewStatistics = ReviewStatistics.fromJson(response.body);
      final newResults = reviewStatistics.data.map((e) => e.data).toList();
      if (newResults.isNotEmpty) {
        results.addAll(newResults);
      }

      if (reviewStatistics.pages.next_url != null) {
        return await getHardItems(
          next: reviewStatistics.pages.next_url,
          currentResults: results,
          percentLessThan: percentLessThan,
          count: count,
        );
      }

      results.sort((a, b) => a.percentage_correct.compareTo(b.percentage_correct));
      final filterHardItems = results.map((e) => e.subject_id).toList().sublist(0, count.clamp(0, results.length));

      final finalResults = await getSubjects(ids: filterHardItems);
      return finalResults;
    } catch (e) {
      return [];
    }
  }
}

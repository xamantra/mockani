import "package:http/http.dart" as http;
import 'package:http/http.dart' show Response;
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/data/subject_details.dart';
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

  Future<SubjectDetails> getSubjectDetail(int id) async {
    try {
      final wanikaniToken = _token ?? await getString(WANIKANI_TOKEN);
      final response = await http.get(
        Uri.parse("https://api.wanikani.com/v2/subjects/$id"),
        headers: {
          "Authorization": "Bearer $wanikaniToken",
        },
      );
      if (response.body.isEmpty) throw response;
      return SubjectDetails.fromJson(response.body);
    } on Response catch (e) {
      rethrow;
    }
  }

  Future<List<SubjectDetails>> getSubjectItems(List<int> subjectIds) async {
    try {
      var result = <SubjectDetails>[];
      for (final id in subjectIds) {
        result.add(await getSubjectDetail(id));
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }
}

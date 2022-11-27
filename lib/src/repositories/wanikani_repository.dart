import "package:http/http.dart" as http;
import 'package:mockani/src/constants/keys.dart';
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
    List<int>? types,
  }) async {
    try {
      final wanikaniToken = _token ?? await getString(WANIKANI_TOKEN);

      var url = "https://api.wanikani.com/v2/subjects?";
      if (levels != null && levels.isNotEmpty) {
        url += "levels=${levels.join(",")}";
      } else if (ids != null && ids.isNotEmpty) {
        url += "ids=${ids.join(",")}";
      } else if (types != null && types.isNotEmpty) {
        url += "types=${types.join(",")}";
      }
      final response = await http.get(
        Uri.parse(url),
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
}

import "package:http/http.dart" as http;
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/data/summary.dart';
import 'package:mockani/src/data/user.dart';
import 'package:mockani/src/utils/storage.dart';

class WanikaniRepository {
  const WanikaniRepository();
  
  Future<User> getUser([String? token]) async {
    try {
      final wanikaniToken = token ?? await getString(WANIKANI_TOKEN) ?? '';
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
      final wanikaniToken = await getString(WANIKANI_TOKEN);
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
}

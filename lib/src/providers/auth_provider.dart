import 'dart:async';

import 'package:mockani/src/data/user.dart';
import 'package:mockani/src/repositories/wanikani_repository.dart';

class AuthProvider {
  final WanikaniRepository repository;

  final StreamController<AuthProvider> _state = StreamController.broadcast();
  Stream<AuthProvider> get stream => _state.stream;

  bool loading = false;
  bool loggedIn = false;
  User user = User.empty();

  AuthProvider(this.repository) {
    login();
  }

  Future<void> login([String? token]) async {
    if (loading) return;

    loading = true;
    _state.add(this);

    user = await repository.getUser(token);

    loading = false;
    loggedIn = user.data.username.isNotEmpty;
    _state.add(this);
  }
}

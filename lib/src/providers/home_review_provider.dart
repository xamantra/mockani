import 'dart:async';

class HomeReviewProvider {
  final StreamController<HomeReviewProvider> _state = StreamController.broadcast();
  Stream<HomeReviewProvider> get stream => _state.stream;

  List<int> selectedLevels = [];
  List<String> selectedTypes = [];

  void selectLevelAndType({
    required List<int> levels,
    required List<String> types,
  }) {
    selectedLevels = levels;
    selectedTypes = types;

    _state.add(this);
  }

  void clearSelection() {
    selectedLevels = [];
    selectedLevels = [];

    _state.add(this);
  }
}

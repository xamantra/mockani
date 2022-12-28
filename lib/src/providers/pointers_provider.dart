import 'dart:async';

import 'package:mockani/src/data/subject.dart';
import 'package:mockani/src/repositories/wanikani_repository.dart';

class PointersProvider {
  PointersProvider(this.wanikaniRepository);

  final StreamController<PointersProvider> _state = StreamController.broadcast();
  Stream<PointersProvider> get stream => _state.stream;

  final WanikaniRepository wanikaniRepository;

  List<SubjectData> reviewSubjects = [];
  bool loading = false;

  void updateState() {
    _state.add(this);
  }

  Future<void> loadSubjects(List<int> subjects) async {
    loading = true;
    updateState();

    reviewSubjects = await wanikaniRepository.getSubjects(ids: subjects);
    loading = false;
    updateState();
  }
}

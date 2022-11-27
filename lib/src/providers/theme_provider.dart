import 'dart:async';

class ThemeProvider {
  bool darkMode = true;

  final StreamController<ThemeProvider> _state = StreamController.broadcast();
  Stream<ThemeProvider> get stream => _state.stream;

  ThemeProvider([this.darkMode = true]);

  void switchTheme([bool? isDarkMode]) {
    darkMode = (isDarkMode) ?? !darkMode;
    _state.add(this);
  }
}

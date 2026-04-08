import 'dart:async';

class SearchDebouncer {
  final Duration delay;
  Timer? _timer;

  SearchDebouncer({this.delay = const Duration(milliseconds: 500)});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

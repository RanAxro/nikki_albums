import "path.dart";
import "dart:async";
import "package:watcher/watcher.dart";


class QuietDirectoryWatcher{
  final Path path;
  final void Function() listener;
  final Duration quietAfter;

  Timer? _timer;
  StreamSubscription<WatchEvent>? _subscription;

  QuietDirectoryWatcher({
    required this.path,
    required this.listener,
    this.quietAfter = const Duration(milliseconds: 200),
  }){
    final watcher = DirectoryWatcher(path.path);
    _subscription = watcher.events.listen(_onEvent);
  }

  void _onEvent(WatchEvent event){
    _timer?.cancel();
    _timer = Timer(quietAfter, listener);
  }

  void cancel(){
    _timer?.cancel();
    _subscription?.cancel();
  }
}

import "package:riverpod_annotation/riverpod_annotation.dart";

part "state.g.dart";

@Riverpod(keepAlive: true)
class TopWindow extends _$TopWindow{
  @override
  bool build() => false;

  void toggle(){
    state = !state;
  }
}
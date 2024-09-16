import 'package:bloc/bloc.dart';

class CustomCache extends Cubit<Map<String, dynamic>> {
  CustomCache() : super({});

  void update(String key, dynamic value) {
    state[key].add(value);
    emit(state);
  }

  void updateSimple(String key, dynamic value) {
    state[key] = value;
    emit(state);
  }

  void add(Map<String, dynamic> pair) {
    state.addAll(pair);
    emit(state);
  }

  void remove(String key) {
    state.remove(key);
    emit(state);
  }
}

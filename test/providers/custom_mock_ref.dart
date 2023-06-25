import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomMockRef extends Ref {
  @override
  // TODO: implement container
  ProviderContainer get container => throw UnimplementedError();

  @override
  bool exists(ProviderBase<Object?> provider) {
    // TODO: implement exists
    throw UnimplementedError();
  }

  @override
  void invalidate(ProviderOrFamily provider) {
    // TODO: implement invalidate
  }

  @override
  void invalidateSelf() {
    // TODO: implement invalidateSelf
  }

  @override
  ProviderSubscription<T> listen<T>(
    AlwaysAliveProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
  }) {
    // TODO: implement listen
    throw UnimplementedError();
  }

  @override
  void listenSelf(void Function(Object? previous, Object? next) listener,
      {void Function(Object error, StackTrace stackTrace)? onError}) {
    // TODO: implement listenSelf
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void onAddListener(void Function() cb) {
    // TODO: implement onAddListener
  }

  @override
  void onCancel(void Function() cb) {
    // TODO: implement onCancel
  }

  @override
  void onDispose(void Function() cb) {
    // TODO: implement onDispose
  }

  @override
  void onRemoveListener(void Function() cb) {
    // TODO: implement onRemoveListener
  }

  @override
  void onResume(void Function() cb) {
    // TODO: implement onResume
  }

  @override
  read<T>(ProviderListenable<T> provider) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  refresh<T>(Refreshable<T> provider) {
    // TODO: implement refresh
    throw UnimplementedError();
  }

  @override
  watch<T>(AlwaysAliveProviderListenable<T> provider) {
    // TODO: implement watch
    throw UnimplementedError();
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';

class ComputeLock {
  static final ComputeLock _instance = ComputeLock._();

  factory ComputeLock() => _instance;

  ComputeLock._();

  Future<void>? _currentTask;

  Future<R> submit<Q, R>(
    Future<R> Function(Q) callback,
    Q message, {
    String debugLabel = 'ComputeTask',
  }) async {
    await _currentTask?.timeout(const Duration(milliseconds: 1));
    final completer = Completer<R>.sync();
    final future = compute(callback, message, debugLabel: debugLabel);
    _currentTask = future.then((value) => null);
    future
        .then((result) {
          if (!completer.isCompleted) completer.complete(result);
        })
        .catchError((error) {
          if (!completer.isCompleted) completer.completeError(error);
        });
    return completer.future;
  }
}

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    log('onCreate -- ${bloc.runtimeType}', name: 'BLoC');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    log('onEvent -- ${bloc.runtimeType}: $event', name: 'BLoC');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log(
      'onChange -- ${bloc.runtimeType}\n'
      '  current : ${change.currentState.runtimeType}\n'
      '  next    : ${change.nextState.runtimeType}',
      name: 'BLoC',
    );
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    log(
      'onTransition -- ${bloc.runtimeType}\n'
      '  event   : ${transition.event.runtimeType}\n'
      '  current : ${transition.currentState.runtimeType}\n'
      '  next    : ${transition.nextState.runtimeType}',
      name: 'BLoC',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log(
      'onError -- ${bloc.runtimeType}: $error',
      name: 'BLoC',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    log('onClose -- ${bloc.runtimeType}', name: 'BLoC');
  }
}

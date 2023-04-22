import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetStates> {
  Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? status;

  InternetCubit() : super(InternetStates.initial) {
    status = Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.wifi ||
          event == ConnectivityResult.mobile) {
        emit(InternetStates.connected);
      } else {
        emit(InternetStates.dissconnected);
      }
    });
  }

  @override
  Future<void> close() {
    status!.cancel();
    return super.close();
  }
}

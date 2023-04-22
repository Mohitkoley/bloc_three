import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';
part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  StreamSubscription? connection;

  InternetBloc() : super(InternetInitial()) {
    on<InternetConnected>((event, emit) => emit(InternateGained()));
    on<InternetDisconnected>(
      (event, emit) => emit(InternateLost()),
    );

    connection = Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.wifi ||
          event == ConnectivityResult.mobile) {
        add(InternetConnected());
      } else if (event == ConnectivityResult.none) {
        add(InternetDisconnected());
      }
    });
  }

  @override
  Future<void> close() {
    connection!.cancel();
    return super.close();
  }
}

part of 'internet_bloc.dart';

@immutable
abstract class InternetEvent {}

class InternetConnected extends InternetEvent {}

class InternetDisconnected extends InternetEvent {}

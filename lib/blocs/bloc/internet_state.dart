part of 'internet_bloc.dart';

@immutable
abstract class InternetState {}

class InternetInitial extends InternetState {}

class InternateGained extends InternetState {}

class InternateLost extends InternetState {}

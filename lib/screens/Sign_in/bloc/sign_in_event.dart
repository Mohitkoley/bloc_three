part of 'sign_in_bloc.dart';

@immutable
abstract class SignInEvent {}

class SignInTextChangedEvent extends SignInEvent {
  final String emailValue;
  final String passwordValue;
  SignInTextChangedEvent(
      {required this.emailValue, required this.passwordValue});
}

class SignInSubmittedEvent extends SignInEvent {
  final String email;
  final String password;
  SignInSubmittedEvent({required this.email, required this.password});
}

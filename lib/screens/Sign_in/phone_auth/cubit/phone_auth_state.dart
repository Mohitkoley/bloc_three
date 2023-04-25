part of 'phone_auth_cubit.dart';

@immutable
abstract class PhoneAuthCubitState {}

class PhoneAuthInitial extends PhoneAuthCubitState {}

class AuthLoadingState extends PhoneAuthCubitState {}

class AuthCodeVerified extends PhoneAuthCubitState {}

class AuthCodeSend extends PhoneAuthCubitState {}

class AuthGotVerificationId extends PhoneAuthCubitState {}

class AuthLoggedinState extends PhoneAuthCubitState {
  final User firebaseUser;

  AuthLoggedinState({required this.firebaseUser});
}

class AuthLoggedOutState extends PhoneAuthCubitState {}

class AuthErrorState extends PhoneAuthCubitState {
  final String error;
  AuthErrorState(this.error);
}

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<SignInTextChangedEvent>((event, emit) {
      if (event.emailValue.isEmpty || event.emailValue == "") {
        emit(SignInErrorState(errorMessage: "Email is empty"));
      } else if (!EmailValidator.validate(event.emailValue)) {
        emit(SignInErrorState(errorMessage: "Email is not valid"));
      } else if (event.passwordValue.length < 8) {
        emit(SignInErrorState(errorMessage: "Password is not valid"));
      } else {
        emit(SignInValidState());
      }
    });
    on<SignInSubmittedEvent>((event, emit) {
      emit(SignInLoadingState());
    });
  }
}

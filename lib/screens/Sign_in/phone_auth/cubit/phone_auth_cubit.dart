import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthCubitState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PhoneAuthCubit() : super(PhoneAuthInitial()) {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        emit(AuthLoggedOutState());
      } else {
        emit(AuthLoggedinState(firebaseUser: user));
      }
    });
  }

  String? _verificationId;

  void sendOtp(String phoneNumber) async {
    emit(AuthLoadingState());
    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, forceResendingToken) {
        emit(AuthGotVerificationId());
        _verificationId = verificationId;
        emit(AuthCodeSend());
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
        signinWithPhone(phoneAuthCredential);
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(AuthErrorState(e.message!));
      },
    );
  }

  void verifyOtp(String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: otp);
    signinWithPhone(credential);
  }

  void signinWithPhone(PhoneAuthCredential credential) async {
    try {
      emit(AuthLoadingState());
      await _auth.signInWithCredential(credential);
      emit(AuthLoggedinState(firebaseUser: _auth.currentUser!));
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message!));
    }
  }

  void signOut() async {
    await _auth.signOut();
    emit(AuthLoggedOutState());
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gram/models/models.dart';
import 'package:flutter_gram/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit({@required AuthRepository authRepository}) 
    : _authRepository = authRepository,
      super(SignupState.initial());

  void usernameChanged(String username) {
    emit(state.copyWith(username: username, status: SignupStatus.initial));
  }

  void emailChanged(String email) {
    emit(state.copyWith(email: email, status: SignupStatus.initial));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password, status: SignupStatus.initial));
  }

  void signupWithCredentials() async {

    if(!state.isFormValid || state.status == SignupStatus.submitting) return;

    try {

      emit(state.copyWith(status: SignupStatus.submitting));

      await _authRepository.signUpWithEmailAndPassword(
        username: state.username,
        email: state.email, 
        password: state.password
      );

      emit(state.copyWith(status: SignupStatus.success));

    } 
    on Failure catch(err) {
      emit(state.copyWith(failure: err, status: SignupStatus.error));
    }

  }
}

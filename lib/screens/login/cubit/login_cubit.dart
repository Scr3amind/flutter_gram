import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gram/models/models.dart';
import 'package:flutter_gram/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({@required AuthRepository authRepository}) 
    : _authRepository = authRepository,
      super(LoginState.initial());

  void emailChanged(String email) {
    emit(state.copyWith(email: email, status: LoginStatus.initial));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password, status: LoginStatus.initial));
  }

  void logInWithCredentials() async {

    if(!state.isFormValid || state.status == LoginStatus.submitting) return;

    try {

      emit(state.copyWith(status: LoginStatus.submitting));

      await _authRepository.logInWithEmailAndPassword(
        email: state.email, 
        password: state.password
      );

      emit(state.copyWith(status: LoginStatus.success));

    } 
    on Failure catch(err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }

  }
}

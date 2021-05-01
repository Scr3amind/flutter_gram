import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gram/models/models.dart';
import 'package:flutter_gram/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'search_user_state.dart';

class SearchUserCubit extends Cubit<SearchUserState> {
  final UserRepository _userRepository;

  SearchUserCubit({@required UserRepository userRepository}) 
    : _userRepository = userRepository, 
      super(SearchUserState.initial());
  
  void searchUsers(String query) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final users = await _userRepository.searchUsers(query: query);
      emit(state.copyWith(users: users,status: SearchStatus.loaded));
    }
    catch (err) {
      emit(state.copyWith(
        status: SearchStatus.error, 
        failure: Failure(message: 'Something went wrong. Please try again.')
        )
      );
    }
  }

  void clearSearch() {
    emit(state.copyWith(users: [], status: SearchStatus.initial));
  }

}

part of 'search_user_cubit.dart';

enum SearchStatus {initial, loading, loaded, error}

class SearchUserState extends Equatable {
  final List<User> users;
  final SearchStatus status;
  final Failure failure;

  const SearchUserState({
    @required this.users, 
    @required this.status, 
    @required this.failure
  });

  factory SearchUserState.initial() {
    return const SearchUserState(
      users: [], 
      status: SearchStatus.initial, 
      failure: Failure()
    );
  }

  @override
  List<Object> get props => [
    users,
    status,
    failure
  ];

  SearchUserState copyWith({
    List<User> users,
    SearchStatus status,
    Failure failure,
  }) {
    print(status);
    return SearchUserState(
      users: users ?? this.users,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}

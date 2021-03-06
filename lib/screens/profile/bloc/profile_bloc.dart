import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gram/blocs/blocs.dart';
import 'package:flutter_gram/models/models.dart';
import 'package:flutter_gram/repositories/post/post_repository.dart';
import 'package:flutter_gram/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;
  final PostRepository _postRepository;

  StreamSubscription<List<Future<Post>>> _postSubscription;

  ProfileBloc({
    @required UserRepository userRepository,
    @required AuthBloc authBloc,
    @required PostRepository postRepository
  }) 
  : _userRepository = userRepository, 
    _authBloc = authBloc, 
    _postRepository = postRepository,
    super(ProfileState.initial());

  @override
  Future<void> close() {
    _postSubscription.cancel();
    return super.close();
  }

  @override
  Stream<ProfileState> mapEventToState( ProfileEvent event) async* {
    if(event is ProfileLoadUser) {
      yield* _mapProfileLoadUserToState(event);
    }
    else if(event is ProfileToggleGridView) {
      yield* _mapProfileToggleGridViewToState(event);
    }
    else if(event is ProfileUpdatePosts) {
      yield * _mapProfileUpdatePostsToState(event);
    }
    else if(event is ProfileFollowUser) {
      yield * _mapProfileFollowUserToState();
    }
    else if(event is ProfileUnfollowUser) {
      yield * _mapProfileUnfollowUserToState();
    }
  }

  Stream<ProfileState> _mapProfileLoadUserToState(ProfileLoadUser event) async* {
    
    yield state.copyWith(status: ProfileStatus.loading);

    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
      final isCurrentUser = _authBloc.state.user.uid == event.userId;
      final isFollowing = await _userRepository.isFollowing(
        userId: _authBloc.state.user.uid, 
        otherUserId: event.userId
      );

      _postSubscription?.cancel();
      _postSubscription = _postRepository.getUserPosts(userId: event.userId).listen((posts) async {
        final allPosts = await Future.wait(posts);
        add(ProfileUpdatePosts(posts: allPosts));
       });

      yield state.copyWith(
        user: user,
        isCurrentUser: isCurrentUser,
        isFollowing: isFollowing,
        status: ProfileStatus.loaded
      );

    } catch (err) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: const Failure(message: 'We were unable to load this profile.')
      );
    }
  }

  Stream<ProfileState> _mapProfileToggleGridViewToState(ProfileToggleGridView event) async* {
    yield state.copyWith(isGridView: event.isGridView);
  }

  Stream<ProfileState> _mapProfileUpdatePostsToState(ProfileUpdatePosts event) async* {
    yield state.copyWith(posts: event.posts);
  }

  Stream<ProfileState> _mapProfileFollowUserToState() async* {
    try {
      _userRepository.followUser(
        userId: _authBloc.state.user.uid, 
        followUserId: state.user.id
      );
      final updatedUser = state.user.copyWith(followers: state.user.followers + 1);
      yield state.copyWith(user: updatedUser, isFollowing: true);
    } 
    catch (err) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: const Failure(message: 'Something went wrong! Please try again.')
      );
    }
  }

  Stream<ProfileState> _mapProfileUnfollowUserToState() async* {
    try {
      _userRepository.followUser(
        userId: _authBloc.state.user.uid, 
        followUserId: state.user.id
      );
      final updatedUser = state.user.copyWith(followers: state.user.followers - 1);
      yield state.copyWith(user: updatedUser, isFollowing: false);
    } 
    catch (err) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: const Failure(message: 'Something went wrong! Please try again.')
      );
    }
  }

}

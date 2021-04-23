import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gram/blocs/blocs.dart';
import 'package:flutter_gram/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter_gram/screens/profile/widgets/widgets.dart';
import 'package:flutter_gram/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if(state.status == ProfileStatus.error) {
          showDialog(
            context: context, 
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.user.username),
            actions: [
              if(state.isCurrentUser)
                IconButton(
                  icon: const Icon(Icons.exit_to_app), 
                  onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested())
                )
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _headerSection(state),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0
                      ),
                      child: ProfileInfo(
                        username: state.user.username,
                        bio: state.user.bio
                      ),
                    )
                    
                  ],
                ),
              )
            ],
          )
        );
      },
    );
  }

  Padding _headerSection(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0),
      child: Row(
        children: [
          UserProfileImage(
            radius: 40.0, 
            profileImageUrl: state.user.profileImageUrl
          ),

          ProfileStats(
            isCurrentUser: state.isCurrentUser,
            isFollowing: state.isFollowing,
            posts: 0,// post: state.posts,length
            followers: state.user.followers,
            following: state.user.following
          )
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gram/blocs/blocs.dart';
import 'package:flutter_gram/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter_gram/screens/profile/widgets/widgets.dart';
import 'package:flutter_gram/widgets/widgets.dart';

class ProfileScreenArgs {
  final String userId;

  ProfileScreenArgs({@required this.userId});
}
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            centerTitle: true,
            actions: [
              if(state.isCurrentUser)
                IconButton(
                  icon: const Icon(Icons.exit_to_app), 
                  onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested())
                )
            ],
          ),
          body: _buildBody(context, state)
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    switch (state.status) {
      
      case ProfileStatus.loading:
        return Center(
          child: CircularProgressIndicator(),
        );
      
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context
              .read<ProfileBloc>()
              .add(ProfileLoadUser(userId: state.user.id));
            return true;
          },
          child: CustomScrollView(
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
              ),

              SliverToBoxAdapter(
                child: TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(icon: Icon(Icons.grid_on_rounded, size: 28.0)),
                    Tab(icon: Icon(Icons.list_rounded, size: 28.0)),
                  ],
                  indicatorWeight: 3.0,
                  onTap: (i) => context
                    .read<ProfileBloc>()
                    .add(ProfileToggleGridView(isGridView: i == 0)),
                ),
              ),
              state.isGridView
              ? SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = state.posts[index];
                      return GestureDetector(
                        onTap: () {},
                        child: CachedNetworkImage(
                          imageUrl: post.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    childCount: state.posts.length
                  ), 
                )

              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = state.posts[index];
                      return PostView(post: post, isLiked: false);
                    },
                    childCount: state.posts.length
                  )
                )

            ],
          ),
        );
    }
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
            posts: state.posts.length,
            followers: state.user.followers,
            following: state.user.following
          )
        ],
      ),
    );
  }
}

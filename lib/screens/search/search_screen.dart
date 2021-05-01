import 'package:flutter/material.dart';
import 'package:flutter_gram/screens/profile/profile_screen.dart';
import 'package:flutter_gram/screens/search/cubit/search_user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gram/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _textController,
            decoration: InputDecoration(
              fillColor: Colors.grey[200],
              filled: true,
              border: InputBorder.none,
              hintText: 'Search Users',
              suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    context.read<SearchUserCubit>().clearSearch();
                    _textController.clear();
                  }),
            ),
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                context.read<SearchUserCubit>().searchUsers(value.trim());
              }
            },
          ),
        ),
        body: BlocBuilder<SearchUserCubit, SearchUserState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.error:

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      state.failure.message,
                      style: const TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,
                      ),
                    ),
                );

              case SearchStatus.loading:

                return const Center(
                  child: CircularProgressIndicator(),
                );

              case SearchStatus.loaded:

                  return state.users.isNotEmpty
                    ? ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (BuildContext context, int index) {
                        final user = state.users[index];
                        return ListTile(
                          leading: UserProfileImage(
                            radius: 22.0, 
                            profileImageUrl: user.profileImageUrl
                          ),
                          title: Text(
                            user.username,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          onTap: () => Navigator.of(context).pushNamed(
                            '/profile', 
                            arguments: ProfileScreenArgs(userId: user.id)
                          ),
                        );
                      }
                    )
                  : const SizedBox.shrink();
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

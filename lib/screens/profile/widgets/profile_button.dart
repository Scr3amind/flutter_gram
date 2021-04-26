import 'package:flutter/material.dart';
import 'package:flutter_gram/screens/edit_profile/edit_profile_screen.dart';

class ProfileButton extends StatelessWidget {

  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileButton({
    Key key, 
    this.isCurrentUser, 
    this.isFollowing
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
          ? TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/editProfile', 
                arguments: EditProfileScreenArgs(context: context)
              );
            },
            child: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16.0),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          )
          : TextButton(
            onPressed: () {},
            child: Text(
              isFollowing ? 'Unfollow' : 'Follow',
              style: TextStyle(fontSize: 16.0),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                isFollowing ? Colors.grey[300] :Theme.of(context).primaryColor
              ),
              foregroundColor: MaterialStateProperty.all<Color>(
                isFollowing ? Colors.black : Colors.white
              ),
            ),
          );
  }
}
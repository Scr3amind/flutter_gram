import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gram/helpers/helpers.dart';
import 'package:flutter_gram/models/models.dart';
import 'package:flutter_gram/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:flutter_gram/widgets/error_dialog.dart';
import 'package:flutter_gram/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfileScreenArgs {
  final BuildContext context;

  EditProfileScreenArgs({@required this.context});
}

class EditProfileScreen extends StatelessWidget {
  final User user;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditProfileScreen({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            
            if(state.status == EditProfileStatus.sucess) {
              Navigator.of(context).pop();
            }
            else if(state.status == EditProfileStatus.error) {
              showDialog(
                context: context, 
                builder: (context) => ErrorDialog(content: state.failure.message)
              );
            }

          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if(state.status == EditProfileStatus.submitting) 
                    const LinearProgressIndicator(),
                
                  const SizedBox(height: 32.0,),
                  
                  GestureDetector(
                    onTap: () => _selectProfileImage(context),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                
                        UserProfileImage(
                          radius: 80.0, 
                          profileImageUrl: user.profileImageUrl,
                          profileImage: state.profileImage,
                        ),

                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(100.0)
                          ),
                        ),
                        
                        Icon(
                          Icons.add_a_photo,
                          color: Colors.white.withOpacity(0.8),
                          size: 50,
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _EditProfileForm(formKey: _formKey, user: user),
                        
                        const SizedBox(height: 28),
                        
                        MaterialButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            _submitForm(context, state.status == EditProfileStatus.submitting);
                          },
                          child: Text('Update'),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            );
          },
        )
      ),
    );
  }

  void _selectProfileImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context, 
      cropStyle: CropStyle.circle, 
      title: 'Profile Image'
    );

    if(pickedFile != null) {
      context
        .read<EditProfileCubit>()
        .profileImageChanged(pickedFile);
    }

  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if(_formKey.currentState.validate() && !isSubmitting) {
      context.read<EditProfileCubit>().submit();
    }
  }

}

class _EditProfileForm extends StatelessWidget {
  const _EditProfileForm({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.user,
  }) : _formKey = formKey, super(key: key);

  final GlobalKey<FormState> _formKey;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          TextFormField(
            initialValue: user.username,
            decoration: InputDecoration(hintText: 'Username'),
            onChanged: (username) => 
              context.read<EditProfileCubit>()
              .usernameChanged(username),
            validator: (username) => 
              username.trim().isEmpty
              ? 'Username cannot be empty'
              : null,
          ),

          const SizedBox(height: 16.0),

          TextFormField(
            initialValue: user.bio,
            decoration: InputDecoration(hintText: 'Biography'),
            onChanged: (bio) => 
              context.read<EditProfileCubit>()
              .bioChanged(bio),
            validator: (bio) => 
              bio.trim().isEmpty
              ? 'Biography cannot be empty'
              : null,
          ),

        ],
      ),
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gram/helpers/helpers.dart';
import 'package:flutter_gram/screens/create_post/cubit/create_post_cubit.dart';
import 'package:flutter_gram/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePostScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Post'),
          centerTitle: true,
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            
            if(state.status == CreatePostStatus.success) {
              _formKey.currentState.reset();
              context.read<CreatePostCubit>().reset();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Post Created'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.green,
                )
              );
            }

            else if(state.status == CreatePostStatus.error) {
              showDialog(
                context: context, 
                builder: (context) => ErrorDialog(content: state.failure.message)
              );
            }

          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: state.postImage != null
                              ? Image.file(state.postImage, fit: BoxFit.cover)
                              : const Icon(Icons.image, color: Colors.grey, size: 120.0),
                    ),
                    onTap: () => _selectPostImage(context),
                  ),

                  if(state.status == CreatePostStatus.submitting)
                      const LinearProgressIndicator(),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Caption'),
                            onChanged: (value) => context
                              .read<CreatePostCubit>()
                              .captionChanged(value),
                            validator: (value) => value.trim().isEmpty 
                              ? 'Caption cannot be empty.'
                              : null ,
                          ),
                          const SizedBox(height: 28.0),

                          MaterialButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () => _submitForm(
                              context, 
                              state.postImage,
                              state.status == CreatePostStatus.submitting 
                            ),
                            child: const Text('Post'),
                          )

                        ],
                      )
                    ),
                  ),
                ],
              )
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, File postImage, bool isSubmitting) {
    if(_formKey.currentState.validate() && postImage != null && !isSubmitting) {
      context.read<CreatePostCubit>().submit();
    }
  }

  void _selectPostImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context, 
      cropStyle: CropStyle.rectangle, 
      title: 'Create Post'
    );

    if(pickedFile != null) {
      context
        .read<CreatePostCubit>()
        .postImageChanged(pickedFile);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gram/screens/login/cubit/login_cubit.dart';
import 'package:flutter_gram/widgets/widgets.dart';



class LoginScreen extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context, 
                builder: (context) => ErrorDialog(content: state.failure.message)
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'FlutterGram', 
                              style: TextStyle(
                                fontSize: 28.0, 
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Login', 
                              style: TextStyle(
                                fontSize: 18.0, 
                                fontWeight: FontWeight.w500
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 12.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Email'),
                              onChanged: (value) => context.read<LoginCubit>().emailChanged(value),
                              validator: (value) => !value.contains('@') 
                                                    ? 'Please enter a valid email.' 
                                                    : null,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Password'),
                              obscureText: true,
                              onChanged: (value) => context.read<LoginCubit>().passwordChanged(value),
                              validator: (value) => value.length < 6 
                                                    ? 'Must be at least 6 characters.' 
                                                    : null,
                            ),
                            const SizedBox(height: 28.0),

                            ElevatedButton(
                              onPressed: () => _submitForm(
                                context,
                                state.status == LoginStatus.submitting
                              ), 
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(1.0),
                              ),
                              child: Text('Log In')
                            ),
                            const SizedBox(height: 12.0),

                            ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pushNamed('/signup');
                              }, 
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(1.0),
                                backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
                                foregroundColor: MaterialStateProperty.all(Colors.black),
                              ),
                              child: Text('No account? Sign Up')
                            ),
      
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {

    if(_formKey.currentState.validate() && !isSubmitting){
      context.read<LoginCubit>().logInWithCredentials();
    }

  }
  
}

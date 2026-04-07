import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/constants/dimens.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/base_scaffold.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/button/loading_button.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/text_field/base_text_field.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/text_field/text_field_type.dart';
import 'package:news_app_clean_architecture/features/login/presentation/bloc/login_bloc.dart';
import 'package:news_app_clean_architecture/features/login/presentation/bloc/login_field_error.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: BlocProvider(
        create: (context) => sl<LoginBloc>(),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) => switch (state) {
            LoginLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            NotLoggedIn() || LoginInitial() || LoggedIn() => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.screenPaddingHorizontal,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BaseTextField(
                      controller: _emailController,
                      hint: 'email',
                      type: TextFieldType.outline,
                      errorText: state.errors.getEmailError,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: Dimens.m,
                      ),
                      child: BaseTextField(
                        controller: _passwordController,
                        hint: 'password',
                        textType: BaseTextFieldType.password,
                        type: TextFieldType.outline,
                        errorText: state.errors.getPasswordError,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: Dimens.l),
                      child: LoadingButton(
                        isLoading: state is LoginLoading,
                        text: 'Login',
                        onTap: () {
                          context.read<LoginBloc>().add(
                                SignInWithEmailAndPasswordRequested(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            LoginError() => const Center(
                child: Text('Something was wrong'),
              ),
          },
        ),
      ),
    );
  }
}

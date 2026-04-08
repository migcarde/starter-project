import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/constants/dimens.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/base_scaffold.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/button/loading_button.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/text_field/base_text_field.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/text_field/text_field_type.dart';
import 'package:news_app_clean_architecture/features/login/domain/entities/user.dart';
import 'package:news_app_clean_architecture/features/login/presentation/bloc/login_bloc.dart';
import 'package:news_app_clean_architecture/features/login/presentation/bloc/register_field_error.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: BlocProvider<LoginBloc>.value(
        value: sl<LoginBloc>(),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: Dimens.screenPaddingHorizontal,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TODO: Add photo
                  BaseTextField(
                    controller: _nameController,
                    hint: 'name',
                    type: TextFieldType.outline,
                    errorText: state.registerErrors.getNameError,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: Dimens.m),
                    child: BaseTextField(
                      controller: _emailController,
                      hint: 'email',
                      type: TextFieldType.outline,
                      errorText: state.registerErrors.getEmailError,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: Dimens.m,
                    ),
                    child: BaseTextField(
                      controller: _passwordController,
                      hint: 'password',
                      textType: BaseTextFieldType.password,
                      type: TextFieldType.outline,
                      errorText: state.registerErrors.getPasswordError,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: Dimens.l),
                    child: LoadingButton(
                      isLoading: state is LoginLoading,
                      text: 'Register',
                      onTap: () {
                        context.read<LoginBloc>().add(
                              CreateUserRequested(
                                user: UserEntity(
                                  id: '',
                                  email: _emailController.text,
                                  name: _nameController.text,
                                ),
                                password: _passwordController.text,
                              ),
                            );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

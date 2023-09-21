import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/auth/bloc/auth_bloc.dart';
import 'package:temple_app/features/auth/widgets/custom_text_field.dart';
import 'package:temple_app/features/auth/widgets/login_with_email_password.dart';
import 'package:temple_app/features/auth/widgets/login_with_phone.dart';
import 'package:temple_app/features/auth/widgets/otp_screen.dart';
import 'package:temple_app/widgets/utils.dart';
import 'dart:developer' as dev;
import '../widgets/custom_auth_button.dart';
import '../widgets/signup_with_email.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Temple App"),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            Utils.showSnackBar(context: context, message: state.errorMessagge);
          }
        },
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0).copyWith(top: 24.0),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Column(
                children: [
                  (state is PhoneAuthCodeSentSuccess)
                      ? OtpWidget(
                          verificationId: state.verificationId,
                          phoneNo: state.phoneNumber)
                      : Column(
                          children: [
                            (state.authType == AuthType.signinWithEmail)
                                ? const LoginWithEmailPassword()
                                : const SizedBox(),
                            (state.authType == AuthType.signupWithEmail)
                                ? const SignupWithEmail()
                                : const SizedBox(),
                            (state.authType == AuthType.loginWithPhone)
                                ? const LoginWithPhone()
                                : const SizedBox(),
                          ],
                        ),
                  const Center(child: Text('Or')),
                  CustomAuthButton(
                    assetUrl: 'assets/images/google.png',
                    title: 'Continue with google',
                    onTap: () {
                      context
                          .read<AuthBloc>()
                          .add(SignInWithGoogelEvent(context: context));
                    },
                  ),
                  (state.authType != AuthType.loginWithPhone)
                      ? CustomAuthButton(
                          assetUrl: 'assets/images/phone.png',
                          title: 'Login with phone',
                          onTap: () {
                            context.read<AuthBloc>().add(AuthTypeChangedEvent(
                                authType: AuthType.loginWithPhone));
                          },
                        )
                      : const SizedBox(),
                  (state.authType != AuthType.signinWithEmail)
                      ? CustomAuthButton(
                          assetUrl: 'assets/images/mail.png',
                          title: 'Login with mail',
                          onTap: () {
                            context.read<AuthBloc>().add(AuthTypeChangedEvent(
                                authType: AuthType.signinWithEmail));
                          },
                        )
                      : const SizedBox(),
                  SizedBox(height: 30.h),
                  (state.authType != AuthType.signupWithEmail)
                      ? Align(
                          alignment: const Alignment(0, 0),
                          child: Row(
                            children: [
                              const Text('Don\'t have a account? '),
                              InkWell(
                                onTap: () {
                                  context.read<AuthBloc>().add(
                                      AuthTypeChangedEvent(
                                          authType: AuthType.signupWithEmail));
                                },
                                child: Text(
                                  'Create one',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).primaryColor),
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

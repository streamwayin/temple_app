import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/auth/bloc/auth_bloc.dart';
import 'package:temple_app/features/auth/widgets/login_with_email_password.dart';
import 'package:temple_app/features/auth/widgets/login_with_phone.dart';
import 'package:temple_app/features/auth/widgets/otp_screen.dart';
import 'package:temple_app/widgets/utils.dart';
import '../../../widgets/common_background_component.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/signup_with_email.dart';

class AuthScreen extends StatelessWidget {
  static const String routeName = "auth-screen";
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text("Temple App"),
      //   actions: [
      //     IconButton(
      //         onPressed: () => Navigator.pop(context),
      //         icon: const Icon(Icons.close_rounded))
      //   ],
      // ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            Utils.showSnackBar(context: context, message: state.errorMessagge);
          }
          if (state.isLoggedIn != null && state.isLoggedIn == true) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            const CommonBackgroundComponent(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0)
                  .copyWith(top: 24.0),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 56,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 40,
                                color: Color.fromARGB(255, 51, 51, 51),
                              ),
                            ),
                          ],
                        ),
                      ),
                      (state is PhoneAuthCodeSentSuccess)
                          ? OtpWidget(
                              verificationId: state.verificationId,
                              phoneNo: state.phoneNumber)
                          : Column(
                              children: [
                                LoginWithPhone()
                                // (state.authType == AuthType.signupWithEmail)
                                //     ? const SignupWithEmail()
                                //     : const SizedBox(),
                                // (state.authType == AuthType.loginWithPhone)
                                //     ? const LoginWithPhone()
                                //     : const SizedBox(),
                              ],
                            ),
                      CustomAuthButton(
                        assetUrl: 'assets/images/google.png',
                        title: 'Continue with google',
                        onTap: () {
                          context
                              .read<AuthBloc>()
                              .add(SignInWithGoogelEvent(context: context));
                        },
                      ),
                      // CustomAuthButton(
                      //   assetUrl: 'assets/images/phone.png',
                      //   title: 'Login with phone',
                      //   onTap: () {
                      //     // context.read<AuthBloc>().add(AuthTypeChangedEvent(
                      //     //     authType: AuthType.loginWithPhone));
                      //   },
                      // )
                      // (state.authType != AuthType.loginWithPhone)
                      //     ? CustomAuthButton(
                      //         assetUrl: 'assets/images/phone.png',
                      //         title: 'Login with phone',
                      //         onTap: () {
                      //           context.read<AuthBloc>().add(
                      //               AuthTypeChangedEvent(
                      //                   authType: AuthType.loginWithPhone));
                      //         },
                      //       )
                      //     : const SizedBox(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

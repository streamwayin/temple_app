import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temple_app/repositories/auth_repository.dart';

import '../../../constants.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(const AuthState()) {
    on<AuthEventInitial>(onAuthEventInitial);
    // on<SignInWithGoogelEvent>(onSignInWithGoogelEvent);
    on<SignUpRequested>(onSignUpRequested);
    on<SignInRequested>(onSignInRequested);
    on<AuthTypeChangedEvent>(onAuthTypeChangedEvent);
    on<CountryCodeUpdatedEvent>(onCountryCodeUpdatedEvent);
    on<SendOtpToPhoneEvent>(onSendOtpToPhoneEvent);
    on<VerifySentOtpEvent>(_onVerifyOtp);
    // When the firebase sends the code to the user's phone, this event will be fired
    on<OnPhoneOtpSent>((event, emit) => emit(PhoneAuthCodeSentSuccess(
        verificationId: event.verificationId, phoneNumber: event.phoneNumber)));
    // When any error occurs while sending otp to the user's phone, this event will be fired
    on<OnPhoneAuthErrorEvent>(
        (event, emit) => emit(AuthErrorState(errorMessagge: event.error)));
    on<OnPhoneAuthVerificationCompleteEvent>(_loginWithCredential);
    on<SignInWithgoogleEvent2>(onSignInWithgoogleEvent2);
  }

  // FutureOr<void> onSignInWithGoogelEvent(
  //     SignInWithGoogelEvent event, Emitter<AuthState> emit) async {
  //   UserCredential? userCredential =
  //       await authRepository.signInWithGoogle(event.context);
  //   if (userCredential == null) {
  //     emit(const AuthErrorState(errorMessagge: 'User cancelled google login'));
  //   } else {
  //     SharedPreferences sharedPreferences =
  //         await SharedPreferences.getInstance();
  //     sharedPreferences.setBool(IS_USER_LOGGED_IN, true);
  //     emit(state.copyWith(isLoggedIn: true));
  //   }
  // }

  FutureOr<void> onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    try {
      await authRepository.signUp(email: event.email, password: event.password);
    } catch (e) {
      emit(AuthErrorState(errorMessagge: e.toString()));
    }
  }

  FutureOr<void> onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    try {
      await authRepository.signIn(email: event.email, password: event.password);
    } catch (e) {
      emit(AuthErrorState(errorMessagge: e.toString()));
    }
  }

  FutureOr<void> onAuthTypeChangedEvent(
      AuthTypeChangedEvent event, Emitter<AuthState> emit) {
    // emit(state.copyWith(authType: event.authType));
  }

  FutureOr<void> onCountryCodeUpdatedEvent(
      CountryCodeUpdatedEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(code: event.code));
  }

  FutureOr<void> onSendOtpToPhoneEvent(
      SendOtpToPhoneEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(watingForOtp: true));
      await authRepository.verifyPhone(
        phoneNumber: event.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // On [verificationComplete], we will get the credential from the firebase  and will send it to the [OnPhoneAuthVerificationCompleteEvent] event to be handled by the bloc and then will emit the [PhoneAuthVerified] state after successful login
          add(OnPhoneAuthVerificationCompleteEvent(credential: credential));
        },
        codeSent: (String verificationId, int? resendToken) {
          // On [codeSent], we will get the verificationId and the resendToken from the firebase and will send it to the [OnPhoneOtpSent] event to be handled by the bloc and then will emit the [OnPhoneAuthVerificationCompleteEvent] event after receiving the code from the user's phone
          add(OnPhoneOtpSent(
              verificationId: verificationId,
              token: resendToken,
              phoneNumber: event.phoneNumber));
        },
        verificationFailed: (FirebaseAuthException e) {
          // On [verificationFailed], we will get the exception from the firebase and will send it to the [OnPhoneAuthErrorEvent] event to be handled by the bloc and then will emit the [PhoneAuthError] state in order to display the error to the user's screen
          add(OnPhoneAuthErrorEvent(error: e.code));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      emit(AuthErrorState(errorMessagge: e.toString()));
    }
  }

  FutureOr<void> _onVerifyOtp(
      VerifySentOtpEvent event, Emitter<AuthState> emit) {
    try {
      // After receiving the otp, we will verify the otp and then will create a credential from the otp and verificationId and then will send it to the [OnPhoneAuthVerificationCompleteEvent] event to be handled by the bloc and then will emit the [PhoneAuthVerified] state after successful login
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otpCode,
      );
      add(OnPhoneAuthVerificationCompleteEvent(credential: credential));
    } catch (e) {
      emit(AuthErrorState(errorMessagge: e.toString()));
    }
  }

  FutureOr<void> _loginWithCredential(
      OnPhoneAuthVerificationCompleteEvent event,
      Emitter<AuthState> emit) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // After receiving the credential from the event, we will login with the credential and then will emit the [PhoneAuthVerified] state after successful login
    try {
      await FirebaseAuth.instance
          .signInWithCredential(event.credential)
          .then((user) async {
        if (user.user != null) {
          // check if user already exists
          bool isUserAvailable =
              await authRepository.checkIdUserAvaliable(user.user!.uid);
          sharedPreferences.setBool(IS_USER_LOGGED_IN, true);
          emit(state.copyWith(
            // authType: AuthType.signinWithEmail,
            ifUserExists: isUserAvailable,
            navigateToAskNameScreen: true,
          ));
        }
      });
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(errorMessagge: e.code));
    } catch (e) {
      emit(AuthErrorState(errorMessagge: e.toString()));
    }
  }

  FutureOr<void> onAuthEventInitial(
      AuthEventInitial event, Emitter<AuthState> emit) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLoggedIn = sharedPreferences.getBool(IS_USER_LOGGED_IN) ?? false;
    emit(state.copyWith(isLoggedIn: isLoggedIn));
  }

  FutureOr<void> onSignInWithgoogleEvent2(
      SignInWithgoogleEvent2 event, Emitter<AuthState> emit) async {
    await authRepository.signInWithGoogle(event.context, event.user);
    emit(state.copyWith(isLoggedIn: true));
  }
}

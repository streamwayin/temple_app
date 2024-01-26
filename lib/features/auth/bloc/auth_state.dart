part of 'auth_bloc.dart';

// enum AuthType { signinWithEmail, signupWithEmail, loginWithPhone }

class AuthState extends Equatable {
  // final AuthType authType;
  final CountryCode code;
  final bool isLoggedIn;
  final bool navigateToAskNameScreen;
  final bool watingForOtp;
  final bool ifUserExists;
  const AuthState({
    // this.authType = AuthType.signinWithEmail,
    this.code = const CountryCode(name: 'India', code: 'IN', dialCode: '+91'),
    this.isLoggedIn = false,
    this.navigateToAskNameScreen = false,
    this.watingForOtp = false,
    this.ifUserExists = false,
  });
  @override
  List<Object?> get props => [
        code,
        isLoggedIn,
        navigateToAskNameScreen,
        watingForOtp,
        ifUserExists,
        ifUserExists
      ];

  AuthState copyWith({
    // AuthType? authType,
    CountryCode? code,
    bool? isLoggedIn,
    bool? navigateToAskNameScreen,
    bool? watingForOtp,
    bool? ifUserExists,
  }) {
    return AuthState(
      // authType: authType ?? this.authType,
      code: code ?? this.code,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      navigateToAskNameScreen:
          navigateToAskNameScreen ?? this.navigateToAskNameScreen,
      watingForOtp: watingForOtp ?? this.watingForOtp,
      ifUserExists: ifUserExists ?? this.ifUserExists,
    );
  }
}

class AuthErrorState extends AuthState {
  final String errorMessagge;

  const AuthErrorState({required this.errorMessagge});
  @override
  List<Object?> get props => [errorMessagge];
}

class PhoneAuthCodeSentSuccess extends AuthState {
  final String verificationId;
  final String phoneNumber;
  const PhoneAuthCodeSentSuccess(
      {required this.verificationId, required this.phoneNumber});
  @override
  List<Object> get props => [verificationId];
}

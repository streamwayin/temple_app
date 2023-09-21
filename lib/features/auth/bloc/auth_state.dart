part of 'auth_bloc.dart';

enum AuthType { signinWithEmail, signupWithEmail, loginWithPhone }

class AuthState extends Equatable {
  final AuthType authType;
  final CountryCode code;
  const AuthState(
      {this.authType = AuthType.signinWithEmail,
      this.code =
          const CountryCode(name: 'India', code: 'IN', dialCode: '+91')});
  @override
  List<Object?> get props => [authType, code];

  AuthState copyWith({AuthType? authType, CountryCode? code}) {
    return AuthState(
      authType: authType ?? this.authType,
      code: code ?? this.code,
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

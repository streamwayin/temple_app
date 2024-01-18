part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthEventInitial extends AuthEvent {}

class SignInWithGoogelEvent extends AuthEvent {
  final BuildContext context;

  SignInWithGoogelEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  SignUpRequested(this.email, this.password, this.name);
}

class AuthTypeChangedEvent extends AuthEvent {
  // final AuthType authType;

  // AuthTypeChangedEvent({required this.authType});
}

class CountryCodeUpdatedEvent extends AuthEvent {
  final CountryCode code;

  CountryCodeUpdatedEvent({required this.code});
}

class SendOtpToPhoneEvent extends AuthEvent {
  final String phoneNumber;

  SendOtpToPhoneEvent({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class OnPhoneAuthVerificationCompleteEvent extends AuthEvent {
  final AuthCredential credential;
  OnPhoneAuthVerificationCompleteEvent({
    required this.credential,
  });
}

class OnPhoneOtpSent extends AuthEvent {
  final String verificationId;
  final int? token;
  final String phoneNumber;
  OnPhoneOtpSent(
      {required this.verificationId,
      required this.token,
      required this.phoneNumber});

  @override
  List<Object> get props => [verificationId];
}

class OnPhoneAuthErrorEvent extends AuthEvent {
  final String error;
  OnPhoneAuthErrorEvent({required this.error});

  @override
  List<Object> get props => [error];
}

class VerifySentOtpEvent extends AuthEvent {
  final String otpCode;
  final String verificationId;

  VerifySentOtpEvent({required this.otpCode, required this.verificationId});

  @override
  List<Object> get props => [otpCode, verificationId];
}

class SignInWithgoogleEvent2 extends AuthEvent {
  final User user;
  final BuildContext context;

  SignInWithgoogleEvent2({required this.user, required this.context});
}

class AddNameToFirebasedatabaseEvent extends AuthEvent {}

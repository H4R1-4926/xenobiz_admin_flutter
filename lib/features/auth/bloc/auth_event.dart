import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginSubmitted extends AuthEvent {
  final String loginId;
  final String password;

  const AuthLoginSubmitted({required this.loginId, required this.password});

  @override
  List<Object?> get props => [loginId, password];
}

class AuthLogoutRequested extends AuthEvent {}

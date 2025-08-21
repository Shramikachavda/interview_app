import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginUser extends AuthEvent {
  final String email;
  final String password;

  const LoginUser({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterUser extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String level;

  const RegisterUser({
    required this.name,
    required this.email,
    required this.password,
    required this.level
  });

  @override
  List<Object?> get props => [name, email, password, level];
}

class LogoutUser extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class FetchCurrentUser extends AuthEvent {}

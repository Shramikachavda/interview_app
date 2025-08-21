import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constant/exception/custom_exception.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginUser>(_onLoginUser);
    on<RegisterUser>(_onRegisterUser);
    on<LogoutUser>(_onLogoutUser);
    on<FetchCurrentUser>(_onFetchCurrentUser);
  }

  void _handleError(Exception e, Emitter<AuthState> emit) {
    if (e is AppException) {
      emit(AuthError(e.message));
    } else if (e is ServerException) {
      emit(AuthError("Server error: ${e.message}"));
    } else {
      emit(AuthError("Unexpected error: ${e.toString()}"));
    }
  }


  Future<void> _onLoginUser(LoginUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    print("📲 [BLoC] Login initiated for email: ${event.email}");

    try {
      final result = await authRepository.login(event.email, event.password);
      print("📥 [BLoC] Raw login result: $result");

      if (result['success'] == true && result['data'] != null) {
        print("✅ [BLoC] Login successful, parsing LoginResponse...");

        final loginResponse = LoginResponse.fromJson(result['data']);

        print("🔐 [BLoC] Access token: ${loginResponse.accessToken}");
        print("👤 [BLoC] Logged in User: ${loginResponse.user}");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', loginResponse.accessToken);
        print("💾 [BLoC] Token saved to SharedPreferences");

        emit(AuthAuthenticated(loginResponse.user));
        print("🚀 [BLoC] Emitting AuthAuthenticated state");
      } else {
        final message = result['message'] ?? "Login failed";
        print("❌ [BLoC] Login failed: $message");
        emit(AuthError(message));
      }
    } catch (e, stack) {
      print("💥 [BLoC] Unexpected error during login: $e");
      print("📍 [BLoC] Stacktrace: $stack");
      _handleError(e as Exception, emit);
    }
  }




  Future<void> _onRegisterUser(RegisterUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    print("📝 [BLoC] Registration started for: ${event.email}");

    try {
      final result = await authRepository.register(
        event.name,
        event.email,
        event.password,
        event.level,
      );

      print("📥 [BLoC] Raw register result: $result");

      if (result['success'] == true && result['data'] != null) {
        print("✅ [BLoC] Registration successful, parsing LoginResponse...");

        final loginResponse = LoginResponse.fromJson(result['data']);

        print("🔐 [BLoC] Access token after registration: ${loginResponse.accessToken}");
        print("👤 [BLoC] Registered User: ${loginResponse.user}");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', loginResponse.accessToken);
        print("💾 [BLoC] Token saved to SharedPreferences");

        emit(AuthAuthenticated(loginResponse.user));
        print("🚀 [BLoC] Emitting AuthAuthenticated state after register");
      } else {
        final message = result['message'] ?? "Registration failed";
        print("❌ [BLoC] Registration failed: $message");
        emit(AuthError(message));
      }

    } catch (e, stack) {
      print("💥 [BLoC] Unexpected error during registration: $e");
      print("📍 [BLoC] Stacktrace: $stack");
      _handleError(e as Exception, emit);
    }
  }



  Future<void> _onLogoutUser(LogoutUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      _handleError(e as Exception, emit);
    }
  }

  Future<void> _onFetchCurrentUser(FetchCurrentUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      _handleError(e as Exception, emit);
    }
  }
}
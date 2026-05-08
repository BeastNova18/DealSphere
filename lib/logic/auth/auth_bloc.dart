import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SessionChecked>(_onSessionChecked);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onSessionChecked(SessionChecked event, Emitter emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    isLoggedIn ? emit(AuthAuthenticated()) : emit(AuthUnauthenticated());
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1)); // simulate network

    // Mock validation — any email + min 6 char password works
    if (event.email.contains('@') && event.password.length >= 6) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      emit(AuthAuthenticated());
    } else {
      emit(AuthError('Invalid email or password (min 6 characters).'));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    emit(AuthUnauthenticated());
  }
}

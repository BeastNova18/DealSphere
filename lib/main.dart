import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/deal_repository.dart';
import 'logic/auth/auth_bloc.dart';
import 'logic/auth/auth_event.dart';
import 'logic/auth/auth_state.dart';
import 'logic/deals/deals_bloc.dart';
import 'logic/interests/interests_bloc.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/deal_list_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (_) => DealRepository())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc()..add(SessionChecked())),
          BlocProvider(create: (ctx) => DealsBloc(ctx.read<DealRepository>())),
          BlocProvider(create: (_) => InterestsBloc()),
        ],
        child: MaterialApp(
          title: 'DealFlow',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          home: const AppRouter(),
        ),
      ),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is AuthAuthenticated) return const DealListScreen();
        return const LoginScreen();
      },
    );
  }
}

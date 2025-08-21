import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_ui/presantation/landing_screen/dashboard/dashboard_screen.dart';
import 'package:interview_ui/presantation/landing_screen/interview/interview_bloc/interview_bloc.dart';
import 'package:interview_ui/presantation/landing_screen/interview/interview_screen.dart';
import 'package:interview_ui/presantation/landing_screen/landing_screen.dart';
import 'package:interview_ui/presantation/landing_screen/login/login_bloc/auth_bloc.dart';
import 'package:interview_ui/presantation/landing_screen/login/login_screen.dart';
import 'package:interview_ui/presantation/landing_screen/result/result_screen.dart';
import 'package:interview_ui/presantation/landing_screen/settings/settings_screen.dart';
import 'package:interview_ui/presantation/landing_screen/legal/terms_screen.dart';
import 'package:interview_ui/presantation/landing_screen/legal/privacy_screen.dart';
import 'package:interview_ui/presantation/landing_screen/auth/forgot_password_screen.dart';
import 'package:interview_ui/presantation/landing_screen/auth/change_password_screen.dart';
import 'package:interview_ui/presantation/landing_screen/coding_screen/enhanced_coding_screen.dart';
import 'package:interview_ui/theme/theme.dart';
import 'package:interview_ui/theme/theme_cubit.dart';
import 'package:interview_ui/utils/shared_pref.dart';
import 'data/models/feedback_response.dart';
import 'data/models/interview_models.dart';
import 'data/models/user_model.dart';
import 'data/repository/auth_repository.dart';
import 'di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  final authRepository = AuthRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InterviewBloc()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => AuthBloc(authRepository: authRepository)),
      ],
      child: const InterviewCoachApp(),
    ),
  );
}

class InterviewCoachApp extends StatelessWidget {
  const InterviewCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'Interview Coach',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
         // themeMode: ThemeMode.light,
          themeMode: themeState is ThemeLoaded ? themeState.themeMode : ThemeMode.system,
          initialRoute: '/',
          routes: {
            '/': (context) => LandingScreen(),
            '/login': (context) => const LoginScreen(),
            '/dashboard': (context) => DashboardScreen(
              user: User(
                name: "shramika",
                id: 1,
                email: "shramika@gmail.com",
                level: "easy",
              ),
            ),
            '/interview': (context) {
              return InterviewScreen();
            },
            '/feedback': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

              if (args != null) {
                return FeedbackScreen(
                  feedback: args['feedback'] as InterviewFeedback,
                  interviewState: args['interviewState'] as InterviewModel,
                );
              }

              return FutureBuilder(
                future: loadFeedbackAndInterview(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Scaffold(
                      body: Center(child: Text("No saved feedback found")),
                    );
                  }

                  final data = snapshot.data!;
                  return FeedbackScreen(
                    feedback: data['feedback']!,
                    interviewState: data['interviewState']!,
                  );
                },
              );
            },


            '/coding': (context) => EnhancedCodingScreen(
              question: CodingQuestion(
                id: '1',
                title: "Reverse a String",
                description:
                    "Write a function to reverse a given string. The function should take a string as input and return the reversed string.",
                initialCode:
                    "def reverse_string(s):\n    # Your code here\n    pass",
                language: "python",
                testCases: ["hello", "world", "python"],
                expectedOutput: "olleh",
                difficulty: "easy",
              ),
            ),
            '/settings': (context) => const SettingsScreen(),
            '/terms': (context) => const TermsScreen(),
            '/privacy': (context) => const PrivacyScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/change-password': (context) => const ChangePasswordScreen(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

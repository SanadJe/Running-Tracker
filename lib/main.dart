import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gano/core/theme/features/auth/provider/auth_provider.dart';
import 'package:gano/core/theme/features/auth/ui/login_screen.dart';
import 'package:gano/core/theme/features/runs/provider/runs_provider.dart';
import 'package:gano/core/theme/features/runs/ui/runs_screen.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // ✅ RunProvider يعتمد على AuthProvider
           ChangeNotifierProxyProvider<AuthProvider, RunProvider>(
          create: (context) =>
              RunProvider(context.read<AuthProvider>()),
          update: (context, auth, previous) => RunProvider(auth),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, theme, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,

            home: Consumer<AuthProvider>(
              builder: (context, auth, _) {
                return StreamBuilder(
                  stream: auth.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final user = snapshot.data;
                    if (user == null) return const LoginScreen();
                    return const RunsScreen();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_system/core/di/service_locator.dart';
import 'package:restaurant_management_system/core/navigation/app_router.dart';
import 'package:restaurant_management_system/core/theme/app_theme.dart';
import 'package:restaurant_management_system/features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize service locator
  await setupServiceLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        // Add other providers here
      ],
      child: MaterialApp(
        title: 'Restaurant Management System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('es', ''), // Spanish
        ],
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.splashRoute,
      ),
    );
  }
}

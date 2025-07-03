import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_system/core/navigation/app_router.dart';
import 'package:restaurant_management_system/core/theme/app_theme.dart';
import 'package:restaurant_management_system/features/auth/presentation/providers/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();

    // Navigate to the appropriate screen after a delay
    Future.delayed(const Duration(seconds: 3), () {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // Check if user is logged in
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // For now, always navigate to login
    // In a real app, you would check if the user is logged in
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.restaurant_menu,
                      size: 100,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Restaurant Management',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete Solution for Your Business',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 48),
                    const CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

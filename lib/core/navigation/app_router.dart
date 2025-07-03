import 'package:flutter/material.dart';
import 'package:restaurant_management_system/features/auth/presentation/pages/login_page.dart';
import 'package:restaurant_management_system/features/auth/presentation/pages/register_page.dart';
import 'package:restaurant_management_system/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:restaurant_management_system/features/orders/presentation/pages/create_order_page.dart';
import 'package:restaurant_management_system/features/orders/presentation/pages/order_details_page.dart';
import 'package:restaurant_management_system/features/orders/presentation/pages/orders_page.dart';
import 'package:restaurant_management_system/features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  // Route names
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String dashboardRoute = '/dashboard';
  
  // Orders routes
  static const String ordersRoute = '/orders';
  static const String createOrderRoute = '/orders/create';
  static const String orderDetailsRoute = '/orders/details';
  
  // Other domain routes
  static const String billingRoute = '/billing';
  static const String inventoryRoute = '/inventory';
  static const String tableManagementRoute = '/table-management';
  static const String providersRoute = '/providers';
  static const String reportingRoute = '/reporting';
  static const String notificationsRoute = '/notifications';
  static const String utilitiesRoute = '/utilities';

  // Route generator
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case dashboardRoute:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
        
      // Orders routes
      case ordersRoute:
        return MaterialPageRoute(builder: (_) => const OrdersPage());
      case createOrderRoute:
        return MaterialPageRoute(builder: (_) => const CreateOrderPage());
      case orderDetailsRoute:
        // Extract the order ID from arguments
        final args = settings.arguments as Map<String, dynamic>?;
        final orderId = args?['orderId'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => OrderDetailsPage(orderId: orderId),
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

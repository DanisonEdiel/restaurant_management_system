import 'package:get_it/get_it.dart';
import 'package:restaurant_management_system/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:restaurant_management_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurant_management_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:restaurant_management_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurant_management_system/features/orders/data/repositories/order_repository_impl.dart';
import 'package:restaurant_management_system/features/orders/domain/repositories/order_repository.dart';
import 'package:restaurant_management_system/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:restaurant_management_system/features/orders/domain/usecases/get_order_by_id_usecase.dart';
import 'package:restaurant_management_system/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:restaurant_management_system/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:restaurant_management_system/features/orders/presentation/providers/order_provider.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core

  // Features
  // Auth
  _setupAuthDependencies();
  
  // Orders
  _setupOrdersDependencies();
  
  // Billing
  _setupBillingDependencies();
  
  // Inventory
  _setupInventoryDependencies();
  
  // Table Management
  _setupTableManagementDependencies();
  
  // Providers and Purchasing
  _setupProvidersPurchasingDependencies();
  
  // Reporting
  _setupReportingDependencies();
  
  // Notifications
  _setupNotificationsDependencies();
  
  // Utilities
  _setupUtilitiesDependencies();
}

void _setupAuthDependencies() {
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );
  
  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  
  // Providers
  getIt.registerFactory(() => AuthProvider(getIt()));
}

void _setupOrdersDependencies() {
  // Repositories
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(),
  );
  
  // Use cases
  getIt.registerLazySingleton(() => GetOrdersUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateOrderUseCase(getIt()));
  getIt.registerLazySingleton(() => GetOrderByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateOrderStatusUseCase(getIt()));
  
  // Providers
  getIt.registerFactory(() => OrderProvider(
    getIt<GetOrdersUseCase>(),
    getIt<CreateOrderUseCase>(),
    getIt<GetOrderByIdUseCase>(),
    getIt<UpdateOrderStatusUseCase>(),
  ));
}

void _setupBillingDependencies() {
  // TODO: Implement billing dependencies
}

void _setupInventoryDependencies() {
  // TODO: Implement inventory dependencies
}

void _setupTableManagementDependencies() {
  // TODO: Implement table management dependencies
}

void _setupProvidersPurchasingDependencies() {
  // TODO: Implement providers and purchasing dependencies
}

void _setupReportingDependencies() {
  // TODO: Implement reporting dependencies
}

void _setupNotificationsDependencies() {
  // TODO: Implement notifications dependencies
}

void _setupUtilitiesDependencies() {
  // TODO: Implement utilities dependencies
}

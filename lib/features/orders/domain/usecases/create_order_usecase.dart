import 'package:restaurant_management_system/features/orders/domain/entities/order.dart';
import 'package:restaurant_management_system/features/orders/domain/repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Order> call(Order order) async {
    return await repository.createOrder(order);
  }
}

import 'package:restaurant_management_system/features/orders/domain/entities/order.dart';
import 'package:restaurant_management_system/features/orders/domain/repositories/order_repository.dart';

class UpdateOrderStatusUseCase {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<Order> call(String id, OrderStatus status) async {
    return await repository.updateOrderStatus(id, status);
  }
}

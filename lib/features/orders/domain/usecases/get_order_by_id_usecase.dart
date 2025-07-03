import 'package:restaurant_management_system/features/orders/domain/entities/order.dart';
import 'package:restaurant_management_system/features/orders/domain/repositories/order_repository.dart';

class GetOrderByIdUseCase {
  final OrderRepository repository;

  GetOrderByIdUseCase(this.repository);

  Future<Order> call(String id) async {
    return await repository.getOrderById(id);
  }
}

import 'package:restaurant_management_system/features/orders/domain/entities/order.dart';
import 'package:restaurant_management_system/features/orders/domain/repositories/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<List<Order>> call({
    DateTime? startDate,
    DateTime? endDate,
    OrderStatus? status,
    String? tableId,
    String? waiterId,
  }) async {
    return await repository.getOrders(
      startDate: startDate,
      endDate: endDate,
      status: status,
      tableId: tableId,
      waiterId: waiterId,
    );
  }
}

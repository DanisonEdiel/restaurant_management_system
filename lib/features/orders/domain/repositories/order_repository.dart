import 'package:restaurant_management_system/features/orders/domain/entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders({
    DateTime? startDate,
    DateTime? endDate,
    OrderStatus? status,
    String? tableId,
    String? waiterId,
  });
  
  Future<Order> getOrderById(String id);
  
  Future<Order> createOrder(Order order);
  
  Future<Order> updateOrder(Order order);
  
  Future<bool> deleteOrder(String id);
  
  Future<Order> updateOrderStatus(String id, OrderStatus status);
  
  Future<List<Order>> getActiveOrders();
  
  Future<List<Order>> getOrdersByTable(String tableId);
}

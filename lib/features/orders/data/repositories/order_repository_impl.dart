import 'package:restaurant_management_system/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:restaurant_management_system/features/orders/data/models/order_model.dart';
import 'package:restaurant_management_system/features/orders/domain/entities/order.dart';
import 'package:restaurant_management_system/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource = OrderRemoteDataSource();

  @override
  Future<List<Order>> getOrders({
    DateTime? startDate,
    DateTime? endDate,
    OrderStatus? status,
    String? tableId,
    String? waiterId,
  }) async {
    try {
      return await remoteDataSource.getOrders(
        startDate: startDate,
        endDate: endDate,
        status: status,
        tableId: tableId,
        waiterId: waiterId,
      );
    } catch (e) {
      throw Exception('Failed to get orders: ${e.toString()}');
    }
  }

  @override
  Future<Order> getOrderById(String id) async {
    try {
      return await remoteDataSource.getOrderById(id);
    } catch (e) {
      throw Exception('Failed to get order: ${e.toString()}');
    }
  }

  @override
  Future<Order> createOrder(Order order) async {
    try {
      if (order is OrderModel) {
        return await remoteDataSource.createOrder(order);
      } else {
        throw Exception('Order must be an OrderModel');
      }
    } catch (e) {
      throw Exception('Failed to create order: ${e.toString()}');
    }
  }

  @override
  Future<Order> updateOrder(Order order) async {
    try {
      if (order is OrderModel) {
        return await remoteDataSource.updateOrder(order);
      } else {
        throw Exception('Order must be an OrderModel');
      }
    } catch (e) {
      throw Exception('Failed to update order: ${e.toString()}');
    }
  }

  @override
  Future<bool> deleteOrder(String id) async {
    try {
      return await remoteDataSource.deleteOrder(id);
    } catch (e) {
      throw Exception('Failed to delete order: ${e.toString()}');
    }
  }

  @override
  Future<Order> updateOrderStatus(String id, OrderStatus status) async {
    try {
      return await remoteDataSource.updateOrderStatus(id, status);
    } catch (e) {
      throw Exception('Failed to update order status: ${e.toString()}');
    }
  }

  @override
  Future<List<Order>> getActiveOrders() async {
    try {
      return await remoteDataSource.getOrders(
        status: OrderStatus.inProgress,
      );
    } catch (e) {
      throw Exception('Failed to get active orders: ${e.toString()}');
    }
  }

  @override
  Future<List<Order>> getOrdersByTable(String tableId) async {
    try {
      return await remoteDataSource.getOrders(
        tableId: tableId,
      );
    } catch (e) {
      throw Exception('Failed to get orders by table: ${e.toString()}');
    }
  }
}

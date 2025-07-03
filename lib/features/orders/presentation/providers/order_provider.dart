import 'package:flutter/material.dart';
import 'package:restaurant_management_system/features/orders/data/models/order_model.dart';
import 'package:restaurant_management_system/features/orders/domain/entities/order.dart';
import 'package:restaurant_management_system/features/orders/domain/entities/order_item.dart';
import 'package:restaurant_management_system/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:restaurant_management_system/features/orders/domain/usecases/get_order_by_id_usecase.dart';
import 'package:restaurant_management_system/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:restaurant_management_system/features/orders/domain/usecases/update_order_status_usecase.dart';

class OrderProvider extends ChangeNotifier {
  final GetOrdersUseCase _getOrdersUseCase;
  final CreateOrderUseCase _createOrderUseCase;
  final GetOrderByIdUseCase _getOrderByIdUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  
  List<Order> _orders = [];
  Order? _currentOrder;
  bool _isLoading = false;
  String? _error;
  
  OrderProvider(
    this._getOrdersUseCase, 
    this._createOrderUseCase, 
    this._getOrderByIdUseCase,
    this._updateOrderStatusUseCase,
  );
  
  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> getOrders({
    DateTime? startDate,
    DateTime? endDate,
    OrderStatus? status,
    String? tableId,
    String? waiterId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _orders = await _getOrdersUseCase(
        startDate: startDate,
        endDate: endDate,
        status: status,
        tableId: tableId,
        waiterId: waiterId,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> createOrder(Order order) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentOrder = await _createOrderUseCase(order);
      _orders.add(_currentOrder!);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  void setCurrentOrder(Order order) {
    _currentOrder = order;
    notifyListeners();
  }
  
  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  Future<void> getOrderById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentOrder = await _getOrderByIdUseCase(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> updateOrderStatus(String id, OrderStatus status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final updatedOrder = await _updateOrderStatusUseCase(id, status);
      
      // Update the current order if it's the one being updated
      if (_currentOrder != null && _currentOrder!.id == id) {
        _currentOrder = updatedOrder;
      }
      
      // Update the order in the list
      final index = _orders.indexWhere((order) => order.id == id);
      if (index != -1) {
        _orders[index] = updatedOrder;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}

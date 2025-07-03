import 'package:equatable/equatable.dart';
import 'package:restaurant_management_system/features/orders/domain/entities/order_item.dart';

enum OrderStatus {
  pending,
  inProgress,
  ready,
  delivered,
  completed,
  cancelled
}

class Order extends Equatable {
  final String id;
  final String? tableId;
  final String? customerId;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final OrderStatus status;
  final String? waiterId;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  const Order({
    required this.id,
    this.tableId,
    this.customerId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.status,
    this.waiterId,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        tableId,
        customerId,
        items,
        subtotal,
        tax,
        total,
        status,
        waiterId,
        notes,
        createdAt,
        updatedAt,
        completedAt,
      ];

  Order copyWith({
    String? id,
    String? tableId,
    String? customerId,
    List<OrderItem>? items,
    double? subtotal,
    double? tax,
    double? total,
    OrderStatus? status,
    String? waiterId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return Order(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      customerId: customerId ?? this.customerId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      waiterId: waiterId ?? this.waiterId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

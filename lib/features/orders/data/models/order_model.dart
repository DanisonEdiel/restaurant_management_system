import 'package:restaurant_management_system/features/orders/data/models/order_item_model.dart';
import 'package:restaurant_management_system/features/orders/domain/entities/order.dart';
import 'package:restaurant_management_system/features/orders/domain/entities/order_item.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    super.tableId,
    super.customerId,
    required super.items,
    required super.subtotal,
    required super.tax,
    required super.total,
    required super.status,
    super.waiterId,
    super.notes,
    required super.createdAt,
    super.updatedAt,
    super.completedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      tableId: json['table_id'],
      customerId: json['customer_id'],
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      tax: json['tax'].toDouble(),
      total: json['total'].toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      waiterId: json['waiter_id'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final items = this.items.map((item) {
      if (item is OrderItemModel) {
        return item.toJson();
      }
      // Convert OrderItem to OrderItemModel if needed
      return OrderItemModel(
        id: item.id,
        productId: item.productId,
        productName: item.productName,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        total: item.total,
        modifiers: item.modifiers,
        notes: item.notes,
      ).toJson();
    }).toList();

    return {
      'id': id,
      'table_id': tableId,
      'customer_id': customerId,
      'items': items,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'status': status.toString().split('.').last,
      'waiter_id': waiterId,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

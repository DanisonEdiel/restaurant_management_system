import 'package:restaurant_management_system/features/orders/domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.unitPrice,
    required super.total,
    super.modifiers,
    super.notes,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
      total: json['total'].toDouble(),
      modifiers: json['modifiers'] != null
          ? List<String>.from(json['modifiers'])
          : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total': total,
      'modifiers': modifiers,
      'notes': notes,
    };
  }
}

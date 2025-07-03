import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double total;
  final List<String>? modifiers;
  final String? notes;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    this.modifiers,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        quantity,
        unitPrice,
        total,
        modifiers,
        notes,
      ];

  OrderItem copyWith({
    String? id,
    String? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? total,
    List<String>? modifiers,
    String? notes,
  }) {
    return OrderItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      total: total ?? this.total,
      modifiers: modifiers ?? this.modifiers,
      notes: notes ?? this.notes,
    );
  }
}

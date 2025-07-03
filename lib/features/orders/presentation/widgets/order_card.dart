import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_management_system/features/orders/domain/entities/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy - HH:mm');
    
    Color statusColor;
    IconData statusIcon;
    
    switch (order.status) {
      case OrderStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      case OrderStatus.inProgress:
        statusColor = Colors.blue;
        statusIcon = Icons.restaurant;
        break;
      case OrderStatus.ready:
        statusColor = Colors.amber;
        statusIcon = Icons.check_circle_outline;
        break;
      case OrderStatus.delivered:
        statusColor = Colors.cyan;
        statusIcon = Icons.delivery_dining;
        break;
      case OrderStatus.completed:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case OrderStatus.cancelled:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
    }
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          statusIcon,
                          color: statusColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${order.id}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Table: ${order.tableId ?? 'N/A'}',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getStatusText(order.status),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Created',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateFormat.format(order.createdAt),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (order.items.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  '${order.items.length} items',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                _buildItemsList(context),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
  
  Widget _buildItemsList(BuildContext context) {
    // Show only first 3 items
    final displayItems = order.items.length > 3
        ? order.items.sublist(0, 3)
        : order.items;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...displayItems.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Text(
                '${item.quantity}x',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${item.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )),
        if (order.items.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '+ ${order.items.length - 3} more items',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

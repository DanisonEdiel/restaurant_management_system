import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_system/core/navigation/app_router.dart';
import 'package:restaurant_management_system/core/theme/app_theme.dart';
import 'package:restaurant_management_system/features/orders/domain/entities/order.dart';
import 'package:restaurant_management_system/features/orders/domain/entities/order_item.dart';
import 'package:restaurant_management_system/features/orders/presentation/providers/order_provider.dart';
import 'package:restaurant_management_system/features/orders/presentation/widgets/product_selection_dialog.dart';

class CreateOrderPage extends StatefulWidget {
  final String? tableId;

  const CreateOrderPage({
    super.key,
    this.tableId,
  });

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final List<OrderItem> _orderItems = [];
  String? _selectedTableId;
  String? _notes;
  final double _taxRate = 0.10; // 10% tax rate
  
  final TextEditingController _notesController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _selectedTableId = widget.tableId;
  }
  
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
  
  void _addItem(OrderItem item) {
    setState(() {
      // Check if the item already exists
      final existingItemIndex = _orderItems.indexWhere((i) => i.productId == item.productId);
      
      if (existingItemIndex != -1) {
        // Update quantity of existing item
        final existingItem = _orderItems[existingItemIndex];
        final newQuantity = existingItem.quantity + item.quantity;
        
        _orderItems[existingItemIndex] = OrderItem(
          id: existingItem.id,
          productId: existingItem.productId,
          productName: existingItem.productName,
          quantity: newQuantity,
          unitPrice: existingItem.unitPrice,
          total: existingItem.unitPrice * newQuantity,
          modifiers: existingItem.modifiers,
          notes: existingItem.notes,
        );
      } else {
        // Add new item
        _orderItems.add(item);
      }
    });
  }
  
  void _removeItem(int index) {
    setState(() {
      _orderItems.removeAt(index);
    });
  }
  
  void _updateItemQuantity(int index, int quantity) {
    if (quantity <= 0) {
      _removeItem(index);
      return;
    }
    
    setState(() {
      final item = _orderItems[index];
      _orderItems[index] = OrderItem(
        id: item.id,
        productId: item.productId,
        productName: item.productName,
        quantity: quantity,
        unitPrice: item.unitPrice,
        total: item.unitPrice * quantity,
        modifiers: item.modifiers,
        notes: item.notes,
      );
    });
  }
  
  double _calculateSubtotal() {
    return _orderItems.fold(0, (sum, item) => sum + item.total);
  }
  
  double _calculateTax() {
    return _calculateSubtotal() * _taxRate;
  }
  
  double _calculateTotal() {
    return _calculateSubtotal() + _calculateTax();
  }
  
  void _showTableSelectionDialog() {
    // Mock table data
    final tables = List.generate(12, (index) => {
      'id': (index + 1).toString(),
      'name': 'Table ${index + 1}',
      'status': index < 8 ? 'Occupied' : 'Available',
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Table'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tables.length,
            itemBuilder: (context, index) {
              final table = tables[index];
              final isOccupied = table['status'] == 'Occupied';
              
              return ListTile(
                title: Text(table['name'] as String),
                subtitle: Text(table['status'] as String),
                leading: Icon(
                  Icons.table_bar,
                  color: isOccupied ? Colors.red : Colors.green,
                ),
                onTap: () {
                  setState(() {
                    _selectedTableId = table['id'] as String;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => ProductSelectionDialog(
        onProductSelected: _addItem,
      ),
    );
  }
  
  Future<void> _createOrder() async {
    if (_selectedTableId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a table'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (_orderItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one item to the order'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    // Create the order
    final newOrder = Order(
      id: '', // Will be generated by the repository
      tableId: _selectedTableId!,
      items: _orderItems,
      subtotal: _calculateSubtotal(),
      tax: _calculateTax(),
      total: _calculateTotal(),
      status: OrderStatus.pending,
      notes: _notesController.text,
      createdAt: DateTime.now(),
    );
    
    try {
      await orderProvider.createOrder(newOrder);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to the orders list
        Navigator.pushReplacementNamed(context, AppRouter.ordersRoute);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating order: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Order'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Table Selection
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Table',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _showTableSelectionDialog,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedTableId != null
                                        ? 'Table $_selectedTableId'
                                        : 'Select a table',
                                    style: TextStyle(
                                      color: _selectedTableId != null
                                          ? Colors.black
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Items
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Items',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: _showAddItemDialog,
                                icon: const Icon(Icons.add),
                                label: const Text('Add Item'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (_items.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Text(
                                  'No items added yet',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _items.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final item = _items[index];
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.productName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '\$${item.unitPrice.toStringAsFixed(2)} each',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                          if (item.notes != null) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              'Note: ${item.notes}',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle_outline),
                                          onPressed: () => _updateItemQuantity(
                                            index,
                                            item.quantity - 1,
                                          ),
                                          color: Colors.red,
                                          iconSize: 20,
                                        ),
                                        Text(
                                          item.quantity.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle_outline),
                                          onPressed: () => _updateItemQuantity(
                                            index,
                                            item.quantity + 1,
                                          ),
                                          color: Colors.green,
                                          iconSize: 20,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '\$${item.total.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Notes
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _notesController,
                            decoration: InputDecoration(
                              hintText: 'Add notes for the order',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Order Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal'),
                    Text('\$${_calculateSubtotal().toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tax (${(_taxRate * 100).toInt()}%)'),
                    Text('\$${_calculateTax().toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '\$${_calculateTotal().toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _createOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Create Order',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

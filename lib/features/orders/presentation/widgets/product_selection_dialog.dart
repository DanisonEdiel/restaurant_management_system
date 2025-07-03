import 'package:flutter/material.dart';
import 'package:restaurant_management_system/features/orders/data/models/order_item_model.dart';
import 'package:restaurant_management_system/features/orders/domain/entities/order_item.dart';

class ProductSelectionDialog extends StatefulWidget {
  final Function(OrderItem) onProductSelected;

  const ProductSelectionDialog({
    super.key,
    required this.onProductSelected,
  });

  @override
  State<ProductSelectionDialog> createState() => _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<ProductSelectionDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  int _quantity = 1;
  String? _selectedProductId;
  String? _selectedProductName;
  double _selectedProductPrice = 0.0;
  List<String> _selectedModifiers = [];

  // Mock data for categories and products
  final List<Map<String, dynamic>> _categories = [
    {'id': '1', 'name': 'Main Dishes'},
    {'id': '2', 'name': 'Appetizers'},
    {'id': '3', 'name': 'Desserts'},
    {'id': '4', 'name': 'Drinks'},
    {'id': '5', 'name': 'Sides'},
  ];

  final Map<String, List<Map<String, dynamic>>> _products = {
    '1': [
      {'id': '101', 'name': 'Grilled Salmon', 'price': 18.99, 'image': 'assets/images/grilled_salmon.jpg'},
      {'id': '102', 'name': 'Beef Steak', 'price': 22.50, 'image': 'assets/images/beef_steak.jpg'},
      {'id': '103', 'name': 'Chicken Alfredo', 'price': 16.75, 'image': 'assets/images/chicken_alfredo.jpg'},
      {'id': '104', 'name': 'Vegetable Curry', 'price': 14.50, 'image': 'assets/images/vegetable_curry.jpg'},
    ],
    '2': [
      {'id': '201', 'name': 'Mozzarella Sticks', 'price': 8.99, 'image': 'assets/images/mozzarella_sticks.jpg'},
      {'id': '202', 'name': 'Chicken Wings', 'price': 10.50, 'image': 'assets/images/chicken_wings.jpg'},
      {'id': '203', 'name': 'Nachos', 'price': 9.75, 'image': 'assets/images/nachos.jpg'},
    ],
    '3': [
      {'id': '301', 'name': 'Chocolate Cake', 'price': 6.99, 'image': 'assets/images/chocolate_cake.jpg'},
      {'id': '302', 'name': 'Cheesecake', 'price': 7.50, 'image': 'assets/images/cheesecake.jpg'},
      {'id': '303', 'name': 'Ice Cream', 'price': 4.75, 'image': 'assets/images/ice_cream.jpg'},
    ],
    '4': [
      {'id': '401', 'name': 'Soda', 'price': 2.99, 'image': 'assets/images/soda.jpg'},
      {'id': '402', 'name': 'Iced Tea', 'price': 3.50, 'image': 'assets/images/iced_tea.jpg'},
      {'id': '403', 'name': 'Coffee', 'price': 3.75, 'image': 'assets/images/coffee.jpg'},
    ],
    '5': [
      {'id': '501', 'name': 'French Fries', 'price': 4.99, 'image': 'assets/images/french_fries.jpg'},
      {'id': '502', 'name': 'Onion Rings', 'price': 5.50, 'image': 'assets/images/onion_rings.jpg'},
      {'id': '503', 'name': 'Coleslaw', 'price': 3.75, 'image': 'assets/images/coleslaw.jpg'},
    ],
  };

  // Mock data for modifiers
  final List<Map<String, dynamic>> _modifiers = [
    {'id': '1', 'name': 'Extra Cheese', 'price': 1.50},
    {'id': '2', 'name': 'No Onions', 'price': 0.0},
    {'id': '3', 'name': 'Spicy', 'price': 0.50},
    {'id': '4', 'name': 'Gluten Free', 'price': 2.00},
    {'id': '5', 'name': 'Extra Sauce', 'price': 1.00},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _selectProduct(Map<String, dynamic> product) {
    setState(() {
      _selectedProductId = product['id'] as String;
      _selectedProductName = product['name'] as String;
      _selectedProductPrice = product['price'] as double;
    });
  }

  void _toggleModifier(String modifierId) {
    setState(() {
      if (_selectedModifiers.contains(modifierId)) {
        _selectedModifiers.remove(modifierId);
      } else {
        _selectedModifiers.add(modifierId);
      }
    });
  }

  double get _totalPrice {
    double modifiersPrice = 0.0;
    for (final modifierId in _selectedModifiers) {
      final modifier = _modifiers.firstWhere((m) => m['id'] == modifierId);
      modifiersPrice += modifier['price'] as double;
    }
    return (_selectedProductPrice + modifiersPrice) * _quantity;
  }

  void _addToOrder() {
    if (_selectedProductId == null) {
      return;
    }

    final List<Map<String, dynamic>> selectedModifiersList = [];
    for (final modifierId in _selectedModifiers) {
      final modifier = _modifiers.firstWhere((m) => m['id'] == modifierId);
      selectedModifiersList.add({
        'id': modifier['id'],
        'name': modifier['name'],
        'price': modifier['price'],
      });
    }

    final orderItem = OrderItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: _selectedProductId!,
      productName: _selectedProductName!,
      quantity: _quantity,
      unitPrice: _selectedProductPrice,
      total: _totalPrice,
      modifiers: selectedModifiersList.map((m) => {
        'id': m['id'] as String,
        'name': m['name'] as String,
        'price': m['price'] as double,
      }).toList(),
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    widget.onProductSelected(orderItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Product',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: _categories.map((category) => Tab(
                text: category['name'] as String,
              )).toList(),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _categories.map((category) {
                  final categoryId = category['id'] as String;
                  final categoryProducts = _products[categoryId] ?? [];
                  
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: categoryProducts.length,
                    itemBuilder: (context, index) {
                      final product = categoryProducts[index];
                      final isSelected = _selectedProductId == product['id'];
                      
                      return GestureDetector(
                        onTap: () => _selectProduct(product),
                        child: Card(
                          elevation: isSelected ? 4 : 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.restaurant_menu,
                                      size: 48,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${(product['price'] as double).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            if (_selectedProductId != null) ...[
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedProductName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${_selectedProductPrice.toStringAsFixed(2)} each',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                          }
                        },
                        color: Colors.red,
                      ),
                      Text(
                        _quantity.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Modifiers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _modifiers.length,
                  itemBuilder: (context, index) {
                    final modifier = _modifiers[index];
                    final modifierId = modifier['id'] as String;
                    final isSelected = _selectedModifiers.contains(modifierId);
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          '${modifier['name']} ${(modifier['price'] as double) > 0 ? '+\$${(modifier['price'] as double).toStringAsFixed(2)}' : ''}',
                        ),
                        selected: isSelected,
                        onSelected: (_) => _toggleModifier(modifierId),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: 'Add notes (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${_totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addToOrder,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Add to Order'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

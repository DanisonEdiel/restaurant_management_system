import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_system/core/theme/app_theme.dart';
import 'package:restaurant_management_system/features/orders/domain/entities/order.dart';
import 'package:restaurant_management_system/features/orders/presentation/providers/order_provider.dart';
import 'package:restaurant_management_system/features/orders/presentation/widgets/order_card.dart';
import 'package:restaurant_management_system/features/orders/presentation/widgets/order_filter.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  OrderStatus? _selectedStatus;
  DateTime? _startDate;
  DateTime? _endDate;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    
    // Load orders when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _loadOrders() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.getOrders(
      startDate: _startDate,
      endDate: _endDate,
      status: _selectedStatus,
    );
  }
  
  void _onFilterApplied(OrderStatus? status, DateTime? startDate, DateTime? endDate) {
    setState(() {
      _selectedStatus = status;
      _startDate = startDate;
      _endDate = endDate;
    });
    _loadOrders();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Management'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
          onTap: (index) {
            setState(() {
              switch (index) {
                case 0:
                  _selectedStatus = null;
                  break;
                case 1:
                  _selectedStatus = OrderStatus.pending;
                  break;
                case 2:
                  _selectedStatus = OrderStatus.inProgress;
                  break;
                case 3:
                  _selectedStatus = OrderStatus.completed;
                  break;
                case 4:
                  _selectedStatus = OrderStatus.cancelled;
                  break;
              }
            });
            _loadOrders();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => OrderFilter(
                  initialStatus: _selectedStatus,
                  initialStartDate: _startDate,
                  initialEndDate: _endDate,
                  onApplyFilter: _onFilterApplied,
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (orderProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${orderProvider.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      orderProvider.clearError();
                      _loadOrders();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (orderProvider.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No orders found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Try changing your filters or create a new order',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.createOrderRoute);
                    },
                    child: const Text('Create New Order'),
                  ),
                ],
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              _loadOrders();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orderProvider.orders.length,
              itemBuilder: (context, index) {
                final order = orderProvider.orders[index];
                return OrderCard(
                  order: order,
                  onTap: () {
                    orderProvider.setCurrentOrder(order);
                    Navigator.pushNamed(
                      context,
                      AppRouter.orderDetailsRoute,
                      arguments: {'orderId': order.id},
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.createOrderRoute);
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

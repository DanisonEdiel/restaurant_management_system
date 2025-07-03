import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_system/core/navigation/app_router.dart';
import 'package:restaurant_management_system/core/theme/app_theme.dart';
import 'package:restaurant_management_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurant_management_system/features/dashboard/presentation/widgets/dashboard_card.dart';
import 'package:restaurant_management_system/features/orders/presentation/providers/order_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  
  final List<String> _appBarTitles = [
    'Dashboard',
    'Orders',
    'Billing',
    'Inventory',
    'Tables',
    'Providers',
    'Reports',
    'Notifications',
    'Utilities',
  ];
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.name ?? 'User Name'),
              accountEmail: Text(user?.email ?? 'user@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  (user?.name?.isNotEmpty == true) 
                      ? user!.name[0].toUpperCase() 
                      : 'U',
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Orders'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Billing'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Inventory'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_bar),
              title: const Text('Table Management'),
              selected: _selectedIndex == 4,
              onTap: () {
                _onItemTapped(4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Providers & Purchasing'),
              selected: _selectedIndex == 5,
              onTap: () {
                _onItemTapped(5);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Reports'),
              selected: _selectedIndex == 6,
              onTap: () {
                _onItemTapped(6);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              selected: _selectedIndex == 7,
              onTap: () {
                _onItemTapped(7);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Utilities'),
              selected: _selectedIndex == 8,
              onTap: () {
                _onItemTapped(8);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await authProvider.logout();
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
                }
              },
            ),
          ],
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex < 5 ? _selectedIndex : 0,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBar.item(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBar.item(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBar.item(
            icon: Icon(Icons.payment),
            label: 'Billing',
          ),
          BottomNavigationBar.item(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBar.item(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  void _onBottomNavTapped(int index) {
    if (index == 4) {
      // Show more options dialog
      _showMoreOptionsDialog();
    } else {
      _onItemTapped(index);
    }
  }
  
  void _showMoreOptionsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'More Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMoreOption(
                    icon: Icons.table_bar,
                    label: 'Tables',
                    index: 4,
                  ),
                  _buildMoreOption(
                    icon: Icons.local_shipping,
                    label: 'Providers',
                    index: 5,
                  ),
                  _buildMoreOption(
                    icon: Icons.bar_chart,
                    label: 'Reports',
                    index: 6,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMoreOption(
                    icon: Icons.notifications,
                    label: 'Notifications',
                    index: 7,
                  ),
                  _buildMoreOption(
                    icon: Icons.build,
                    label: 'Utilities',
                    index: 8,
                  ),
                  const SizedBox(width: 80), // Empty space for alignment
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildMoreOption({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _onItemTapped(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            radius: 30,
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
  
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildOrders();
      case 2:
        return _buildBilling();
      case 3:
        return _buildInventory();
      case 4:
        return _buildTableManagement();
      case 5:
        return _buildProviders();
      case 6:
        return _buildReports();
      case 7:
        return _buildNotifications();
      case 8:
        return _buildUtilities();
      default:
        return _buildDashboard();
    }
  }
  
  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to Restaurant Management System',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage your restaurant operations efficiently',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          
          // Quick Stats
          const Text(
            'Quick Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Today\'s Orders',
                  value: '24',
                  icon: Icons.receipt_long,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Today\'s Revenue',
                  value: '\$1,250',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Active Tables',
                  value: '8/12',
                  icon: Icons.table_bar,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Low Stock Items',
                  value: '5',
                  icon: Icons.warning_amber,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Quick Access
          const Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              DashboardCard(
                title: 'New Order',
                icon: Icons.add_shopping_cart,
                color: AppTheme.primaryColor,
                onTap: () {
                  _onItemTapped(1);
                },
              ),
              DashboardCard(
                title: 'Tables',
                icon: Icons.table_bar,
                color: Colors.orange,
                onTap: () {
                  _onItemTapped(4);
                },
              ),
              DashboardCard(
                title: 'Inventory',
                icon: Icons.inventory,
                color: Colors.purple,
                onTap: () {
                  _onItemTapped(3);
                },
              ),
              DashboardCard(
                title: 'Billing',
                icon: Icons.payment,
                color: Colors.green,
                onTap: () {
                  _onItemTapped(2);
                },
              ),
              DashboardCard(
                title: 'Reports',
                icon: Icons.bar_chart,
                color: Colors.blue,
                onTap: () {
                  _onItemTapped(6);
                },
              ),
              DashboardCard(
                title: 'Settings',
                icon: Icons.settings,
                color: Colors.grey,
                onTap: () {
                  _onItemTapped(8);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Recent Orders
          const Text(
            'Recent Orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentOrdersList(),
        ],
      ),
    );
  }
  
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRecentOrdersList() {
    // Mock data for recent orders
    final List<Map<String, dynamic>> recentOrders = [
      {
        'id': 'ORD-001',
        'table': 'Table 5',
        'amount': '\$45.50',
        'status': 'Completed',
        'time': '10:30 AM',
      },
      {
        'id': 'ORD-002',
        'table': 'Table 3',
        'amount': '\$78.25',
        'status': 'In Progress',
        'time': '11:15 AM',
      },
      {
        'id': 'ORD-003',
        'table': 'Table 8',
        'amount': '\$32.00',
        'status': 'Pending',
        'time': '11:45 AM',
      },
    ];
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentOrders.length,
      itemBuilder: (context, index) {
        final order = recentOrders[index];
        Color statusColor;
        
        switch (order['status']) {
          case 'Completed':
            statusColor = Colors.green;
            break;
          case 'In Progress':
            statusColor = Colors.blue;
            break;
          case 'Pending':
            statusColor = Colors.orange;
            break;
          default:
            statusColor = Colors.grey;
        }
        
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['id'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  order['amount'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order['table']),
                  Text(order['time']),
                ],
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                order['status'],
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(
                context, 
                AppRouter.orderDetailsRoute,
                arguments: {'orderId': order['id']},
              );
            },
          ),
        );
      },
    );
  }
  
  // Orders section
  Widget _buildOrders() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Orders Management',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('New Order'),
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.createOrderRoute);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.ordersRoute);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('View All Orders'),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBilling() {
    return const Center(
      child: Text('Billing Management - Coming Soon'),
    );
  }
  
  Widget _buildInventory() {
    return const Center(
      child: Text('Inventory Management - Coming Soon'),
    );
  }
  
  Widget _buildTableManagement() {
    return const Center(
      child: Text('Table Management - Coming Soon'),
    );
  }
  
  Widget _buildProviders() {
    return const Center(
      child: Text('Providers & Purchasing - Coming Soon'),
    );
  }
  
  Widget _buildReports() {
    return const Center(
      child: Text('Reports - Coming Soon'),
    );
  }
  
  Widget _buildNotifications() {
    return const Center(
      child: Text('Notifications - Coming Soon'),
    );
  }
  
  Widget _buildUtilities() {
    return const Center(
      child: Text('Utilities - Coming Soon'),
    );
  }
}

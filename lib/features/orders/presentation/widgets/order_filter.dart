import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_management_system/core/theme/app_theme.dart';
import 'package:restaurant_management_system/features/orders/domain/entities/order.dart';

class OrderFilter extends StatefulWidget {
  final OrderStatus? initialStatus;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(OrderStatus?, DateTime?, DateTime?) onApplyFilter;

  const OrderFilter({
    super.key,
    this.initialStatus,
    this.initialStartDate,
    this.initialEndDate,
    required this.onApplyFilter,
  });

  @override
  State<OrderFilter> createState() => _OrderFilterState();
}

class _OrderFilterState extends State<OrderFilter> {
  OrderStatus? _selectedStatus;
  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // If end date is before start date, update end date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          // If start date is after end date, update start date
          if (_startDate != null && _startDate!.isAfter(_endDate!)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedStatus = null;
      _startDate = null;
      _endDate = null;
    });
  }

  void _applyFilters() {
    widget.onApplyFilter(_selectedStatus, _startDate, _endDate);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _resetFilters,
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildStatusChip(null, 'All'),
              _buildStatusChip(OrderStatus.pending, 'Pending'),
              _buildStatusChip(OrderStatus.inProgress, 'In Progress'),
              _buildStatusChip(OrderStatus.ready, 'Ready'),
              _buildStatusChip(OrderStatus.delivered, 'Delivered'),
              _buildStatusChip(OrderStatus.completed, 'Completed'),
              _buildStatusChip(OrderStatus.cancelled, 'Cancelled'),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Date Range',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _startDate != null
                              ? _dateFormat.format(_startDate!)
                              : 'Start Date',
                          style: TextStyle(
                            color: _startDate != null
                                ? Colors.black
                                : Colors.grey.shade600,
                          ),
                        ),
                        const Icon(Icons.calendar_today, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _endDate != null
                              ? _dateFormat.format(_endDate!)
                              : 'End Date',
                          style: TextStyle(
                            color: _endDate != null
                                ? Colors.black
                                : Colors.grey.shade600,
                          ),
                        ),
                        const Icon(Icons.calendar_today, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus? status, String label) {
    final isSelected = _selectedStatus == status;
    
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = selected ? status : null;
        });
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

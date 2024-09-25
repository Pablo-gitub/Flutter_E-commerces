import 'package:flutter/material.dart';
import 'package:store_app_web/views/side_bar_screens/widgets/order_list_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const String id = 'orders-screen';
  const OrdersScreen({super.key});

  Widget rowHeader(int flex, String text) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3C55EF),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'Manage Orders',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            children: [
              rowHeader(1, 'Image'),
              rowHeader(1, 'Full Name'),
              rowHeader(2, 'Address'),
              rowHeader(2, 'Action'),
              rowHeader(2, 'Reject'),
            ],
          ),
          OrderListWidget(),
        ],
      ),
    );
  }
}

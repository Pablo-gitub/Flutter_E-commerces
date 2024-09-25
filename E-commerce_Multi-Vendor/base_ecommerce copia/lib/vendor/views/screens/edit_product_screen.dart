import 'package:base_ecommerce/vendor/views/screens/edit_products_tabs/published_tab.dart';
import 'package:base_ecommerce/vendor/views/screens/edit_products_tabs/unpublished_tab.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.yellow.shade900,
          title: Text(
            'Manage Products',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 7,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Published'),
              ),
              Tab(
                child: Text('Unpublished'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PublishedTab(),
            UnpublishedTab(),
          ],
        ),
      ),
    );
  }
}

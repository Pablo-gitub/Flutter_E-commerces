//import 'dart:html';

import 'package:ecommerce_web_admin/views/screens/side_bar_screens/categories_screen.dart';
import 'package:ecommerce_web_admin/views/screens/side_bar_screens/dashboard_screen.dart';
import 'package:ecommerce_web_admin/views/screens/side_bar_screens/orders_screen.dart';
import 'package:ecommerce_web_admin/views/screens/side_bar_screens/products_screen.dart';
import 'package:ecommerce_web_admin/views/screens/side_bar_screens/upload_banner_screen.dart';
import 'package:ecommerce_web_admin/views/screens/side_bar_screens/vendors_screen.dart';
import 'package:ecommerce_web_admin/views/screens/side_bar_screens/withdrawal_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedItem = DashboardScreen();

  screenSelector(item) {
    switch (item.route) {
      case DashboardScreen.routeName:
        setState(() {
          _selectedItem = DashboardScreen();
        });
        break;

      case CategoriesScreen.routeName:
        setState(() {
          _selectedItem = CategoriesScreen();
        });
        break;

      case OrdersScreen.routeName:
        setState(() {
          _selectedItem = OrdersScreen();
        });
        break;

      case ProductsScreen.routeName:
        setState(() {
          _selectedItem = ProductsScreen();
        });
        break;

      case UploadBannersScreen.routeName:
        setState(() {
          _selectedItem = UploadBannersScreen();
        });
        break;

      case VendorsScreen.routeName:
        setState(() {
          _selectedItem = VendorsScreen();
        });
        break;

      case WithdrawalScreen.routeName:
        setState(() {
          _selectedItem = WithdrawalScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.yellow.shade900,
      //   title: Text(
      //     'Management',
      //   ),
      // ),
      sideBar: SideBar(
        items: [
          AdminMenuItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            route: DashboardScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Vendors',
            icon: CupertinoIcons.person_3,
            route: VendorsScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Withdrawal',
            icon: CupertinoIcons.money_euro,
            route: WithdrawalScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Orders',
            icon: CupertinoIcons.shopping_cart,
            route: OrdersScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Categories',
            icon: Icons.category,
            route: CategoriesScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Products',
            icon: Icons.shop,
            route: ProductsScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Upload Banners',
            icon: CupertinoIcons.add,
            route: UploadBannersScreen.routeName,
          ),
        ],
        selectedRoute: '',
        onSelected: (item) {
          screenSelector(item);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Store Panel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'footer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _selectedItem,
    );
  }
}

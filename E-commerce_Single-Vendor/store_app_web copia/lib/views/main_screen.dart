import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:store_app_web/views/side_bar_screens/buyers_screen.dart';
import 'package:store_app_web/views/side_bar_screens/category_screen.dart';
import 'package:store_app_web/views/side_bar_screens/orders_screen.dart';
import 'package:store_app_web/views/side_bar_screens/products_screen.dart';
import 'package:store_app_web/views/side_bar_screens/upload_banner_screen.dart';
import 'package:store_app_web/views/side_bar_screens/vendors_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = OrdersScreen();

  screenSelector(item) {
    switch (item.route) {
      // case VendorsScreen.id:
      //   setState(() {
      //     _selectedScreen = const VendorsScreen();
      //   });
      //   break;
      case BuyersScreen.id:
        setState(() {
          _selectedScreen = const BuyersScreen();
        });
        break;
      case OrdersScreen.id:
        setState(() {
          _selectedScreen = const OrdersScreen();
        });
        break;
      case CategoryScreen.id:
        setState(() {
          _selectedScreen = const CategoryScreen();
        });
        break;
      case UploadBannerScreen.id:
        setState(() {
          _selectedScreen = const UploadBannerScreen();
        });
        break;
      case ProductsScreen.id:
        setState(() {
          _selectedScreen = const ProductsScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text(
          'Management',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 4,
          ),
        ),
      ),
      body: _selectedScreen,
      sideBar: SideBar(
        header: Container(
          height: 50,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: const Center(
            child: Text(
              'Chook Admin',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.7,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: Colors.black,
          child: const Center(
            child: Text(
              'Footer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        items: const [
          // AdminMenuItem(
          //   title: 'Vendors',
          //   route: VendorsScreen.id,
          //   icon: CupertinoIcons.person_3,
          // ),
          AdminMenuItem(
            title: 'Buyers',
            route: BuyersScreen.id,
            icon: CupertinoIcons.person,
          ),
          AdminMenuItem(
            title: 'Orders',
            route: OrdersScreen.id,
            icon: CupertinoIcons.shopping_cart,
          ),
          AdminMenuItem(
            title: 'Categories',
            route: CategoryScreen.id,
            icon: Icons.category,
          ),
          AdminMenuItem(
            title: 'Upload Banner',
            route: UploadBannerScreen.id,
            icon: Icons.upload,
          ),
          AdminMenuItem(
            title: 'Products',
            route: ProductsScreen.id,
            icon: Icons.store,
          ),
        ],
        selectedRoute: OrdersScreen.id,
        onSelected: (item) {
          screenSelector(item);
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:store_app/views/screens/nav_screens/account_screen.dart';
import 'package:store_app/views/screens/nav_screens/cart_screen.dart';
import 'package:store_app/views/screens/nav_screens/favorite_screen.dart';
import 'package:store_app/views/screens/nav_screens/home_screen.dart';
import 'package:store_app/views/screens/nav_screens/comunity_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const FavoriteScreen(),
    const ComunityScreen(),
    const CartScreen(),
    AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Semantics(
                  label: translate("Home"),
                  child: const Icon(CupertinoIcons.home)),
              label: translate("Home")),
          BottomNavigationBarItem(
              icon: Semantics(
                label: translate("Favorites"),
                child: Image.asset(
                  "assets/icons/love.png",
                  width: 25,
                ),
              ),
              label: translate("Favorites")),
          BottomNavigationBarItem(
              icon: Semantics(
                label: translate("Comunity"),
                child: const Icon(CupertinoIcons.chat_bubble_2),
              ),
              label: translate("Comunity")),
          BottomNavigationBarItem(
              icon: Semantics(
                label: translate("Cart"),
                child: Image.asset(
                  "assets/icons/cart.png",
                  width: 25,
                ),
              ),
              label: translate("Cart")),
          BottomNavigationBarItem(
              icon: Semantics(
                label: translate("Account"),
                child: Image.asset(
                  "assets/icons/user.png",
                  width: 25,
                ),
              ),
              label: translate("Account")),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}

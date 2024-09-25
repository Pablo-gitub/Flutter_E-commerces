import 'package:base_ecommerce/views/buyers/nav_screens/widgets/banner_widget.dart';
import 'package:base_ecommerce/views/buyers/nav_screens/widgets/category_text.dart';
import 'package:base_ecommerce/views/buyers/nav_screens/widgets/search_input_widget.dart';
import 'package:base_ecommerce/views/buyers/nav_screens/widgets/welcome_text_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeText(),
          SizedBox(
            height: 5,
          ),
          SearchInputWidget(),
          BannerWidget(),
          CategoryText(),
        ],
      ),
    );
  }
}



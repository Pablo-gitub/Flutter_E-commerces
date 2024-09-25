import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:store_app/views/screens/nav_screens/widgets/banner_widget.dart';
import 'package:store_app/views/screens/nav_screens/widgets/category_item.dart';
import 'package:store_app/views/screens/nav_screens/widgets/header_widget.dart';
import 'package:store_app/views/screens/nav_screens/widgets/popular_product_widget.dart';
import 'package:store_app/views/screens/nav_screens/widgets/recommended_product_widget.dart';
import 'package:store_app/views/screens/nav_screens/widgets/reuseable_text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Definisci l'altezza desiderata
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Semantics(
            label: translate('Header'),
            child: const HeaderWidget(),
          ), // Inserisci l'header come contenuto flessibile
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Semantics(
              label: translate('Promotional Banner'),
              child: const BannerWidget(),
            ),
            Semantics(
              label: 'Category Items',
              child: CategoryItem(),
            ),
            Semantics(
              label: translate('Recommended For You section'),
              child: ReuseableTextWidget(
                title: translate('Recommended For You'),
                subtitle: translate('View All'),
              ),
            ),
            Semantics(
              label: translate('Recommended Products'),
              child: const RecommendedProductWidget(),
            ),
            Semantics(
              label: translate('Popular Products section'),
              child: ReuseableTextWidget(
                title: translate('Popular Products'),
                subtitle: translate('View All'),
              ),
            ),
            Semantics(
              label: translate('Popular Products'),
              child: const PopularProductWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

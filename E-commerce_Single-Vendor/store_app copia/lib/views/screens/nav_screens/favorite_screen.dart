import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:store_app/provider/favorites_providers.dart';
import 'package:store_app/views/screens/main_screen.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteData = ref.read(favoriteProvider.notifier);
    final wishItemData = ref.watch(favoriteProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/cartb.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 310,
                top: 42,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/icons/love.png',
                      width: 40,
                      height: 40,
                      color: Colors.white,
                    ),
                    Positioned(
                      top: -6,
                      right: 0,
                      child: badges.Badge(
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: Colors.yellow.shade800,
                        ),
                        badgeContent: Text(
                          wishItemData.length.toString(),
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 31,
                top: 41,
                child: Text(
                  'My Favorite',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: wishItemData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your wish list is empty\n you can add product to your wish list from the button below',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 17,
                      letterSpacing: 1.7,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MainScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Add Now',
                      style: GoogleFonts.lato(
                        fontSize: 17,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: wishItemData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final wishData = wishItemData.values.toList()[index];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Container(
                      width: 335,
                      height: 96,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(),
                      child: SizedBox(
                        width: double.infinity,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 336,
                                height: 96,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(
                                      0xFFEFF0F2,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 13,
                              top: 9,
                              child: Container(
                                width: 78,
                                height: 78,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFBCC5FF,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 275,
                              top: 14,
                              child: Text(
                                '${wishData.productPrice} €',
                                style: GoogleFonts.getFont(
                                  'Lato',
                                  color: const Color(0xFF0B0C13),
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 101,
                              top: 14,
                              child: SizedBox(
                                width: 162,
                                child: Text(
                                  wishData.productName,
                                  style: GoogleFonts.getFont(
                                    'Lato',
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 23,
                              top: 14,
                              child: Image.network(
                                wishData.imageUrl[0],
                                width: 58,
                                height: 67,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              left: 284,
                              top: 47,
                              child: InkWell(
                                onTap: () {
                                  favoriteData.removeItem(wishData.productId);
                                },
                                child: Image.asset(
                                  'assets/icons/delete.png',
                                  color: Colors.red,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

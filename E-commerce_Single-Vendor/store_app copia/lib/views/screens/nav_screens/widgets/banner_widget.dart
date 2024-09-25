import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_app/controllers/banner_controller.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final BannerController _bannerController = BannerController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0, bottom: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFFF7F7F7),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 6,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: StreamBuilder<List<String>>(
          stream: _bannerController.getBannersUrls(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else if (snapshot.hasError) {
              return const Icon(
                Icons.error,
                color: Colors.red,
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No Banner availlable',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              );
            } else {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data![index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                  _buildPageIndicator(snapshot.data!.length),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int pageCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pageCount, (index) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: const BoxDecoration(
              color: Color.fromARGB(44, 0, 0, 0),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}

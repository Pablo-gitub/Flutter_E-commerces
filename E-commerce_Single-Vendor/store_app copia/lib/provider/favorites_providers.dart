import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/models/favorite_models.dart';

final favoriteProvider =
    StateNotifierProvider<FavoritesNotifier, Map<String, FavoriteModel>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<Map<String, FavoriteModel>> {
  FavoritesNotifier() : super({});

  //Add product to favorite
  void addProductToFavorite({
    required String productName,
    required String productId,
    required List imageUrl,
    required double productPrice,
  }) {
    state[productId] = FavoriteModel(
        productName: productName,
        productId: productId,
        imageUrl: imageUrl,
        productPrice: productPrice);

    //notify listeners that state has changed

    state = {...state};
  }

  //remove all items from favorites
  void removeAllItems() {
    state.clear();
    //notify listeners that state has changed
    state = {...state};
  }

  //function to remove element to favorite
  void removeItem(String productId) {
    state.remove(productId);
    //notify listeners that state has changed
    state = {...state};
  }

  //retrieve value from the state object
  Map<String, FavoriteModel> get getFavoriteItem => state;
}

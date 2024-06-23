import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  // FakeProductsRepository._();

  // static FakeProductsRepository instance = FakeProductsRepository._();

  final List<Product> _fakeProducts = kTestProducts;

  // List<Product> getProductsList() {
  //   return _fakeProducts;
  // }

  Product? getProduct(String productId) {
    return _fakeProducts.firstWhereOrNull((product) => product.id == productId);
  }

  Future<List<Product>> fetchProductList() async {
    await Future.delayed(const Duration(seconds: 2));
    //* for testing error
    // throw Exception('Error fetching products');
    return Future.value(_fakeProducts);
  }

//* only emit one value
  Stream<List<Product>> watchProductList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _fakeProducts;
  }

//* only emit one value
  Stream<Product?> watchProduct(String productId) {
    return watchProductList().map((products) =>
        products.firstWhereOrNull((product) => product.id == productId));
  }

//   Product? getProduct(String id) {
//     try {
//       return kTestProducts.firstWhere((product) => product.id == id);
//     } catch (e) {
//       return null;
//     }
//   }
// }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productsListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  debugPrint('created productsListStreamProvider');
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductList();
});

final productsListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.fetchProductList();
});

final productProvider = StreamProvider.family<Product?, String>((ref, id) {
  debugPrint('created productProvider with id: $id');
  ref.onResume(() => debugPrint('resume productProvider($id)'));
  ref.onCancel(() => debugPrint('cancel productProvider($id)'));
  ref.onDispose(() => debugPrint('disposed productProvider($id)'));

  // // keep the provider alive when it's no longer used
  // final link = ref.keepAlive();
  // // use a timer to dispose it after 10 seconds
  // final timer = Timer(const Duration(seconds: 10), () {
  //   link.close();
  // });
  // // make sure the timer is cancelled when the provider state is disposed
  // ref.onDispose(() => timer.cancel());

  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProduct(id);
});

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeProductsRepository', () {
    final productsRepository = FakeProductsRepository(addDelay: false);
    test('getProductsList returns global list', () {
      expect(
        productsRepository.getProductsList(),
        kTestProducts,
      );
    });

    test('getProduct(1) returns first item', () {
      expect(
        productsRepository.getProduct('1'),
        kTestProducts[0],
      );
    });

    test('getProduct(100) returns null', () {
      expect(
        productsRepository.getProduct('100'),
        null,
      );
    });
  });

  group('test future and stream function on getting products', () {
    final productsRepository = FakeProductsRepository(addDelay: false);

    test('fetchProductList returns global list', () async {
      final products = await productsRepository.fetchProductList();
      expect(products, kTestProducts);
    });

    test('watchProductList emits global list', () async {
      final stream = productsRepository.watchProductList();
      final products = await stream.first;
      expect(products, kTestProducts);
    });

    test('watchProductList emits global list, using emits function', () {
      expect(
        productsRepository.watchProductList(),
        emits(kTestProducts),
      );
    });

    test('watchProduct(1), emits 1st item', () {
      expect(
        productsRepository.watchProduct('1'),
        emits(kTestProducts[0]),
      );
    });

    test('watchProduct(100), emits null', () {
      expect(
        productsRepository.watchProduct('100'),
        emits(null),
      );
    });
  });
}

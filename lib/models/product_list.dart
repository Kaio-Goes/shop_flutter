import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import '../utils/constants.dart';

class ProductList with ChangeNotifier {
  String token;
  List<Product> item = [];

  List<Product> get items => [...item];
  List<Product> get favoriteItems =>
      item.where((element) => element.isFavorite).toList();

  ProductList(this.token, this.item);

  int get itemsCount {
    return item.length;
  }

  Future<void> loadProducts() async {
    item.clear();

    final response =
        await http.get(Uri.parse("${Constants.productBaseUrl}.json?=auth=$token"));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      item.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );
    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final response =
        await http.post(Uri.parse('${Constants.productBaseUrl}.json'),
            body: jsonEncode({
              "name": product.name,
              "description": product.description,
              "price": product.price,
              "imageUrl": product.imageUrl,
              "isFavorite": product.isFavorite,
            }));

    final id = jsonDecode(response.body)['name'];
    item.add(
      Product(
          id: id,
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = item.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      await http.patch(
          Uri.parse('${Constants.productBaseUrl}/${product.id}.json'),
          body: jsonEncode({
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "isFavorite": product.isFavorite,
          }));

      item[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = item.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      final product = item[index];

      item.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.productBaseUrl}/${product.id}.json'),
      );

      if (response.statusCode >= 400) {
        item.insert(index, product);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o produto.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/model/http_exception.dart';
import 'package:shop/provider/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];
  late String token;
  late String userId;

  getData(String authtoken, String userId, List<Product> products) {
    token = authtoken;
    userId = userId;
    _items = products;
    notifyListeners();
  }

  List<Product> get item {
    return [..._items];
  }

  List<Product> get favItem {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filteredString =
        filterByUser ? 'orderBy ="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shop-68e28-default-rtdb.firebaseio.com/products.json?auth=$token&$filteredString';
    try {
      final res = await http.get(Uri.parse(url));

      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://shop-68e28-default-rtdb.firebaseio.com/favProduct/$userId.json?auth =$token';
      final favRes = await http.get(Uri.parse(url));
      final favData = json.decode(favRes.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, proData) {
        loadedProducts.add(Product(
            id: prodId,
            title: proData['title'],
            description: proData['description'],
            price: proData['price'],
            isFavorite: favData == null ? false : favData[prodId] ?? false,
            imageUrl: proData['imageUrl']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-68e28-default-rtdb.firebaseio.com/products.json?auth =$token';

    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));
      final newProduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final extractedIndex = _items.indexWhere((pro) => pro.id == id);
    if (extractedIndex >= 0) {
      final url =
          'https://shop-68e28-default-rtdb.firebaseio.com/products/$id.json?auth =$token';

      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
      _items[extractedIndex] = product;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-68e28-default-rtdb.firebaseio.com/products/$id.json?auth =$token';
    final extractedIndex = _items.indexWhere((pro) => pro.id == id);
    Product? elementToDelete = _items[extractedIndex];
    _items.removeAt(extractedIndex);
    notifyListeners();
    final res = await http.delete(Uri.parse(url));
    if(res.statusCode>=400){
      _items.insert(extractedIndex, elementToDelete);
      notifyListeners();
      throw HttpException("Could not delete Product");

    }
    elementToDelete =null;
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _items = [];
  late String token;
  late String userId;

  getData(String authtoken, String userId, List<OrderItem> orders) {
    token = authtoken;
    userId = userId;
    _items = orders;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._items];
  }

  Future<void> fetchAndSetOrders() async {
    var url =
        'https://shop-68e28-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token&';
    try {
      final res = await http.get(Uri.parse(url));

      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((prodId, proData) {
        loadedOrders.add(
          OrderItem(
              id: prodId,
              amount: proData['amount'],
              dateTime: DateTime.parse(proData['dateTime']),
              products: (proData['products'] as List<dynamic>)
                  .map((item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price']))
                  .toList()),
        );
      });
      _items = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem>cartProduct,double total) async {
    final url =
        'https://shop-68e28-default-rtdb.firebaseio.com/orders/$userId.json?auth =$token';

    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': DateTime.now().toIso8601String(),
            'products': cartProduct.map((cp) => {
              'id':cp.id,
              'title':cp.title,
              'quantity':cp.quantity,
              'price':cp.price,
            }).toList(),

          }));
      _items.insert(0, OrderItem(
          id: json.decode(res.body)['name'],
          amount: total,
          products: cartProduct,
          dateTime: DateTime.now())) ;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }







}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cart.dart';
import 'dart:convert';


class OrderItem {
  final String id;
  final double total;
  final List<CartItemz> products;
  final DateTime dateTime;

  OrderItem({ required this.id, required this.total, required this.products, required this.dateTime});

}

class Orders with ChangeNotifier{

  final String? authToken;
  final List previousOrders;

  Orders(this.authToken, this.previousOrders);

  List<OrderItem> _orders = [];

  List<OrderItem> get order {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async{
    final url = 'https://e-shop-432c0-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    if (response.body.isEmpty) {
      return;
    }
    List<OrderItem> loadedData = [];
    final extractedData = await json.decode(response.body) as Map<String, dynamic>;
    // print(extractedData);
    extractedData.forEach((orderId, orderData) {
      loadedData.add(
        OrderItem(
            id: orderId,
            total: orderData['total'],
            dateTime: DateTime.parse(orderData['dateTime']),
           products: (orderData['products'] as List<dynamic>).map((cartData) {
             return CartItemz(
                 id: orderId,
                 title: cartData['title'],
                 quantity: cartData['quantity'],
                 price: cartData['price'] == String ? double.tryParse(cartData['price']) : cartData['price']
             );
           }).toList()
        ),
      );
    });
    _orders = loadedData.toList();
    notifyListeners();
  }


  Future<void> addOrder(List<CartItemz> cartProducts, double total) async {
    final url = 'https://e-shop-432c0-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
      final timeStamp = DateTime.now().toIso8601String();
      try {
        /*final orders =*/
        await http.post(Uri.parse(url), body: json.encode({
          'id': timeStamp,
          'total': total,
          'dateTime': timeStamp,
          'products': cartProducts.map((cp) => {
            'id': cp.id,
            'title': cp.title,
            'quantity': cp.quantity,
            'price': cp.price
          }).toList()
        }),
        );

      } catch (e) {
        rethrow;
      }
    // _orders.insert(0, OrderItem(
    //     id: DateTime.now().toString(),
    //     total: total,
    //     products: cartProducts,
    //     dateTime: DateTime.now()
    //   )
    // );
    // notifyListeners();
  }

}
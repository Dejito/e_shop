import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite(String token, String userId) async {
    final url = 'https://e-shop-432c0-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$token';
    bool oldValue = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try{
      final response = await http.put(Uri.parse(url), body: json.encode({
        isFavorite
      }));
      notifyListeners();
      if (response.statusCode > 400) {
        isFavorite = oldValue;
        notifyListeners();
      }
    } catch (e) {
      isFavorite = oldValue;
      notifyListeners();
    }


  }

}

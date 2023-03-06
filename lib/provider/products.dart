import 'dart:io';

import 'package:flutter/material.dart';
import 'product.dart';
import 'package:e_shop/provider/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String authToken;
  final String? gitTest;
  final List? previousItems;
  final String userId;


  Products(this.authToken, this.previousItems, this.userId, this.gitTest);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get getFavorites {
    return items.where((items) => items.isFavorite).toList();
  }

  Product findById (String id){
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterBy = false]) async {
    final filterString = filterBy ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    print(userId);
    var url = 'https://e-shop-432c0-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try{
     final response = await http.get(Uri.parse(url));
     final products = json.decode(response.body)as Map<String, dynamic>;
     if (products.isEmpty){
       return;
     }
     url = 'https://e-shop-432c0-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
    final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);
     List<Product> loadedProducts = [];
      products.forEach((prodId, backendProd) {
        loadedProducts.add(Product(
            id: prodId,
            title: backendProd['title'],
            description: backendProd['description'],
            price: backendProd['price'] == String ? double.parse(backendProd['price']).toDouble() : backendProd['price'],
            imageUrl: backendProd['imageUrl'],
            // isFavorite: favoriteData != null ? false : favoriteData[prodId] ?? false,
        ));
      },
      );
     _items = loadedProducts;
     notifyListeners();
    }catch (e) {
      rethrow;

    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://e-shop-432c0-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url), body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'creatorId': userId
      })
      );
      if (response.body.isEmpty) {
        return;
      }
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        id: DateTime.now().toString(),
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  Future<void> updateProduct (String id, Product newProduct) async{
    final url = 'https://e-shop-432c0-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    try{
      if (prodIndex >= 0) {

       await http.patch(Uri.parse(url),body:json.encode(
            {
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl
            })
        );
        _items[prodIndex] = newProduct;
        notifyListeners();
      } else {
      }
    } catch(e){

      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://e-shop-432c0-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prodId) => id == prodId.id);
    var existingProduct = _items[existingProductIndex];
    //remove albeit temporarily from local storage
    _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw const HttpException('Unsuccessful request');
      }
      existingProduct.dispose();

  }
    }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Auth with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime.now();
  String _userId = '';

  bool get isAuth {
    return _token.isNotEmpty;
  }

  String get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate.isAfter(DateTime.now()) || _userId.isNotEmpty || _token.isNotEmpty) {
        return _token;
    }
    return null;

  }


  Future<void> _authenticate(String email, String password, String urlSegment) async {
    String url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC1dIAIUkJDRW2wdwtH8L_0kisAwjW30c8';
    try {
      final response = await http.post(Uri.parse(url), body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      }),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn']),),);
        notifyListeners();
      print(json.decode(response.body));
    } catch (e) {
      rethrow;
    }
  }


    Future<void> signUp (String email, String password) async {
      return _authenticate(email, password, 'signUp');
    }


    Future<void> signIn (String email, String password) async {
      print('signing in');
      return _authenticate(email, password, 'signInWithPassword');
    }

}
// // static const apiKey = 'AIzaSyC1dIAIUkJDRW2wdwtH8L_0kisAwjW30c8 ';

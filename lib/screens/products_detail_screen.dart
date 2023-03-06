import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/provider/products.dart';


class ProductDetailScreen extends StatelessWidget {

  static const id = 'products_details_screen';

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String title = routeArgs['title'] as String;
    String id = routeArgs['id'] as String;
    final prodData = Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Text(prodData.title),
          Image.network(prodData.imageUrl),
          const SizedBox(height: 8,),
          Text(prodData.price.toString()),
          const SizedBox(height: 4,),
          Text(prodData.description),
          const SizedBox(height: 4,),


          // Text(prodDat)
        ],
      ),
    );
  }
}

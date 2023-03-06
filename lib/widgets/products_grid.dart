import 'package:flutter/material.dart';
import 'package:e_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';

class ProductsGrid extends StatelessWidget {

  final bool isFav;

  const ProductsGrid({Key? key,  required this.isFav}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pc =Provider.of<Products>(context);
    final prodData = isFav ? pc.getFavorites : pc.items;
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 10,
          childAspectRatio: 3/2
      ),
        itemCount: prodData.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            value: prodData[index],
            child: const ProductItem(),
          );
        });
  }
}

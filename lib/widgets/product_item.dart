import 'package:e_shop/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../provider/product.dart';
import '../screens/products_detail_screen.dart';

class ProductItem extends StatelessWidget {

   const ProductItem({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context,);
    final auth = Provider.of<Auth>(context, listen: false);


    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).pushNamed(ProductDetailScreen.id, arguments: {
            'title': prod.title,
            'id': prod.id
          });
        },
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(prod.title,
             ),
            leading:  Consumer(
              builder: (BuildContext context, value, Widget? child) {
                return IconButton(
                icon: const Icon(Icons.favorite,),
                onPressed: (){
                  print('favorited');
                prod.toggleFavorite(auth.token!, auth.userId);
                },
                color: prod.isFavorite ? Colors.red
                    : Colors.grey,
                );
                  },
            ),
                trailing:  IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  cart.addItem(prod.id, prod.price, prod.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: const Text('Item added',
                        ),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(prod.id);
                        },
                      ),
                  ),
                  );
                },
                ),
                ),
                child: Image.network(prod.imageUrl,
                    fit: BoxFit.cover,
                    ),
        ),
      ),
    );
  }
}

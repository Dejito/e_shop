import 'package:e_shop/provider/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {

  final String productId;
  final String id;
  final double price;
  final int quantity;
  final String title;

  const CartItem({Key? key,
    required this.id, required this.price, required this.quantity, required this.title, required this.productId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, );
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(productId),
      confirmDismiss: (dismissDirection){
        return showDialog(context: context, builder: (_) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('DO you agree to delete?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No'),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes'))
              ],
            );
          });
        },
      onDismissed: (_){
          cart.removeItem(productId);
      },
      background: Container(
        margin: const EdgeInsets.only(top: 8),
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20,),
        child: const Icon(
          Icons.delete,
          size: 40,
            color: Colors.white,
        ),
      ),

      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        child: ListTile(
        leading: CircleAvatar(
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  price.toStringAsFixed(2)
              ),
            ),
          ),
        ),
          title: Text(
            title
          ),
          subtitle: Text(
            'Total: ${price*quantity}'
          ),
          trailing: Text(
            '$quantity x'
          ),
        ),
      ),
    );
  }
}

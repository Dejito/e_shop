import 'package:e_shop/provider/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/widgets/cart_item.dart';
import '../provider/cart.dart';

class CartScreen extends StatelessWidget {
  static const pageID = 'cart_screen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartMenu = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Screen'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                 const Text ('Total',
                   style: TextStyle(
                       fontWeight: FontWeight.bold,
                     fontSize:18
                   ),
                 ),
                 const Spacer(),
                  Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text('\$${cartMenu.totalAmount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                      )
                  ),
                  const SizedBox(width: 10),
                 OrderButton(cartMenu: cartMenu),
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemBuilder: (context, i) {
                    return CartItem(
                      id: cartMenu.items.values.toList()[i].id,
                      productId: cartMenu.items.keys.toList()[i],
                      title: cartMenu.items.values.toList()[i].title,
                      quantity: cartMenu.items.values.toList()[i].quantity,
                      price: cartMenu.items.values.toList()[i].price,
                    );
                  },itemCount: cartMenu.items.length,
              )
          )
        ]

      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartMenu,
  }) : super(key: key);

  final Cart cartMenu;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

   bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          await Provider.of<Orders>(context, listen: false).addOrder(
              widget.cartMenu.items.values.toList(),
              widget.cartMenu.totalAmount,
          );
          widget.cartMenu.emptyCart();
          setState(() {
            isLoading = false;
          });
          print('order added online');
        },
        child: isLoading ?  const CircularProgressIndicator() :Text(
          'ORDER NOW',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),

     );
  }
}

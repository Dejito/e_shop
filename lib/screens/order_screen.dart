import 'package:e_shop/provider/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart' as ord;

class OrdersScreen extends StatefulWidget {
  static const id = 'lemme';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  @override
  void initState() {
    Provider.of<Orders>(context, listen: false).fetchAndSetOrder();
    print('fetch and set order');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Orders'
        ),
       ),
      drawer: const AppDrawer(),
      body: Scaffold(
        body: Card(
          child: ListView.builder(
                    itemBuilder: (context, i) {
                      return ord.OrderItem(
                          order: orderData.order[i]
                      );
                    },
                    itemCount: orderData.order.length,
                  ),
          ),
        ),
    );
  }
}

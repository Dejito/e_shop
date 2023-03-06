import 'dart:math';
import 'package:flutter/material.dart';
import '../provider/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {

  final ord.OrderItem order;

  const OrderItem({Key? key, required this.order, }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<Orders>(context);
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              '\$${widget.order.total}',
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)
  ),
            trailing: IconButton(
              icon: const Icon(
                Icons.expand_more
              ),
              onPressed: (){
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          if (expanded)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              height: min(widget.order.products.length * 30, 180),
              child: ListView(
                children: widget.order.products.map((e) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(e.title,
                       style: const TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     Text(
                       '${e.quantity}x ${e.price}'
                     )
                   ]
                  );
                }).toList(),
              ),
            ),

        ],
      ),
    );
  }
}

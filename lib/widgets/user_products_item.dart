import 'package:e_shop/screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';

class UserProductsItem extends StatelessWidget {

  final String imageURL;
  final String title;
  final String id;

  const UserProductsItem({Key? key, required this.imageURL, required this.title, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final prod = Provider.of<Products>(context, listen: false);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
      ),
      title: Text(title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold
      ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(EditProductScreen.id, arguments: id);
                },
                icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () async {
                try {
                  print(id);
                  await prod.deleteProduct(id);
                }catch(e){
                  scaffold.showSnackBar(
                      const SnackBar(content: Text('Something went wrong', textAlign: TextAlign.center,))
                  );
                }

              },
              icon: const Icon(Icons.delete,
              color: Colors.red,
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

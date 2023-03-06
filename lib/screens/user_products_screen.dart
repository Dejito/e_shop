import 'package:e_shop/provider/products.dart';
import 'package:e_shop/screens/edit_product_screen.dart';
import 'package:e_shop/widgets/app_drawer.dart';
import 'package:e_shop/widgets/user_products_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const id = 'user_prod_screen';

  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> onRefreshed(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.id, arguments: '');
              },
              icon: const Icon(
                Icons.add
              )
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()=> onRefreshed(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(itemBuilder: (context, i){
            return UserProductsItem(
                id:  prod.items[i].id,
                imageURL: prod.items[i].imageUrl,
                title: prod.items[i].title
            );
          },
          itemCount: prod.items.length,
          ),
        ),
      ),
    );
  }
}

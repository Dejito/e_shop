import 'package:e_shop/widgets/app_drawer.dart';
import 'package:e_shop/widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import '../provider/products.dart';
import '../widgets/products_grid.dart';
import 'cart_screen.dart';

enum FilterOptions  { favorites, all}

class ProductsOverviewScreen extends StatefulWidget {
  static const id = 'wo';

  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool showFavs = false;
  // bool _isLoaded = false;

  //
  // @override
  // void initState() {
  //   try{
  //     Future.delayed(const Duration(seconds: 2)).then((_)  {
  //       return  Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  //     } );
  //   } catch (e){
  //     print(e);
  //   }
  //   print('called before build');
  //   super.initState();
  // }

  // @override
  // void didChangeDependencies() {
  //   _isLoaded = true;
  // print('init getting called');
  //   try {
  //    Provider.of<Products>(context,).fetchAndSetProducts();
  //   } catch (e) {
  //     print(e);
  //     print('nadia buhari');
  //     const Center(child: Center(child: Text('no data added!')),);
  //       _isLoaded = false;
  //   }
  //
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    print('calling prod overview method');
    // Provider.of<Products>(context).fetchAndSetProducts();
    final cartData = Provider.of<Cart>(context,listen: false);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue){
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  showFavs = true;
                } else {
                  showFavs = false;
                }
              });
                },
              icon: const Icon(
                Icons.more_vert
              ),
              itemBuilder: (_){
                return const[
                   PopupMenuItem(
                      value: FilterOptions.favorites,
                      child: Text('Only Favorites'),
                  ),
                   PopupMenuItem(
                    value: FilterOptions.all,
                    child: Text('All'),
                  ),
                ];
              }
          ),
          Consumer(
            builder: (context, value, child) {
              return Badge(
              value: cartData.cartItemsFigure.toString(),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.pageID);
                },
              ),
              );
            },
          )
        ],
        title: const Text('Push'),
      ),
      body: FutureBuilder(
              future: Provider.of<Products>(context, listen: false).fetchAndSetProducts(),
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting ?
                    const Center(child: CircularProgressIndicator(),) :
                      ProductsGrid(isFav:showFavs)),
    );
  }
}


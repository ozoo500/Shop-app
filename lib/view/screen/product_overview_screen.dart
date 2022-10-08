
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/view/screen/cart_screen.dart';
import 'package:shop/view/widgets/badge.dart';
import 'package:shop/view/widgets/products_grid.dart';

import '../widgets/app_drawer.dart';

enum FilterOption { favorite, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isLoading = false;
  final bool _showOnlyFav = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLoading = true;
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct()
        .then((_) => setState(() => _isLoading = false)).catchError((error)=> print(error));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOption selectedVal) {},
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: FilterOption.favorite,
                      child: Text("Only Favorite"),
                    ),
                    const PopupMenuItem(
                      value: FilterOption.all,
                      child: Text("Show All"),
                    )
                  ]),
          Consumer<Cart>(
            child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.routeName),
                icon: const Icon(Icons.shopping_cart)),
            builder: (_, value, ch) => Badge(value: value.itemCount.toString(), child:ch as Widget),
          ),
        ],
      ),
      body: Center(
        child: Container(
          child: _isLoading ? const Center(child:  CircularProgressIndicator(),):ProductsGrid(_showOnlyFav),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}

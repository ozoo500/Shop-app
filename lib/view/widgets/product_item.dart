import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/provider/product.dart';
import 'package:shop/view/screen/product_details_screen.dart';

import '../../provider/cart.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          leading: Consumer<Product>(
            builder: (ctx, value, _) => IconButton(
              onPressed: () {
                value.toggleFav(authData.token!, authData.userId!);
              },
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id!, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: const Text("Added To Cart"),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                      label: 'UNDO!',
                      onPressed: () {
                        cart.removeSingleItem(product.id!);
                      }),
                ));
              },
              icon: const Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor),
        ),
        child: GestureDetector(
          onTap: () =>
              Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,arguments: product.id),
          child: Hero(
            tag: product.id!,
            child: FadeInImage(
              placeholder:
                  const AssetImage("assets/images/product-placeholder.png"),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

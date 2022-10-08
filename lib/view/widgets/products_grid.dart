import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/view/widgets/product_item.dart';

import '../../provider/products.dart';
class ProductsGrid extends StatelessWidget {
  ProductsGrid(this.showFav) ;
     final bool showFav;
  @override
  Widget build(BuildContext context) {
    final prodData =Provider.of<Products>(context,listen: false);
    final products =showFav? prodData.favItem:prodData.item;
    return products.isEmpty?const Center(child: Text("There is No Products"),):GridView.builder(
      padding:  const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2/3,
          crossAxisCount: 2

        ),
        itemCount: products.length,
        itemBuilder: (context,i)=>ChangeNotifierProvider.value(value:products[i],
          child:const ProductItem() ,),
    );
  }
}

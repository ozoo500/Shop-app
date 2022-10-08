

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/ProductDetails';
  @override
  Widget build(BuildContext context) {
    final prodId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(prodId);
    return Scaffold(




      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background:Hero(
                tag: loadedProduct.id!,
                child: Image.network(loadedProduct.imageUrl,fit: BoxFit.cover,),
              ) ,
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(
               [
                const  SizedBox(height: 10,),
                 Text('\$${loadedProduct.price}',style: const TextStyle(
                   color: Colors.grey,
                   fontSize: 20
                 ),),
                 Container(
                   width: double.infinity,
                   padding:const  EdgeInsets.symmetric(horizontal: 10),
                   child: Text(loadedProduct.description,
                   softWrap: true,
                   textAlign: TextAlign.center,),


                 )

               ],

              )),
        ],
      ),
    );
  }
}


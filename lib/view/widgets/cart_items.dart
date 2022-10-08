import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/view/screen/edit_screen.dart';

import '../../provider/cart.dart';

class CartItem extends StatelessWidget {
  const CartItem(
      this.id, this.productId, this.price, this.quantity, this.title);
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        margin:const EdgeInsets.symmetric(horizontal:15 ,vertical:4 ),
        padding:const EdgeInsets.only(right: 20),
        child:const Icon(
          Icons.delete,color:Colors.white ,
  size: 40,
        ) ,

      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
   return showDialog(context: context, builder: (ctx)=> AlertDialog(
     title: const Text('Are you Sure ?'),
     content: const Text('Do You want to remove item from Cart'),
     actions: [
       FlatButton(onPressed: ()=>Navigator.of(context).pop(), child: const Text('No')),
       FlatButton(onPressed: ()=>Navigator.of(context).pop(true), child: const Text('Yes')),
     ],
   ),);
      },

      key:ValueKey(id),
      onDismissed: (direction){
        Provider.of<Cart>(context).removeItem(productId);
      },
      child:Card(
        margin:const EdgeInsets.symmetric(horizontal:15 ,vertical:4 ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
             child: Padding(
               padding: const EdgeInsets.all(5.0),
               child: FittedBox(
                    child: Text('\$$price'),
               ),
             ),
            ),
            title:Text(title) ,
            subtitle: Text('Total \$${price*quantity}'),
            trailing:Text('${quantity }x') ,
          ),
        ),
      ),

    );
  }
}

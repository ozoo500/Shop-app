import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/view/screen/edit_screen.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem(this.id, this.title, this.imageUrl);

  final String id;
  final String title;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(
        title,
      ),
      trailing: Row(
        children: [
          IconButton(onPressed: () =>Navigator.of(context).pushNamed(EditScreen.routeName,arguments: id), icon: const Icon(Icons.edit)),
          IconButton(onPressed: () async{
            try{
              await Provider.of<Products>(context).deleteProduct(id);
            }catch(e){
               scaffold.showSnackBar( const SnackBar(
                   content: Text('Deleting Failed',textAlign: TextAlign.center,)));
            }
          }, icon: const Icon(Icons.delete),color: Theme.of(context).errorColor,),
        ],
      ),
    );
  }
}

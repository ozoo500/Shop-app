import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/view/screen/order_screen.dart';
import 'package:shop/view/screen/user_product.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: const  Text("Hello Friend!"),
          automaticallyImplyLeading: false,),
         const Divider(),
          ListTile(
            leading:const Icon(Icons.shop) ,
            title: const Text("Shop"),
            onTap: ()=>Navigator.of(context).pushReplacementNamed('/'),
          ),
          const Divider(),
          ListTile(
            leading:const Icon(Icons.payment) ,
            title: const Text("Orders"),
            onTap: ()=>Navigator.of(context).pushReplacementNamed(OrderScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading:const Icon(Icons.edit) ,
            title: const Text("Manage Products"),
            onTap: ()=>Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading:const Icon(Icons.exit_to_app) ,
            title: const Text("LogOut"),
            onTap: ()async{
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
           Provider.of<Auth>(context,listen: false).logout();
            }
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/view/screen/edit_screen.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const routeName = '/UserProductScreen';

  Future<void> _refreshProduct(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditScreen.routeName),
          )
        ],
      ),
      body: FutureBuilder(
          future: _refreshProduct(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      child: Consumer<Products>(
                        builder: (ctx, pro, _) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              itemCount: pro.item.length,
                              itemBuilder: (context,i)=>Column(
                                children: [
                                  UserProductItem(
                                    pro.item[i].id!,
                                    pro.item[i].title,
                                    pro.item[i].imageUrl
                                  ),
                                  Divider(),
                                ],
                              ),

                          ),
                        ),
                      ),
                      onRefresh: () => _refreshProduct(context))),
      drawer: const AppDrawer(),
    );
  }
}

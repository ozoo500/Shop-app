import 'package:flutter/material.dart';
import 'package:shop/view/widgets/app_drawer.dart';


class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName='/OrderScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: Text("Shop"),
    ),

      body: null,
      drawer: AppDrawer(),
    );
  }
}

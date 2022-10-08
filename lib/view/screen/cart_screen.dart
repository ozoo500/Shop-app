import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart' show Cart;
import 'package:shop/provider/order.dart';

import '../widgets/cart_items.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/CartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
               itemCount: cart.items.length,
                itemBuilder:(ctx,index) => CartItem(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].title,

                ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({Key? key, required this.cart}) : super(key: key);
  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
   bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed:(widget.cart.totalAmount<=0||_isLoading)?null: ()async {
        setState(() {
          _isLoading =true;
        });
        await Provider.of<Order>(context).addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
        setState(() {
          _isLoading =false;
        });
        widget.cart.clear();
      },
      textColor: Theme.of(context).primaryColor,
      child: _isLoading?const CircularProgressIndicator():const Text('ORDER NOW'),
    );
  }
}

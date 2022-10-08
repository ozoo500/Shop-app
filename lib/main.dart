import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/order.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/view/screen/auth_screen.dart';
import 'package:shop/view/screen/cart_screen.dart';
import 'package:shop/view/screen/edit_screen.dart';
import 'package:shop/view/screen/order_screen.dart';
import 'package:shop/view/screen/splash_screen.dart';
import 'package:shop/view/screen/user_product.dart';
import 'view/screen/product_details_screen.dart';
import 'view/screen/product_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (_) => Order(),
          update: (ctx, authValue, previousOrders) => previousOrders!
            ..getData(authValue.token!, authValue.userId!, previousOrders.orders),
        ),        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (ctx, authValue, previousProducts) => previousProducts!
            ..getData(authValue.token!, authValue.userId!, previousProducts.item),
        ),
        ChangeNotifierProvider.value(value: Cart()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, AsyncSnapshot snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            ProductDetailsScreen.routeName: (_) => const ProductDetailsScreen(),
            CartScreen.routeName: (_) => const CartScreen(),
            OrderScreen.routeName: (_) => const OrderScreen(),
            EditScreen.routeName: (_) => const EditScreen(),
            UserProductScreen.routeName: (_) => const UserProductScreen(),
          },
        ),
      ),
    );
  }
}

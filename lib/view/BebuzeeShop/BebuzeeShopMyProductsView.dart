import 'package:flutter/material.dart';

class BebuzeeShopMyProductsView extends StatefulWidget {
  const BebuzeeShopMyProductsView({Key? key}) : super(key: key);

  @override
  State<BebuzeeShopMyProductsView> createState() =>
      _BebuzeeShopMyProductsViewState();
}

class _BebuzeeShopMyProductsViewState extends State<BebuzeeShopMyProductsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Container(),
    );
  }
}

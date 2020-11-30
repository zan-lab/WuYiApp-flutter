import 'package:flutter/material.dart';

class ShopIndexPage extends StatefulWidget {
  @override
  _ShopIndexPageState createState() => _ShopIndexPageState();
}

class _ShopIndexPageState extends State<ShopIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Shop'),
        ),
      ),
    );
  }
}

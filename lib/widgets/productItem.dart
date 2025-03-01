import 'dart:ui';

import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String title;
  final String price;
  ProductItem({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/earnings.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(price, style: TextStyle(color: Colors.red, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

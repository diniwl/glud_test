import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xff6A7DA1),
            Color(0xff556D9D),
            Color(0xff334974)
          ])),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('$price', 
                  style:TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),),
                ),
              ),
              title: Text(title,
              style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.w500),),
              subtitle: Text('Total kalori: ${(price * quantity)}',
              style: TextStyle(color: Colors.orange,
              fontSize: 16,
              fontWeight: FontWeight.w500),),
              trailing: Text('$quantity x',
              style: TextStyle(
                color: Colors.white,
              ),),
            ),
          ),
        ),
      ),
    );
  }
}

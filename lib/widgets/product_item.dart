import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          )),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff6A7DA1),
              Color(0xff556D9D),
              Color(0xff334974)           
            ])
          ),
          child: ListTile(
            title: Text(product.title,
            style: TextStyle(color: Colors.white),),
            leading: Consumer<Product>(
                builder: (ctx, product, _) => IconButton(
                      icon: Icon(
                        product.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.orange,
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        product.toggleFavoriteStatus();
                      },
                    ),
              ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id, product.calories, product.title);
              }, icon: Icon(Icons.add,
              color: Colors.orange,)),
                      onTap: () {
                // Navigator.of(context).pushNamed(
                //   ProductDetailScreen.routeName,
                //   arguments: product.id,
                // );
              },
            ),
        ),
      ),
    );
  }
}

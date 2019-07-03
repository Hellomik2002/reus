import 'package:flutter/material.dart';
import '../UI_elements/product.dart';


class Products extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductsState();
  }
}

Widget _buildSideDrawer(BuildContext context) {
  return  Drawer(
    child: Column(
      children: <Widget>[
        AppBar(
          automaticallyImplyLeading: false,
          title: Text('Choose'),
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage Products'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/admin');
          },
        )
      ],
    ),
  );
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.indigo,
          accentColor: Colors.indigoAccent),

      home: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Main'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {

              },
            )
          ],
        ),
        body: ProductCard(),
      ),
    );
  }
}

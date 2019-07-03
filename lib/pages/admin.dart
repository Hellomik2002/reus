import 'package:flutter/material.dart';
import 'add_product.dart';
import 'ProductList.dart';

class AdminPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    
    return _AdminPageState();
  }
}

class _AdminPageState extends State<AdminPage> {
  Widget _buildSideDrawer() {
    return Drawer(
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
            Navigator.pushReplacementNamed(context, '/');
          },
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
   
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(),
        drawer: _buildSideDrawer(),
        
        body: TabBarView(children: <Widget>[ProductAddPage(), ProductList(),],),
      ),
    );
  }
}

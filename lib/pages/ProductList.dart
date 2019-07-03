import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped_model/connected_services.dart';
import 'package:firebase_core/firebase_core.dart';

class ProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProudtcListState();
  }
}

class _ProudtcListState extends State<ProductList> {
  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return model.isloading ? CircularProgressIndicator() :IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        model.check(true);
        await FirebaseDatabase.instance
            .reference()
            .child('recent')
            .child('id')
            .child(model.services[index].id)
            .remove();
            model.check(false);
        Navigator.of(context).pushReplacementNamed('/');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    
    return GestureDetector(
      onTap: (){
         FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemCount: model.services.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(model.services[index].urlImage),
                  ),
                  title: Text(model.services[index].title),
                  subtitle: Text('\$${model.services[index].price.toString()}'),
                  trailing: _buildEditButton(context, index, model),
                ),
                Divider()
              ],
            );
          },
        );
      }),
    );
  }
}

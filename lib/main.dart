import 'package:flutter/material.dart';
import 'package:reus/scoped_model/connected_services.dart';
import 'package:flutter/rendering.dart';

import 'package:scoped_model/scoped_model.dart';
import 'pages/Products.dart';
import 'pages/admin.dart';

import 'package:scoped_model/scoped_model.dart';

void main() {
  //debugPaintSizeEnabled = true;
   
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}
 
class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();

  @override
  void initState() {
     _model.fetchProducts();
     /*String idTimePrep = DateTime.now().toIso8601String();
     String idTime = '';
     for (int i = 0; i < idTimePrep.length; ++i) {
       if (idTimePrep[i] == '.' || idTimePrep[i] == '-'||idTimePrep[i] == ':'){

       }
       else {
         idTime = idTime + idTimePrep[i]; 
       }
     }
     print(idTime);*/
    super.initState();
  }

  @override 
  Widget build(BuildContext context) {   
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          buttonColor: Colors.deepPurple,
        ),
        routes: {
          '/': (BuildContext context) => AdminPage(),
          '/admin':(BuildContext context) => Products(),
        },
      ),
    );
  }
}

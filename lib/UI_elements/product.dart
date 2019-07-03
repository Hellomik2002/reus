import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped_model/connected_services.dart';

class ProductCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductCardState();
  }
}

class _ProductCardState extends State<ProductCard> {
  String title = 'Chocolate';
  String description = 'So tasty';
  int price = 12;

  List<Map<String, dynamic>> _products = [];
  List<Widget> _buildStars(double rate) {
    int r1 = (rate / 2).toInt();
    double r2 = rate / 2 - r1;
    print(r1);
    print(r2);
    List<Widget> stars = [];
    for (int i = 1; i <= 5; ++i) {
      if (i <= r1) {
        stars.add(Icon(
          Icons.star,
          size: 15,
        ));
      } else if (i - r1 <= 1 && r2 >= 0.5) {
        stars.add(Icon(Icons.star_half, size: 15));
      } else {
        stars.add(Icon(Icons.star_border, size: 15));
      }
    }
    return stars;
  }

  Widget _secondPart(BuildContext contex, MainModel model, int index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  model.services[index].title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: _buildStars(model.services[index].rating),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Icon(
                      Icons.favorite_border,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Theme.of(context).accentColor,
                          ),
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            model.services[index].rating.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            child: Text(model.services[index].description.toString()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.location_on),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            child: Text(
                                model.services[index].address),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[Text('KZ | '), Text("${model.services[index].price.toInt()} tg")],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _products.add({
      'title': title,
      'description': description,
      'price': price,
      'image': 'assets/food.jpg'
    });

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return RefreshIndicator(
            onRefresh: model.fetchProducts,
            child: ListView.builder(
              itemCount: model.services.length,
              itemBuilder: (BuildContext context, int index) => Card(
                child: Container(
                  height: 230,
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5.0),
                        width: 190,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: NetworkImage(model.services[index].urlImage),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          child: _secondPart(context, model, index),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

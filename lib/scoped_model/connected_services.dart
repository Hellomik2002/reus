import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/Service.dart';

mixin ProductsModel on Model {
  List<Service> services = [];
  bool isloading = false;

  Future<Null> fetchProducts() async {
    isloading = true;
    notifyListeners();
    services = [];

    var services1 = await FirebaseDatabase.instance
        .reference()
        .child('recent')
        .child('id')
        .once();

    if (services1.value == null) {
    } else {
      (services1.value as Map<dynamic, dynamic>)
          .forEach((key, dynamic serviceData) {
        print("sdasdasdad");
        print(serviceData);
        final Service service = Service(
          id: serviceData['id'],
          title: serviceData['title'],
          rating: serviceData["rating"].toDouble(),
          description: serviceData['description'],
          address: serviceData['address'],
          price: serviceData['price'].toDouble(),
          urlImage: serviceData['urlImage'],
        );
        services.add(service);
      });
    }
    isloading = false;
    notifyListeners();
    return;
  }

  void check(bool value) {
    isloading = value;
    notifyListeners();
  }
}

class MainModel extends Model with ProductsModel {}

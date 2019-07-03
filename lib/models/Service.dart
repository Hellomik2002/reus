import 'dart:io';

import 'package:flutter/material.dart';

class Service {
  final String title;
  final double rating;
  final String description;
  final String address;
  final double price;
  final String urlImage;
  final String id;
  
  Service({this.id,this.title, this.rating, this.description, this.address, this.price, this.urlImage});

}
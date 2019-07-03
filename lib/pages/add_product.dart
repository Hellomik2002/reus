import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reus/scoped_model/connected_services.dart';
import '../widgets/helpers/ensure_visible.dart';
import '../widgets/form_input/image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';

class ProductAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductAddPageState();
  }
}

class _ProductAddPageState extends State<ProductAddPage> {
  String title = "";
  double rating = 0;
  String description = "";
  String address = "";
  double price = 0;
  File _uploadPhoto;
  List<File> _uploadPhotoDes = [];
  void upload(File value) {
    this._uploadPhoto = value;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _titleFocusNode = FocusNode();
  Widget _buildTitleTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(labelText: 'Title'),
        onChanged: (String value) {
          print(value);
          this.title = value;
        },
      ),
    );
  }

  final _addressFocusNode = FocusNode();
  Widget _buildAddressTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _addressFocusNode,
      child: TextFormField(
        focusNode: _addressFocusNode,
        decoration: InputDecoration(labelText: 'address'),
        onChanged: (String value) {
          this.address = value;
        },
      ),
    );
  }

  final _descriptionFocusNode = FocusNode();
  Widget _buildDescriptionTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        maxLines: 4,
        focusNode: _descriptionFocusNode,
        decoration: InputDecoration(labelText: 'Description'),
        onChanged: (String value) {
          this.description = value;
        },
      ),
    );
  }

  final _priceFocusNode = FocusNode();
  Widget _buildPriceTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        focusNode: _priceFocusNode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Price'),
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return 'Price is required and should be a number.';
          }
        },
        onChanged: (String value) {
          this.price = double.parse(value);
        },
      ),
    );
  }

  final _rateFocusNode = FocusNode();
  Widget _buildRateTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _rateFocusNode,
      child: TextFormField(
        focusNode: _rateFocusNode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Rating'),
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value) ||
              int.parse(value) <= 10) {
            return 'Price is required and should be a number and be less or equal 10';
          }
        },
        onChanged: (String value) {
          this.rating = double.parse(value);
        },
      ),
    );
  }

  void _submitForm(MainModel model) async {
    model.check(true);
    String idCodeTitle = DateTime.now().toString();

    FocusScope.of(context).requestFocus(FocusNode());
    final StorageReference firebaseStorageRef =
        await FirebaseStorage.instance.ref().child(idCodeTitle);
    final StorageUploadTask task =
        await firebaseStorageRef.putFile(this._uploadPhoto);

    final StorageTaskSnapshot downloadUrl = (await task.onComplete);
    final String urlImage = await downloadUrl.ref.getDownloadURL();
    String idTimePrep = DateTime.now().toIso8601String();
    String idTime = '';
    for (int i = 0; i < idTimePrep.length; ++i) {
      if (idTimePrep[i] == '.' ||
          idTimePrep[i] == '-' ||
          idTimePrep[i] == ':') {
      } else {
        idTime = idTime + idTimePrep[i];
      }
    }
    await FirebaseDatabase.instance
        .reference()
        .child('recent')
        .child('id')
        .child(idTime)
        .set({
      'id': idTime,
      'title': this.title,
      'rating': this.rating,
      'description': this.description,
      'address': this.address,
      'price': this.price,
      'urlImage': urlImage,
    });
    model.check(false);
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget _submitButton(MainModel model) {
    return model.isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RaisedButton(
            child: Text('Save'),
            textColor: Colors.white,
            onPressed: () => _submitForm(model),
          );
  }

   void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
        this.upload(_imageFile);        
      });
      Navigator.pop(context);      
    });
  }


  Widget _buildImagesLoaded() {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
      ),
      height: deviceWidth / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 2,
          style: BorderStyle.solid,
          color: Theme.of(context).accentColor,
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _uploadPhotoDes.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == _uploadPhotoDes.length) {
            return Center(
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).accentColor,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 150.0,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text('Pick an Image'),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              FlatButton(
                                textColor: Theme.of(context).primaryColor,
                                child: Text('Use Galery'),
                                onPressed: () {
                                  _getImage(context, ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                //padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
                children: <Widget>[
                  _buildTitleTextField(),
                  _buildDescriptionTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildPriceTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildAddressTextField(),
                  _buildRateTextField(),
                  ImageInput(upload: this.upload),
                  _buildImagesLoaded(),
                  _submitButton(model),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(context),
    );
  }
}

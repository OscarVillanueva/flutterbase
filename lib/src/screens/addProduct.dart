import 'dart:io';

import 'package:firebase/models/Product.dart';
import 'package:firebase/src/providers/firebase.dart';
import 'package:firebase/src/screens/productsList.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String imagePath;
  File image;
  final picker = ImagePicker();
  bool loading = false;
  FirebaseProvider firestore;
  TextEditingController txtControllerDescription = TextEditingController();
  TextEditingController txtControllerModel = TextEditingController();

  @override
  void initState() {
    super.initState();

    firestore = FirebaseProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text("Agregar producto")),
        body: Center(
          child: LoadingOverlay(
            isLoading: loading,
            child: Container(
                padding: EdgeInsets.all(30),
                child: ListView(children: <Widget>[
                  Text("Selecciona una imagen"),
                  SizedBox(height: 30),
                  InkWell(
                    child: getImage(),
                    onTap: () async {
                      final pickedFile =
                          await picker.getImage(source: ImageSource.gallery);
                      setState(() {
                        imagePath = pickedFile.path;
                        image = File(pickedFile.path);
                      });
                    },
                  ),
                  SizedBox(height: 30),
                  Text("Descripción"),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: txtControllerDescription,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Ingresa la descripción del producto",
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  SizedBox(height: 30),
                  Text("Modelo"),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: txtControllerModel,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Ingresa el modelo",
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  SizedBox(height: 30),
                  RaisedButton(
                      child: Text(
                        "Agregar",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () async {
                        await uploadProduct(context);
                      })
                ])),
          ),
        ),
      ),
    );
  }

  void uploadProduct(context) async {
    if (txtControllerDescription.text.isNotEmpty &&
        txtControllerModel.text.isNotEmpty &&
        image != null) {
      setState(() {
        loading = true;
      });

      final Reference postImageProduct =
          FirebaseStorage.instance.ref().child("Models Images");
      final UploadTask uploadImageTask =
          postImageProduct.child(txtControllerModel.text.trim()).putFile(image);
      var imageUrl = await (await uploadImageTask).ref.getDownloadURL();

      await firestore.saveProduct(Product(
          model: txtControllerModel.text,
          description: txtControllerDescription.text,
          image: imageUrl));

      setState(() {
        loading = false;
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProductsList()));
    } else {
      _showAlert(context);
    }
  }

  void _showAlert(BuildContext context) {
    showCupertinoDialog<String>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Advertencia'),
            content: Text('Todos los campos son obligatorios'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Cancelar'),
                onPressed: () => Navigator.pop(context, 'Cancelar'),
              ),
              CupertinoDialogAction(
                child: Text('Aceptar'),
                onPressed: () => Navigator.pop(context, 'Aceptar'),
              ),
            ],
          );
        });
  }

  Widget getImage() {
    return imagePath == null
        ? Image.network(
            "https://martimx.vteximg.com.br/arquivos/ids/352413-275-275/1127618337-1.png?v=637070258793300000",
            width: 200,
            height: 200,
          )
        : Image.file(File(imagePath));
  }
}

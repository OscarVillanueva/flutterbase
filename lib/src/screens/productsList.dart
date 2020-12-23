import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/src/providers/firebase.dart';
import 'package:firebase/src/views/CardProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductsList extends StatefulWidget {
  ProductsList({Key key}) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  FirebaseProvider _provider;

  @override
  void initState() {
    super.initState();

    _provider = FirebaseProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
        // leading: MaterialButton(
        //     child: Icon(Icons.add_circle, color: Colors.amber),
        //     onPressed: () {
        //       debugPrint("Agregando . . . ");
        //     }),
        actions: <Widget>[
          MaterialButton(
              child: Icon(Icons.add_circle, color: Colors.amber),
              onPressed: () {
                debugPrint("Agregando . . . ");
              })
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _provider.getAllProducts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return CircularProgressIndicator();
          else {
            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return CardProduct(productDocument: document);
              }).toList(),
            );
          }
        },
      ),
    );
  }
}

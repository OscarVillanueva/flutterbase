import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardProduct extends StatefulWidget {
  final DocumentSnapshot productDocument;
  CardProduct({Key key, @required this.productDocument}) : super(key: key);

  @override
  _CardProductState createState() => _CardProductState(productDocument);
}

class _CardProductState extends State<CardProduct> {
  final DocumentSnapshot productDocument;
  _CardProductState(this.productDocument);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _card = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: FadeInImage(
            placeholder: AssetImage("assets/loading.gif"),
            image: NetworkImage(productDocument.data()["image"]),
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 100),
            height: 230.0,
          ),
        ),
        Opacity(
          opacity: 0.6,
          child: Container(
            padding: EdgeInsets.only(left: 20),
            height: 55.0,
            color: Colors.black,
            child: Row(
              children: [
                Text(
                  productDocument.data()["model"],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )
              ],
            ),
          ),
        )
      ],
    );

    return Container(
      margin: EdgeInsets.all(15.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: Offset(0.0, 0.5),
            blurRadius: 1.0)
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: _card,
      ),
    );
  }
}

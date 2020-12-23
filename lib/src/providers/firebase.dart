import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/Product.dart';

class FirebaseProvider {
  FirebaseFirestore _firestore;
  CollectionReference _productsCollection;

  FirebaseProvider() {
    _firestore = FirebaseFirestore.instance;
    _productsCollection = _firestore.collection("products");
  }

  Stream<QuerySnapshot> getAllProducts() {
    return _productsCollection.snapshots();
  }

  Future<void> saveProduct(Product product) {
    return _productsCollection.add(product.toMap());
  }

  Future<void> updateProduct(Product product, String id) {
    return _productsCollection.doc(id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) {
    return _productsCollection.doc(id).delete();
  }
}

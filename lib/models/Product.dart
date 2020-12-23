class Product {
  String model;
  String description;
  String image;

  Product({this.model, this.description, this.image});

  Map<String, dynamic> toMap() {
    return {"model": model, "description": description, "image": image};
  }
}

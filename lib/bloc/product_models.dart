import 'category_models.dart';

class Product {
  int? id;
  Category? category;
  String? name;
  String? description;
  String? price;
  String? sku;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;

  Product(
      {this.id,
      this.category,
      this.name,
      this.description,
      this.price,
      this.sku,
      this.image,
      this.status,
      this.createdAt,
      this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    name = json['name'];
    description = json['description'];
    price = json['price'];
    sku = json['sku'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

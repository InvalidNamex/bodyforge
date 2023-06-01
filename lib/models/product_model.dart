class ProductModel {
  final int productID;
  final String productName;
  final String productImage;
  final double productPrice;
  const ProductModel(
      {required this.productName,
      required this.productImage,
      required this.productID,
      required this.productPrice});
  static ProductModel fromJson(Map<String, dynamic> json) => ProductModel(
      productImage: json['product_image'] as String,
      productID: json['id'] as int,
      productName: json['product_name'] as String,
      productPrice: json['product_price'] as double);
}

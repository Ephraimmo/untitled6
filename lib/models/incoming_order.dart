class ProductOrders {
  // Product's variables: name, price, imageUrl. All required.
  final String name;
  final String branche;
  final String Date;
  final String Time;
  final String paymentType;
  final String price;
  final String number;
  final String path;

  const ProductOrders({
    required this.Date,
    required this.Time,
    required this.paymentType,
    required this.name,
    required this.branche,
    required this.number,
    required this.price,
    required this.path,
  });
}
import 'package:hive/hive.dart';

part 'invoice_item.g.dart'; // only once

@HiveType(typeId: 2)
class InvoiceItem extends HiveObject {
  @HiveField(0)
  String description;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  double price;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.price,
  });
}

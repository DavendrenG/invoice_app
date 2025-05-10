import 'package:hive/hive.dart';
import 'invoice_item.dart';
part 'invoice.g.dart';

@HiveType(typeId: 1)
class Invoice extends HiveObject {
  @HiveField(0)
  String customerName;

  @HiveField(1)
  String customerEmail;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String address;

  @HiveField(4)
  String invoiceNumber;

  @HiveField(5)
  DateTime invoiceDate;

  @HiveField(6)
  DateTime dueDate;

  @HiveField(7)
  List<InvoiceItem> items;

  @HiveField(8)
  String notes;

  @HiveField(9)
  String terms;

  Invoice({
    required this.customerName,
    required this.customerEmail,
    required this.phone,
    required this.address,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.dueDate,
    required this.items,
    required this.notes,
    required this.terms,
  });
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceAdapter extends TypeAdapter<Invoice> {
  @override
  final int typeId = 1;

  @override
  Invoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Invoice(
      customerName: fields[0] as String,
      customerEmail: fields[1] as String,
      phone: fields[2] as String,
      address: fields[3] as String,
      invoiceNumber: fields[4] as String,
      invoiceDate: fields[5] as DateTime,
      dueDate: fields[6] as DateTime,
      items: (fields[7] as List).cast<InvoiceItem>(),
      notes: fields[8] as String,
      terms: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Invoice obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.customerName)
      ..writeByte(1)
      ..write(obj.customerEmail)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.invoiceNumber)
      ..writeByte(5)
      ..write(obj.invoiceDate)
      ..writeByte(6)
      ..write(obj.dueDate)
      ..writeByte(7)
      ..write(obj.items)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.terms);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

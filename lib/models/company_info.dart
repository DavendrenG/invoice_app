// lib/models/company_info.dart

import 'package:hive/hive.dart';

part 'company_info.g.dart';

@HiveType(typeId: 3)
class CompanyInfo extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String address;

  @HiveField(4)
  String enterpriseNumber;

  @HiveField(5)
  String logoPath;

  CompanyInfo({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.enterpriseNumber,
    required this.logoPath,
  });
}

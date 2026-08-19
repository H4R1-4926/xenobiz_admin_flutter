import 'package:equatable/equatable.dart';

class BusinessModel extends Equatable {
  final String id;
  final String name;
  final String? shopName;
  final String? businessType;
  final String? description;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final String? phone;
  final String? email;
  final String? website;
  final String? taxNumber;
  final String? regNumber;
  final String? ownerId;
  final String? ownerName;
  final String? ownerEmail;
  final String? planName;
  final String? subscriptionStatus;
  final String status;
  final String? createdAt;

  const BusinessModel({
    required this.id,
    required this.name,
    this.shopName,
    this.businessType,
    this.description,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.phone,
    this.email,
    this.website,
    this.taxNumber,
    this.regNumber,
    this.ownerId,
    this.ownerName,
    this.ownerEmail,
    this.planName,
    this.subscriptionStatus,
    this.status = 'active',
    this.createdAt,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    final ownerMap = json['owner'] is Map ? json['owner'] as Map<String, dynamic> : null;
    final subMap = json['subscription'] is Map ? json['subscription'] as Map<String, dynamic> : null;

    return BusinessModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['companyName']?.toString() ?? json['company_name']?.toString() ?? '',
      shopName: json['shopName']?.toString() ?? json['shop_name']?.toString() ?? json['name']?.toString(),
      businessType: json['businessType']?.toString() ?? json['business_type']?.toString(),
      description: json['description']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      country: json['country']?.toString() ?? 'India',
      zipCode: json['zipCode']?.toString() ?? json['zip_code']?.toString(),
      phone: json['phone']?.toString() ?? ownerMap?['phone']?.toString(),
      email: json['email']?.toString() ?? ownerMap?['email']?.toString(),
      website: json['website']?.toString(),
      taxNumber: json['taxNumber']?.toString() ?? json['tax_number']?.toString() ?? json['gstin']?.toString(),
      regNumber: json['regNumber']?.toString() ?? json['reg_number']?.toString() ?? json['registrationNo']?.toString(),
      ownerId: json['ownerId']?.toString() ?? json['owner_id']?.toString() ?? ownerMap?['id']?.toString(),
      ownerName: json['ownerName']?.toString() ?? json['owner_name']?.toString() ?? ownerMap?['fullName']?.toString() ?? ownerMap?['name']?.toString(),
      ownerEmail: json['ownerEmail']?.toString() ?? json['owner_email']?.toString() ?? ownerMap?['email']?.toString(),
      planName: json['planName']?.toString() ?? json['plan_name']?.toString() ?? subMap?['planName']?.toString(),
      subscriptionStatus: json['subscriptionStatus']?.toString() ?? json['subscription_status']?.toString() ?? subMap?['status']?.toString(),
      status: json['status']?.toString() ?? json['companyStatus']?.toString() ?? 'active',
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shopName': shopName,
      'businessType': businessType,
      'description': description,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
      'phone': phone,
      'email': email,
      'website': website,
      'taxNumber': taxNumber,
      'regNumber': regNumber,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerEmail': ownerEmail,
      'planName': planName,
      'subscriptionStatus': subscriptionStatus,
      'status': status,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [id, name, shopName, ownerId, status, planName];
}

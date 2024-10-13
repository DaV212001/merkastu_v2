import 'package:merkastu_v2/constants/constants.dart';

class Store {
  final String? id;
  final String? name;
  final String? location;
  final num? latitude;
  final num? longitude;
  final String? cover;
  final String? logo;
  final num? vat;
  final int? deliveryTime;
  final bool? insideAastu;
  final String? ownerId;
  final int? deliveryFee;
  bool favorited = false;

  Store({
    this.deliveryFee,
    this.id,
    this.name,
    this.location,
    this.latitude,
    this.longitude,
    this.cover,
    this.logo,
    this.vat,
    this.deliveryTime,
    this.insideAastu,
    this.ownerId,
  });

  Store.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        location = json['location'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        cover = kStoreImageBaseUrl + json['cover_image'],
        logo = kStoreImageBaseUrl + json['logo'],
        vat = json['vat'],
        deliveryTime = json['estimated_delivery_time'],
        insideAastu = json['inside_aastu'],
        deliveryFee = json['delivery_fee'],
        ownerId = json['owner_id'];

  Store.fromOrderDetailJson(
    Map<String, dynamic> json,
  )   : id = json['store_id'],
        name = json['store_name'],
        location = '',
        latitude = json['latitude'],
        longitude = json['longitude'],
        cover = '',
        logo = kStoreImageBaseUrl + json['store_logo'],
        vat = json['vat'],
        ownerId = '',
        deliveryTime = json['estimated_delivery_time'],
        insideAastu = false,
        deliveryFee = json['delivery_fee'];
}

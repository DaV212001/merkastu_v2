import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/utils/order_status.dart';
import 'package:merkastu_v2/utils/payment_methods.dart';

class StoreSmall {
  final String? id;
  final String? storeName;
  final String? storeLogo;
  final String? coverImage;
  final int? productCount;

  StoreSmall({
    this.id,
    this.storeName,
    this.storeLogo,
    this.coverImage,
    this.productCount,
  });

  // Factory constructor to parse from JSON
  factory StoreSmall.fromJson(Map<String, dynamic> json) {
    return StoreSmall(
      id: json['store_id'],
      storeName: json['store_name'],
      storeLogo: json['store_logo'],
      coverImage: json.containsKey('cover_image') && json['cover_image'] != null
          ? kStoreImageBaseUrl + json['cover_image']
          : '',
      productCount: json['product_count'],
    );
  }

  // Method to convert StoreSmall object to JSON
  Map<String, dynamic> toJson() {
    return {
      'store_name': storeName,
      'store_logo': storeLogo,
      'cover_image': coverImage,
      'product_count': productCount,
    };
  }
}

enum OrderType { delivery, takeaway, eatIn }

extension OrderTypeExtension on OrderType {
  String get name {
    switch (this) {
      case OrderType.delivery:
        return 'DELIVERY';
      case OrderType.takeaway:
        return 'TAKEAWAY';
      case OrderType.eatIn:
        return 'EAT_IN';
    }
  }

  String get nameDisplay {
    switch (this) {
      case OrderType.delivery:
        return 'Delivery';
      case OrderType.takeaway:
        return 'Takeaway';
      case OrderType.eatIn:
        return 'Eat In';
    }
  }

  static OrderType fromName(String name) {
    switch (name) {
      case 'DELIVERY' || 'delivery':
        return OrderType.delivery;
      case 'TAKEAWAY' || 'takeaway':
        return OrderType.takeaway;
      case 'EAT_IN' || 'eatIn' || 'eat_in':
        return OrderType.eatIn;
      default:
        return OrderType.delivery;
    }
  }
}

class Order {
  final String? id;
  final int? totalOrders;
  final double? orderPrice;
  final double? deliveryFee;
  final double? totalPrice;
  PaymentMethod? payment;
  OrderStatus? orderStatus;
  final String? deliveryBlock;
  final String? deliveryRoom;
  DeliveryPerson? deliveryPerson;
  final DateTime? createdAt;
  final DateTime? paidAt;
  final List<StoreSmall>? stores;
  final OrderType? orderType;

  Order({
    this.orderType,
    this.deliveryPerson,
    this.id,
    this.totalOrders,
    this.orderPrice,
    this.deliveryFee,
    this.totalPrice,
    this.payment,
    this.orderStatus,
    this.deliveryBlock,
    this.deliveryRoom,
    this.createdAt,
    this.paidAt,
    this.stores,
  });

  // Factory constructor to parse from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    var storesList = json['stores'] as List;
    List<StoreSmall> storeObjs =
        storesList.map((store) => StoreSmall.fromJson(store)).toList();

    return Order(
      orderType: json.containsKey('order_type')
          ? OrderTypeExtension.fromName(json['order_type'])
          : null,
      id: json['id'],
      totalOrders: json['total_orders'],
      orderPrice: json['order_price'].toDouble(),
      deliveryFee: json['delivery_fee'].toDouble(),
      deliveryPerson:
          json.containsKey('delivery_person') && json['delivery_person'] != null
              ? DeliveryPerson.fromJson(json['delivery_person'])
              : DeliveryPerson(),
      totalPrice: json['total_price'].toDouble(),
      payment: json.containsKey('payment_method')
          ? PaymentMethodExtension.fromName(json['payment_method'])
          : PaymentMethod.none,
      orderStatus: json.containsKey('paid_at')
          ? json['paid_at'] == null
              ? OrderStatus.inactive
              : OrderStatusExtension.fromName(
                  json.containsKey('preparation_status')
                      ? json['preparation_status']
                      : json['delivery_status'])
          : OrderStatusExtension.fromName(json.containsKey('preparation_status')
              ? json['preparation_status']
              : json['delivery_status']),
      deliveryBlock: json['delivery_block'] is int
          ? json['delivery_block'].toString()
          : json['delivery_block'],
      deliveryRoom: json['delivery_room'] is int
          ? json['delivery_room'].toString()
          : json['delivery_room'],
      createdAt: DateTime.parse(json['created_at']),
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      stores: storeObjs,
    );
  }

  // Method to convert Order object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_orders': totalOrders,
      'order_price': orderPrice,
      'delivery_fee': deliveryFee,
      'total_price': totalPrice,
      'payment_status': payment,
      'order_status': orderStatus,
      'delivery_block': deliveryBlock,
      'delivery_room': deliveryRoom,
      'created_at': createdAt?.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'stores': stores?.map((store) => store.toJson()).toList(),
    };
  }

  bool isEqual(Order order) {
    return id == order.id &&
        payment == order.payment &&
        orderStatus == order.orderStatus;
  }
}

class DeliveryPerson {
  final String? name;
  final String? phone;
  final String? image;
  final String? gender;

  DeliveryPerson({this.gender, this.name, this.phone, this.image});

  factory DeliveryPerson.fromJson(Map<String, dynamic> json) {
    return DeliveryPerson(
      name: json['first_name'] + ' ' + json['father_name'],
      phone: json['phone_number'],
      image: kDeliveryPersonProfileImageBaseUrl + json['profile_image'],
      gender: json['gender'],
    );
  }
}

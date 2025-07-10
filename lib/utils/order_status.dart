import 'package:flutter/material.dart';

enum OrderStatus {
  inactive,
  active,
  accepted,
  delivered,
  canceled,
  pending,
  inPreparation,
  ready,
  pickedUp
}

extension OrderStatusExtension on OrderStatus {
  String get name {
    switch (this) {
      case OrderStatus.inactive:
        return "Unpaid";
      case OrderStatus.active:
        return "Active";
      case OrderStatus.accepted:
        return "Accepted";
      case OrderStatus.delivered:
        return "Delivered";
      case OrderStatus.canceled:
        return "Canceled";
      case OrderStatus.pending:
        return "Pending";
      case OrderStatus.inPreparation:
        return "In Preparation";
      case OrderStatus.ready:
        return "Ready";
      case OrderStatus.pickedUp:
        return "Picked Up";
    }
  }

  static OrderStatus fromName(String name) {
    switch (name) {
      case "INACTIVE":
        return OrderStatus.inactive;
      case "ACTIVE":
        return OrderStatus.active;
      case "ACCEPTED":
        return OrderStatus.accepted;
      case "DELIVERED":
        return OrderStatus.delivered;
      case "CANCELED":
        return OrderStatus.canceled;
      case "PENDING":
        return OrderStatus.active;
      case "IN_PREPARATION":
        return OrderStatus.inPreparation;
      case "READY":
        return OrderStatus.ready;
      case "PICKED_UP":
        return OrderStatus.pickedUp;
    }
    return OrderStatus.inactive;
  }

  Color get color {
    switch (this) {
      case OrderStatus.inactive:
        return Colors.grey;
      case OrderStatus.active:
        return Colors.orange;
      case OrderStatus.accepted:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.blue;
      case OrderStatus.canceled:
        return Colors.red;
      case OrderStatus.pending:
        return Colors.cyan;
      case OrderStatus.inPreparation:
        return Colors.orange;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.pickedUp:
        return Colors.blue;
    }
  }
}

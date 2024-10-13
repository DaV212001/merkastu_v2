enum OrderStatus { inactive, active, accepted, delivered, canceled }

extension OrderStatusExtension on OrderStatus {
  String get name {
    switch (this) {
      case OrderStatus.inactive:
        return "Unpaid";
      case OrderStatus.active:
        return "Active";
      case OrderStatus.accepted:
        return "On the way";
      case OrderStatus.delivered:
        return "Delivered";
      case OrderStatus.canceled:
        return "Canceled";
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
    }
    return OrderStatus.inactive;
  }
}

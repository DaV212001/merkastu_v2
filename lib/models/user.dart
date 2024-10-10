class User {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final int? phone;
  final int? block;
  final int? room;
  final String? telegramId;
  final String? accessToken;

  User({
    this.telegramId,
    this.accessToken,
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.block,
    this.room,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'block': block,
      'room': room,
    };
  }

  factory User.fromJson(Map<String, dynamic> json, String accessToken) {
    return User(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['student_email'],
        phone: int.parse(json['phone_number']),
        block: json['block_number'],
        room: json['room_number'],
        accessToken: accessToken);
  }
}

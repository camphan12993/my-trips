import 'dart:convert';

class UserPayload {
  final String name;
  final String email;
  final String uid;
  UserPayload({
    required this.name,
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'uid': uid});

    return result;
  }

  factory UserPayload.fromMap(Map<String, dynamic> map) {
    return UserPayload(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserPayload.fromJson(String source) => UserPayload.fromMap(json.decode(source));
}

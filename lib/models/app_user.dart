import 'dart:convert';

class AppUser {
  final String uid;
  final String name;
  final String email;
  final List<String> tripIds;
  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.tripIds,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'tripIds': tripIds});

    return result;
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      tripIds: List<String>.from(map['tripIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) => AppUser.fromMap(json.decode(source));
}

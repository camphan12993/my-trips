import 'dart:convert';

class TripMember {
  final String id;
  final String name;
  TripMember({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});

    return result;
  }

  factory TripMember.fromMap(Map<String, dynamic> map) {
    return TripMember(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TripMember.fromJson(String source) => TripMember.fromMap(json.decode(source));
}

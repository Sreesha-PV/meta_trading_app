

class User {
  final int? id;
  final String? email;
  final String? name;

  User({
    this.id,
    this.email,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        email: json['email'] as String?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (email != null) 'email': email,
        if (name != null) 'name': name,
      };
}


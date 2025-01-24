class User {
  final String id;
  final String username;
  final String name;
  final String email;
  final String phone;
  final String password;

  User({
    required this.id,
    required this.username, // Ensure this is required
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '', // Match the key in your JSON
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}

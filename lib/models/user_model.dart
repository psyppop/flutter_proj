class UserModel {
  final String id;
  final String name;
  final int age;
  final String bio;
  final String location;
  final String occupation;
  final double budget;
  final String moveInDate;
  final String cleanliness;
  final String lifestyle;
  final List<String> images;
  final String email;
  final String phone;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.location,
    required this.occupation,
    required this.budget,
    required this.moveInDate,
    required this.cleanliness,
    required this.lifestyle,
    required this.images,
    required this.email,
    required this.phone,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'bio': bio,
    'location': location,
    'occupation': occupation,
    'budget': budget,
    'moveInDate': moveInDate,
    'cleanliness': cleanliness,
    'lifestyle': lifestyle,
    'images': images,
    'email': email,
    'phone': phone,
    'address': address,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    age: json['age'] as int,
    bio: json['bio'] as String,
    location: json['location'] as String,
    occupation: json['occupation'] as String,
    budget: (json['budget'] as num).toDouble(),
    moveInDate: json['moveInDate'] as String,
    cleanliness: json['cleanliness'] as String,
    lifestyle: json['lifestyle'] as String,
    images: List<String>.from(json['images'] as List),
    email: json['email'] as String? ?? 'Not provided',
    phone: json['phone'] as String? ?? 'Not provided',
    address: json['address'] as String? ?? 'Not provided',
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  UserModel copyWith({
    String? id,
    String? name,
    int? age,
    String? bio,
    String? location,
    String? occupation,
    double? budget,
    String? moveInDate,
    String? cleanliness,
    String? lifestyle,
    List<String>? images,
    String? email,
    String? phone,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age ?? this.age,
    bio: bio ?? this.bio,
    location: location ?? this.location,
    occupation: occupation ?? this.occupation,
    budget: budget ?? this.budget,
    moveInDate: moveInDate ?? this.moveInDate,
    cleanliness: cleanliness ?? this.cleanliness,
    lifestyle: lifestyle ?? this.lifestyle,
    images: images ?? this.images,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

class MyPet {
  String? pet_id;
  String? pet_name;
  String? pet_type;
  String? pet_gender;
  String? pet_age;
  String? pet_health;
  String? category;
  String? description;
  String? image_paths;
  String? lat;
  String? lng;
  String? created_at;

  String? userId;
  String? name;
  String? phone;
  String? email;

  MyPet({
    this.pet_id,
    this.pet_name,
    this.pet_type,
    this.pet_gender,
    this.pet_age,
    this.pet_health,
    this.category,
    this.description,
    this.image_paths,
    this.lat,
    this.lng,
    this.created_at,
    this.userId,
    this.name,
    this.phone,
    this.email,
  });

  MyPet.fromJson(Map<String, dynamic> json) {
    pet_id = json['pet_id'];
    pet_name = json['pet_name'];
    pet_type = json['pet_type'];
    pet_gender = json['pet_gender'];
    pet_age = json['pet_age'];
    pet_health = json['pet_health'];
    category = json['category'];
    description = json['description'];
    image_paths = json['image_paths'];
    lat = json['lat'];
    lng = json['lng'];
    created_at = json['created_at'];
    userId = json['user_id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pet_id'] = pet_id;
    data['pet_name'] = pet_name;
    data['pet_type'] = pet_type;
    data['pet_gender'] = pet_gender;
    data['pet_age'] = pet_age;
    data['pet_health'] = pet_health;
    data['category'] = category;
    data['description'] = description;
    data['image_paths'] = image_paths;
    data['lat'] = lat;
    data['lng'] = lng;
    data['created_at'] = created_at;
    data['user_id'] = userId;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    return data;
  }
}

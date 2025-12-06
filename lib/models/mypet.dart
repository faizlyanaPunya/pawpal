class MyPet {
  String? pet_id;
  String? pet_name;
  String? pet_type;
  String? category;
  String? description;
  String? image_paths;
  String? lat;
  String? lng;
  String? created_at;

  String? userId;
  String? name;

  MyPet({
    this.pet_id,
    this.pet_name,
    this.pet_type,
    this.category,
    this.description,
    this.image_paths,
    this.lat,
    this.lng,
    this.created_at,
    this.userId,
    this.name,
  });

  MyPet.fromJson(Map<String, dynamic> json) {
    pet_id = json['pet_id'];
    pet_name = json['pet_name'];
    pet_type = json['pet_type'];
    category = json['category'];
    description = json['description'];
    image_paths = json['image_paths'];
    lat = json['lat'];
    lng = json['lng'];
    created_at = json['created_at'];
    userId = json['user_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pet_id'] = pet_id;
    data['pet_name'] = pet_name;
    data['pet_type'] = pet_type;
    data['category'] = category;
    data['description'] = description;
    data['image_paths'] = image_paths;
    data['lat'] = lat;
    data['lng'] = lng;
    data['created_at'] = created_at;
    data['user_id'] = userId;
    data['name'] = name;
    return data;
  }
}

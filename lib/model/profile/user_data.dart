// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

class UserProfile {
  UserProfile(
      {required this.userId,
      required this.fullName,
      required this.username,
      required this.email,
      required this.phone,
      required this.bio,
      required this.followers,
      required this.following,
      required this.profileUrl,
      required this.location,
      required this.firebaseAuthID});

  int userId;
  String fullName;
  String username;
  String email;
  String phone;
  dynamic followers;
  dynamic following;
  dynamic bio;
  String profileUrl;
  String firebaseAuthID;
  dynamic location;

  UserProfile copyWith({
    int? userId,
    String? fullName,
    String? username,
    String? email,
    String? phone,
    dynamic bio,
    String? profileUrl,
    dynamic location,
    String? firebaseAuthID,
  }) =>
      UserProfile(
        firebaseAuthID: firebaseAuthID ?? this.firebaseAuthID,
        userId: userId ?? this.userId,
        fullName: fullName ?? this.fullName,
        username: username ?? this.username,
        email: email ?? this.email,
        followers: followers ?? this.followers,
        following: following ?? this.following,
        phone: phone ?? this.phone,
        bio: bio ?? this.bio,
        profileUrl: profileUrl ?? this.profileUrl,
        location: location ?? this.location,
      );

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
      userId: json["id"] ?? 0,
      fullName: json["full_name"] ?? "",
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      followers: json["followers"] ?? 0,
      following: json["following"] ?? 0,
      phone: json["phone"] ?? "",
      bio: json["bio"] ?? "",
      profileUrl: json["img_url"] ??
          json["profileUrl"] ??
          "'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png'",
      location: json["location"] ?? "",
      firebaseAuthID: "");

  factory UserProfile.empty() => UserProfile(
      userId: 0,
      fullName: "",
      username: "",
      email: "",
      followers: 0,
      following: 0,
      phone: "",
      bio: "",
      profileUrl:
          "'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png'",
      location: "",
      firebaseAuthID: "");

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "full_name": fullName,
        "username": username,
        "email": email,
        "phone": phone,
        "bio": bio,
        "img_url": profileUrl,
        "location": location,
      };
}

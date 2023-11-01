class EditData {
  String bio;
  String location;
  String profileURL;
  String fullName;
  String username;
  String number;
  String email;

  EditData(
      {required this.bio,
      required this.location,
      required this.fullName,
      required this.username,
      required this.number,
      required this.email,
      this.profileURL =
          'https://thumbs.dreamstime.com/b/lonely-elephant-against-sunset-beautiful-sun-clouds-savannah-serengeti-national-park-africa-tanzania-artistic-imag-image-106950644.jpg'});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bio'] = this.bio;
    data['profileUrl'] = this.profileURL;
    data['phone'] = this.number;
    data['email'] = this.email;
    data['username'] = this.username;
    data['full_name'] = this.fullName;
    return data;
  }
}

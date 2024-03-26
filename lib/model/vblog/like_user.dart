class LikeUsers {
  String? status;
  List<AllLikerDetails>? allLikerDetails;

  LikeUsers({this.status, this.allLikerDetails});

  LikeUsers.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    if (json['all_liker_details'] != null) {
      allLikerDetails = <AllLikerDetails>[];
      json['all_liker_details'].forEach((v) {
        allLikerDetails!.add(AllLikerDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.allLikerDetails != null) {
      data['all_liker_details'] =
          this.allLikerDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllLikerDetails {
  String? firebaseAuthID;
  String? username;
  String? fullName;
  String? email;
  String? profileURL;
  String? timestamp;

  AllLikerDetails(
      {this.firebaseAuthID,
        this.username,
        this.fullName,
        this.email,
        this.profileURL,
        this.timestamp});

  AllLikerDetails.fromJson(Map<String, dynamic> json) {
    firebaseAuthID = json['firebaseAuthID'];
    username = json['username'];
    fullName = json['full_name'];
    email = json['email'];
    profileURL = json['profileURL'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firebaseAuthID'] = this.firebaseAuthID;
    data['username'] = this.username;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['profileURL'] = this.profileURL;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

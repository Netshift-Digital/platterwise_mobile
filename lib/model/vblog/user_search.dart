// To parse this JSON data, do
//
//     final searchResult = searchResultFromJson(jsonString);

import 'dart:convert';

SearchResult searchResultFromJson(String str) => SearchResult.fromJson(json.decode(str));

String searchResultToJson(SearchResult data) => json.encode(data.toJson());

class SearchResult {
  SearchResult({
   required this.status,
   required this.searchResult,
  });

  String status;
  List<SearchResultElement> searchResult;

  SearchResult copyWith({
    String? status,
    List<SearchResultElement>? searchResult,
  }) =>
      SearchResult(
        status: status ?? this.status,
        searchResult: searchResult ?? this.searchResult,
      );

  factory SearchResult.fromJson(Map<dynamic, dynamic> json) => SearchResult(
    status: json["status"],
    searchResult: List<SearchResultElement>.from(json["search_result"].map((x) => SearchResultElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "search_result": List<dynamic>.from(searchResult.map((x) => x.toJson())),
  };
}

class SearchResultElement {
  SearchResultElement({
  required  this.firebaseAuthId,
  required  this.fullName,
 required   this.username,
    this.email,
    this.phone,
    this.bio,
  required  this.profileUrl,
    this.location,
  required  this.contentPost,
  });

  String firebaseAuthId;
  String fullName;
  String username;
  dynamic email;
  dynamic phone;
  dynamic bio;
  String profileUrl;
  dynamic location;
  String contentPost;

  SearchResultElement copyWith({
    String? firebaseAuthId,
    String? fullName,
    String? username,
    dynamic email,
    dynamic phone,
    dynamic bio,
    String? profileUrl,
    dynamic location,
    String? contentPost,
  }) =>
      SearchResultElement(
        firebaseAuthId: firebaseAuthId ?? this.firebaseAuthId,
        fullName: fullName ?? this.fullName,
        username: username ?? this.username,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        bio: bio ?? this.bio,
        profileUrl: profileUrl ?? this.profileUrl,
        location: location ?? this.location,
        contentPost: contentPost ?? this.contentPost,
      );

  factory SearchResultElement.fromJson(Map<String, dynamic> json) => SearchResultElement(
    firebaseAuthId: json["firebaseAuthID"]??"",
    fullName: json["full_name"]??"",
    username: json["username"]??"",
    email: json["email"]??"",
    phone: json["phone"]??"",
    bio: json["bio"]??"",
    profileUrl: json["profileURL"]??"",
    location: json["location"]??"",
    contentPost: json["content_post"]??"",
  );

  Map<String, dynamic> toJson() => {
    "firebaseAuthID": firebaseAuthId,
    "full_name": fullName,
    "username": username,
    "email": email,
    "phone": phone,
    "bio": bio,
    "profileURL": profileUrl,
    "location": location,
    "content_post": contentPost,
  };
}

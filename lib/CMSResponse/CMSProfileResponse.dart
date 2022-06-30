// To parse this JSON data, do
//
//     final cmsProfile = cmsProfileFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

CmsProfile cmsProfileFromJson(String str) => CmsProfile.fromJson(json.decode(str));

String cmsProfileToJson(CmsProfile data) => json.encode(data.toJson());

class CmsProfile {
  CmsProfile({
    this.status,
    this.message,
    this.profile,
  });

  bool? status;
  String? message;
  List<CMSProfile>? profile;

  factory CmsProfile.fromJson(Map<String, dynamic> json) => CmsProfile(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    profile: json["profile"] == null ? null : List<CMSProfile>.from(json["profile"].map((x) => CMSProfile.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "profile": profile == null ? null : List<dynamic>.from(profile!.map((x) => x.toJson())),
  };
}

class CMSProfile {
  CMSProfile({
    this.id,
    this.departId,
    this.district,
    this.tehsil,
    this.name,
    this.phoneNumber,
    this.post,
    this.cnic,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.isActive,
    this.isdeletedAt,
    this.deletedAt,
    this.deletedBy,
    this.aspuserid,
    this.depart,
  });

  int? id;
  int? departId;
  String? district;
  String? tehsil;
  String? name;
  String? phoneNumber;
  String? post;
  String? cnic;
  DateTime? createdAt;
  String? createdBy;
  dynamic updatedAt;
  dynamic updatedBy;
  bool? isActive;
  dynamic isdeletedAt;
  dynamic deletedAt;
  dynamic deletedBy;
  String? aspuserid;
  dynamic depart;

  factory CMSProfile.fromJson(Map<String, dynamic> json) => CMSProfile(
    id: json["id"] == null ? null : json["id"],
    departId: json["departId"] == null ? null : json["departId"],
    district: json["district"] == null ? null : json["district"],
    tehsil: json["tehsil"] == null ? null : json["tehsil"],
    name: json["name"] == null ? null : json["name"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    post: json["post"] == null ? null : json["post"],
    cnic: json["cnic"] == null ? null : json["cnic"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    updatedAt: json["updatedAt"],
    updatedBy: json["updatedBy"],
    isActive: json["isActive"] == null ? null : json["isActive"],
    isdeletedAt: json["isdeletedAt"],
    deletedAt: json["deletedAt"],
    deletedBy: json["deletedBy"],
    aspuserid: json["aspuserid"] == null ? null : json["aspuserid"],
    depart: json["depart"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "departId": departId == null ? null : departId,
    "district": district == null ? null : district,
    "tehsil": tehsil == null ? null : tehsil,
    "name": name == null ? null : name,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "post": post == null ? null : post,
    "cnic": cnic == null ? null : cnic,
    "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
    "createdBy": createdBy == null ? null : createdBy,
    "updatedAt": updatedAt,
    "updatedBy": updatedBy,
    "isActive": isActive == null ? null : isActive,
    "isdeletedAt": isdeletedAt,
    "deletedAt": deletedAt,
    "deletedBy": deletedBy,
    "aspuserid": aspuserid == null ? null : aspuserid,
    "depart": depart,
  };
}

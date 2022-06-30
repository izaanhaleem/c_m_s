// To parse this JSON data, do
//
//     final cmsComplaint = cmsComplaintFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

CmsComplaint cmsComplaintFromJson(String str) => CmsComplaint.fromJson(json.decode(str));

String cmsComplaintToJson(CmsComplaint data) => json.encode(data.toJson());

class CmsComplaint {
  CmsComplaint({
    this.status,
    this.message,
    this.complaintlist,
  });

  bool? status;
  String? message;
  List<CMSComplaintList>? complaintlist;

  factory CmsComplaint.fromJson(Map<String, dynamic> json) => CmsComplaint(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    complaintlist: json["profile"] == null ? null : List<CMSComplaintList>.from(json["profile"].map((x) => CMSComplaintList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "profile": complaintlist == null ? null : List<dynamic>.from(complaintlist!.map((x) => x.toJson())),
  };
}

class CMSComplaintList {
  CMSComplaintList({
    this.name,
    this.currentstatus,
    this.createddate,
    this.complaintName,
    this.description,
    this.complaintId,
    this.complaintStatusId,
    this.detailComplaintstatus,
  });

  String? name;
  Currentstatus? currentstatus;
  DateTime? createddate;
  ComplaintName? complaintName;
  String? description;
  int? complaintId;
  int? complaintStatusId;
  String? detailComplaintstatus;

  factory CMSComplaintList.fromJson(Map<String, dynamic> json) => CMSComplaintList(
    name: json["name"] == null ? null : json["name"],
    currentstatus: json["currentstatus"] == null ? null : currentstatusValues.map[json["currentstatus"]],
    createddate: json["createddate"] == null ? null : DateTime.parse(json["createddate"]),
    complaintName: json["complaintName"] == null ? null : complaintNameValues.map[json["complaintName"]],
    description: json["description"] == null ? null : json["description"],
    complaintId: json["complaintId"] == null ? null : json["complaintId"],
    complaintStatusId: json["complaintStatusId"] == null ? null : json["complaintStatusId"],
    detailComplaintstatus: json["detailComplaintstatus"] == null ? null : json["detailComplaintstatus"],

  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "currentstatus": currentstatus == null ? null : currentstatusValues.reverse[currentstatus],
    "createddate": createddate == null ? null : createddate!.toIso8601String(),
    "complaintName": complaintName == null ? null : complaintNameValues.reverse[complaintName],
    "description": description == null ? null : description,
    "complaintId": complaintId == null ? null : complaintId,
    "complaintStatusId": complaintStatusId == null ? null : complaintStatusId,
    "detailComplaintstatus": detailComplaintstatus == null? null: detailComplaintstatus,
  };
}

enum ComplaintName { CDSL, ANY_OTHER }

final complaintNameValues = EnumValues({
  "Any Other": ComplaintName.ANY_OTHER,
  "CDSL": ComplaintName.CDSL
});

enum Currentstatus { ACTIVE, RESOLVED, DROPPED }

final currentstatusValues = EnumValues({
  "active": Currentstatus.ACTIVE,
  "Dropped": Currentstatus.DROPPED,
  "Resolved": Currentstatus.RESOLVED
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}

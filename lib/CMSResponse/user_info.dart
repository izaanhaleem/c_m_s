import 'package:json_annotation/json_annotation.dart';
part 'user_info.g.dart';

@JsonSerializable(explicitToJson: true)
class UserInfo {
  String? username;
  String? firstName;
  String? lastName;
  String? id;
  String? password;
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? userName;
  String? healthFacility;
  String? hfCode;
  String? role;
  String? issued;
  String? expires;
  String? token;
  String? expiration;
  String? type;
  String? title;
  String? status;
  String? traceId;
  String? message;
  int? statusCode;
  UserInfo({
       this.username,
       this.password,
       this.userName,
      // this.accessToken,
      // this.tokenType,
      // this.expiresIn,
      // this.userName,
      // this.userId,
      // this.email,
      // this.fullName,
      // this.role,
      // this.issued,
      // this.expires,
      // this.GUIDNew,
    this.firstName,
    this.lastName,
      this.token,
      this.expiration,
      this.type,
      this.title,
      this.status,
      this.traceId,
      this.message,
      this.statusCode,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.id,
    this.healthFacility,
    this.hfCode,
    this.role,
    this.issued,
    this.expires,

  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

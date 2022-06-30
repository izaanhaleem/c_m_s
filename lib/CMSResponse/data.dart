import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  Data({
    required this.username,
    required this.password,
    // required this.accessToken,
    // required this.tokenType,
    // required this.expiresIn,
    // required this.userName,
    // required this.userId,
    // required this.email,
    // required this.fullName,
    // required this.role,
    // required this.issued,
    // required this.expires,
    // required this.GUIDNew,
    required this.token,
    required this.expiration,

  });

  @JsonKey(name: 'username')
  String username;
  @JsonKey(name: 'password')
  String password;
  // String accessToken;
  // String tokenType;
  // int expiresIn;
  // String userName;
  // String userId;
  // String email;
  // String fullName;
  // String role;
  // String issued;
  // String expires;
  // String GUIDNew;
  String token;
  String expiration;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

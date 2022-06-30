// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      username: json['username'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName']as String?,
      id: json['id'] as String?,
      userName:  json['userName'] as String?,
      password: json['password'] as String?,
      token: json['token'] as String?,
      expiration: json['expiration'] as String?,
      expires: json['expires'] as String?,
      role: json['role'] as String?,
      healthFacility:json['healthFacility'] as String?,
      hfCode: json['hfCode'] as String?,
      issued:json['issued'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      status: json['status'] as String?,
      traceId: json['traceId'] as String?,
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
    accessToken: json['accessToken'] as String?,
    tokenType: json['tokenType'] as String?,
    expiresIn: json['expiresIn'] as int?
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'username': instance.username,
      'userName': instance.userName,
      'password': instance.password,
      'token': instance.token,
      'expiration': instance.expiration,
      'type': instance.type,
      'title': instance.title,
      'status': instance.status,
      'traceId': instance.traceId,
      'message': instance.message,
      'statusCode': instance.statusCode,
      'firstName' : instance.firstName,
      'lastName': instance.lastName,
      'id': instance.id,
      'expiresIn': instance.expiresIn,
      'role' : instance.role,
      'tokenType': instance.tokenType,
      'accessToken' : instance.accessToken,
      'statusCode': instance.statusCode,
      'healthFacility': instance.healthFacility,
      'hfCode': instance.hfCode,
      'issued': instance.issued,
      'expires': instance.expires
    };

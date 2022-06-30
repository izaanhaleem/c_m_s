// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      username: json['username'] as String,
      password: json['password'] as String,
      token: json['token'] as String,
      expiration: json['expiration'] as String,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'token': instance.token,
      'expiration': instance.expiration,
    };

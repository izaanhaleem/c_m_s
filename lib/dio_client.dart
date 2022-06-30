// ignore_for_file: prefer_final_fields

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:c_m_s/CMSResponse/CMSComplaintResponse.dart';
import 'CMSResponse/CMSComplaintStatus.dart';
import 'CMSResponse/CMSProfileResponse.dart';
import 'CMSResponse/user_info.dart';
import 'logging.dart';

class DioClient {
  static Dio _dio = Dio(
    BaseOptions(
      //baseUrl : "https://ams.pshealthpunjab.gov.pk",
      baseUrl:    'https://hcms.pshealthpunjab.gov.pk/api/',
      //baseUrl:      'https://sesapi.pshealthpunjab.gov.pk/api/',
      //baseUrl:        'http://172.16.20.99:50463/api/',
     // baseUrl:    'http://172.16.20.99:50463/api/',
      //baseUrl: 'https://evaccs.pshealthpunjab.gov.pk/api/',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ),
  )
    ..interceptors.add(Logging());
/*  Future<UserInfo?> createUser({required UserInfo userInfo}) async {
    UserInfo? retrievedUser;

    try {
      _dio.options.headers['content-Type'] = 'application/json';
      Response response = await _dio.post(
        'Authenticate/login',
        data: userInfo.toJson(),
      );

      print('User created: ${response.data}');

      retrievedUser = UserInfo.fromJson(response.data);
    } catch (e) {
      print('Error creating user: $e');
    }

    return retrievedUser;
  }*/

  Future<UserInfo?> createUser({required UserInfo userInfo}) async {
    UserInfo? retrievedUser;

    try {
      _dio.options.headers['content-Type'] = 'application/json';
      Response response = await _dio.post(
        'Users/Authenticate',
        data: userInfo.toJson(),
      );

      print('User created: ${response.data}');

      retrievedUser = UserInfo.fromJson(response.data);

    } catch (e) {
      print('Error creating user: $e');
    }

    return retrievedUser;
  }

/*  Future<UserInfo?> createUser({required UserInfo userInfo}) async {
    UserInfo? retrievedUser;

    try {
      _dio.options.headers['content-Type'] = 'application/x-www-form-urlencoded';
      Response response = await _dio.post(
        'Users/Authenticate',
        data: userInfo.toJson(),
      );

      print('User created: ${response.data}');

      retrievedUser = UserInfo.fromJson(response.data);
    } catch (e) {
      print('Error creating user: $e');
    }

    return retrievedUser;
  }*/

  Future<UserInfo?> updateUser({
    required UserInfo userInfo,
    required String id,
  }) async {
    UserInfo? updatedUser;

    try {
      Response response = await _dio.put(
        '/users/$id',
        data: userInfo.toJson(),
      );

      print('User updated: ${response.data}');

      updatedUser = UserInfo.fromJson(response.data);
    } catch (e) {
      print('Error updating user: $e');
    }

    return updatedUser;
  }

  Future<void> deleteUser({required String id}) async {
    try {
      await _dio.delete('/users/$id');
      print('User deleted!');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }


  static Future<CmsStatus?> submitform(FormData formData) async {
    CmsStatus? retrievedUser;
    try {
        _dio.options.headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'aspuserid':formData.fields[0].value.toString(),
        'ComplaintID': formData.fields[1].value,
        'status': formData.fields[2].value.toString(),
        'remarks': formData.fields[3].value.toString(),
        'longitude' : formData.fields[4].value.toString(),
        'latitude' : formData.fields[5].value.toString(),
      };
      Response response = await _dio.post(
        'ComplaintsAPI/ComplaintFiles',
        data: formData,
    );
      retrievedUser = CmsStatus.fromJson(response.data);

    } catch (e) {
      print('Error creating user: $e');
    }
    return retrievedUser;
  }

  Future<UserInfo?> submitKitstation(FormData formData) async {
    UserInfo? retrievedUser;

    try {
      final prefs = await SharedPreferences.getInstance();
      const key = 'token';
      final readValue = prefs.getString(key) ?? 0;
      _dio.options.headers["authorization"] = "Bearer $readValue";
      _dio.options.headers['content-Type'] = 'application/json';
      Response response = await _dio.post(
        'Child/AddKitStation',
        data: formData,
      );

      retrievedUser = UserInfo.fromJson(response.data);
    } catch (e) {
      print('Error creating user: $e');
    }

    return retrievedUser;
  }

  static String? userid;
   CmsProfile? cmsProfile;
  List<CMSProfile>? cmsprofile = [];

  static Future<List<CMSProfile>> getProfile() async {
    SharedPreferences prefrences = await SharedPreferences.getInstance();
    userid = prefrences.getString("id");

    //CmsProfile? res;
      _dio.options.headers['content-Type'] = 'application/x-www-form-urlencoded';
      Response response = await _dio.get('Profile/GetProfile?userID=$userid');

    if (response.statusCode == 200) {
      CmsProfile res = CmsProfile.fromJson(response.data);
      var cmsprofile = res.profile!.toList();
      return cmsprofile;
    } else {
      throw Exception('Failed to load internet');
    }

  }

  CmsComplaint? cmsComplaint;
  List<CMSComplaintList>? cmscomplaint = [];

  static Future<List<CMSComplaintList>> fetchComplaint() async {
    SharedPreferences prefrences = await SharedPreferences.getInstance();
    userid = prefrences.getString("id");
    Response response = await _dio.get("ComplaintsAPI/Complaints?userID=$userid");

    if (response.statusCode == 200) {
      CmsComplaint res = CmsComplaint.fromJson(response.data);
      var cmscomplaint = res.complaintlist!.toList();
      return cmscomplaint;
    } else {
      throw Exception('Failed to load internet');
    }
  }
}
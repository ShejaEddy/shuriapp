import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// const BASE_URL = 'https://api.shuribusapp.com/api/v1';
const BASE_URL = 'http://shuriapi.herokuapp.com/api/v1';

// getting token

Map<String, String> headers = {"Content-type": "application/json"};

Future<Map<String, dynamic>> driverVerifyNumber(
    String driverPhoneNumber) async {
  var url = BASE_URL + '/account/mobile/validate';
  final response = await http.post(url,
      headers: headers,
      body: json
          .encode({'resource': "Driver", 'phoneNumber': driverPhoneNumber}));
  var authResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    return {'status': 200, 'message': authResponse['message']};
  }
  return {'status': response.statusCode, 'message': authResponse['message']};
}

Future<Map<String, dynamic>> driverValidateOTP(
    String driverPhoneNumber, String otp) async {
  if (kDebugMode) {
    print('phone -> $driverPhoneNumber');
    print('code -> $otp');
  }
  var url = BASE_URL + '/account/mobile/activate';

  final response = await http.post(url,
      headers: headers,
      body: json.encode({
        'resource': "Driver",
        'code': otp,
        'phoneNumber': driverPhoneNumber
      }));
  var data = json.decode(response.body);

  if (response.statusCode == 200) {
    return {
      'status': response.statusCode,
      'message': data['message'],
      'token': data['token']
    };
  } else {
    return {'status': response.statusCode, 'error': data['error']};
  }
}

Future<Map<String, dynamic>> driverInfo(String driverId) async {
  var url = BASE_URL + '/drivers/$driverId';
  // getting token
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('jwt_token');
  headers['Authorization'] = 'Bearer ' + token;
  final response = await http.get(url, headers: headers);
  var activationresponse = json.decode(response.body);
  if (kDebugMode) print('response -> $activationresponse');
  return activationresponse;
}

Future<Map<String, dynamic>> getBusStops(
    String driverId, String schoolId) async {
  var url = BASE_URL + '/drivers/$driverId/schools/$schoolId/busstops';
  // getting token
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('jwt_token');
  headers['Authorization'] = 'Bearer ' + token;
  final response = await http.get(url, headers: headers);
  var busStopResponse = json.decode(response.body);
  if (kDebugMode) print('response -> $busStopResponse');
  return busStopResponse;
}
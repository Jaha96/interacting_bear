import 'dart:io';
import 'dart:async';
import 'dart:convert' show base64, json, utf8;
import 'dart:typed_data';

import 'package:interacting_tom/env/env.dart';

class TextToSpeechAPI {
  static final TextToSpeechAPI _singleton = TextToSpeechAPI._internal();
  final _httpClient = HttpClient();
  static final _apiKey = Env.googleCloudKey;
  static const _apiURL = "texttospeech.googleapis.com";

  factory TextToSpeechAPI() {
    return _singleton;
  }

  TextToSpeechAPI._internal();

  Future<Uint8List> synthesizeText(String text, String lang) async {
    try {
      final languageCode = lang == "en" ? "en-US" : "ja-JP";
      final name = lang == "en" ? "en-US-Neural2-J" : "ja-JP-Neural2-D";
      final uri = Uri.https(_apiURL, '/v1beta1/text:synthesize');
      final Map json = {
        'input': {'text': text},
        'voice': {'name': name, 'languageCode': languageCode},
        'audioConfig': {
          'audioEncoding': 'MP3',
          "effectsProfileId": ["telephony-class-application"],
          "pitch": 6.4,
          "speakingRate": 1
        }
      };

      final jsonResponse = await _postJson(uri, json);
      final Uint8List bodyBytes = base64.decode(jsonResponse['audioContent']);
      return bodyBytes;
    } on Exception catch (e) {
      print("$e");
      return Uint8List(0);
    }
  }

  Future<List<Voice>> getVoices() async {
    try {
      final uri = Uri.https(_apiURL, '/v1beta1/voices');

      final jsonResponse = await _getJson(uri);
      final List<dynamic> voicesJSON = jsonResponse['voices'].toList();

      final voices = Voice.mapJSONStringToList(voicesJSON);
      return voices;
    } on Exception catch (e) {
      print("$e");
      return [];
    }
  }

  Future<Map<String, dynamic>> _postJson(Uri uri, Map jsonMap) async {
    try {
      final httpRequest = await _httpClient.postUrl(uri);
      final jsonData = utf8.encode(json.encode(jsonMap));
      final jsonResponse =
          await _processRequestIntoJsonResponse(httpRequest, jsonData);
      return jsonResponse;
    } on Exception catch (e) {
      print("$e");
      return {};
    }
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final httpRequest = await _httpClient.getUrl(uri);
      final jsonResponse =
          await _processRequestIntoJsonResponse(httpRequest, null);
      return jsonResponse;
    } on Exception catch (e) {
      print("$e");
      return {};
    }
  }

  Future<Map<String, dynamic>> _processRequestIntoJsonResponse(
      HttpClientRequest httpRequest, List<int>? data) async {
    try {
      httpRequest.headers.add('X-Goog-Api-Key', _apiKey);
      httpRequest.headers
          .add(HttpHeaders.contentTypeHeader, 'application/json');
      if (data != null) {
        httpRequest.add(data);
      }
      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.ok) {
        throw Exception('Bad Response');
      }
      final responseBody = await httpResponse.transform(utf8.decoder).join();
      return json.decode(responseBody);
    } on Exception catch (e) {
      print("$e");
      return {};
    }
  }
}

class Voice {
  final String name;
  final String gender;
  final List<String> languageCodes;

  Voice(this.name, this.gender, this.languageCodes);

  static List<Voice> mapJSONStringToList(List<dynamic> jsonList) {
    return jsonList.map((v) {
      return Voice(
          v['name'], v['ssmlGender'], List<String>.from(v['languageCodes']));
    }).toList();
  }
}

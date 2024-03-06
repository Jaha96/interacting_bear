// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(
      varName: 'OPEN_AI_API_KEY', obfuscate: true) // the .env variable.
  static final String apiKey = _Env.apiKey;

  @EnviedField(
      varName: 'OPEN_AI_ORG_ID', defaultValue: '') // the .env variable.
  static final String organization = _Env.organization;

  @EnviedField(
      varName: 'GOOGLE_CLOUD_API_KEY', obfuscate: true) // the .env variable.
  static final String googleCloudKey = _Env.googleCloudKey;
}

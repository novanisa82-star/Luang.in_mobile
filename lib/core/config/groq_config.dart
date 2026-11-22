import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqConfig {
  /// Mendapatkan API Key murni dari file `.env` (GROQ_API_KEY)
  static String getApiKey() {
    final envKey = dotenv.env['GROQ_API_KEY'];
    if (envKey != null && envKey.trim().isNotEmpty) {
      return envKey.trim();
    }
    return '';
  }

  /// Model utama yang aktif dan didukung di akun Groq saat ini
  static const String textModel = 'openai/gpt-oss-120b';

  /// Model cadangan cepat jika diperlukan
  static const String fallbackTextModel = 'openai/gpt-oss-20b';

  /// Endpoint Groq Chat Completions (OpenAI Compatible)
  static const String apiUrl = 'https://api.groq.com/openai/v1/chat/completions';
}

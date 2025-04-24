import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyPrefix = 'generated_image_';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveImage(String prompt, Map<String, Uint8List> images) async {
    final timestamp = DateTime.now().toIso8601String();
    final imageData = {
      'prompt': prompt,
      'timestamp': timestamp,
      'images': images.map((key, value) => MapEntry(key, base64Encode(value))),
    };

    await _prefs.setString('$_keyPrefix$timestamp', jsonEncode(imageData));
  }

  List<Map<String, dynamic>> getAllImages() {
    final List<Map<String, dynamic>> images = [];

    for (final key in _prefs.getKeys()) {
      if (key.startsWith(_keyPrefix)) {
        try {
          final data = jsonDecode(_prefs.getString(key) ?? '{}');
          final decodedImages = (data['images'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, base64Decode(value as String)));
          images.add({
            'prompt': data['prompt'],
            'timestamp': data['timestamp'],
            'images': decodedImages,
          });
        } catch (e) {
          print('Error decoding image: $e');
        }
      }
    }

    images.sort((a, b) =>
        (b['timestamp'] as String).compareTo(a['timestamp'] as String));
    return images;
  }

  Future<void> deleteImage(String timestamp) async {
    await _prefs.remove('$_keyPrefix$timestamp');
  }
}

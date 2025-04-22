import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';  // Add this import


class ImageService {
  final String hfApiKey = dotenv.env['HUGGINGFACE_API_TOKEN'] ?? '';
  final String stableDiffusionModel1 = "stabilityai/stable-diffusion-2";
  final String stableDiffusionModel = "stabilityai/stable-diffusion-3.5-large";
  final String dalleModel = "stabilityai/stable-diffusion-3.5-large-turbo";

  // Generate images using both models
  Future<Map<String, Uint8List?>> generateImages(String prompt) async {
    // final stableDiffusionImage1 = await _generateImage(prompt, stableDiffusionModel1);
    // final stableDiffusionImage = await _generateImage(prompt, stableDiffusionModel);
    // final dalleImage = await _generateImage(prompt, dalleModel);
    final s = await Future.wait([
      _generateImage(prompt, stableDiffusionModel1),
    _generateImage(prompt, stableDiffusionModel),
     _generateImage(prompt, dalleModel),
    ]);
final stableDiffusionImage1 = s[0];
    final stableDiffusionImage = s[1];
    final dalleImage = s[2];
    return {
      "Stable Diffusion 2": stableDiffusionImage1,
      "Stable Diffusion 3.5": stableDiffusionImage,
      "Stable Diffusion 3.5 Large Turbo": dalleImage,
    };
  }

  // Function to generate images from Hugging Face models
  Future<Uint8List?> _generateImage(String prompt, String model) async {
    try {
      final response = await http.post(
        Uri.parse("https://api-inference.huggingface.co/models/$model"),
        headers: {
          "Authorization": "Bearer $hfApiKey",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "inputs": prompt,
          "parameters": {
            "width": 512,
            "height": 512,
            "guidance_scale": 7.5,
            "num_inference_steps": 50
          }
        }),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
    return null;
  }
}

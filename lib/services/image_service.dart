import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageService {
  final String hfApiKey = dotenv.env['HUGGINGFACE_API_TOKEN'] ?? '';
  final String stableDiffusionModel1 = "stabilityai/stable-diffusion-2";
  final String stableDiffusionModel = "stabilityai/stable-diffusion-3.5-large";
  final String dalleModel = "stabilityai/stable-diffusion-3.5-large-turbo";

  // Generate images using all three models
  Future<Map<String, Uint8List?>> generateImages(String prompt) async {
    try {
      // Run all three requests concurrently for better performance
      final results = await Future.wait([
        _generateImage(prompt, stableDiffusionModel1),
        _generateImage(prompt, stableDiffusionModel),
        _generateImage(prompt, dalleModel),
      ]);

      return {
        "Stable Diffusion 2": results[0],
        "Stable Diffusion 3.5": results[1],
        "Stable Diffusion 3.5 Large Turbo": results[2],
      };
    } catch (e) {
      print("Error generating images: $e");
      return {
        "Stable Diffusion 2": null,
        "Stable Diffusion 3.5": null,
        "Stable Diffusion 3.5 Large Turbo": null,
      };
    }
  }

  // Function to generate images from Hugging Face models
  Future<Uint8List?> _generateImage(String prompt, String model) async {
    try {
      print("Generating image with model: $model");
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
        print(
            "Error with model $model: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception with model $model: $e");
      return null;
    }
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageService {
  final String hfApiKey = dotenv.env['HUGGINGFACE_API_TOKEN'] ?? '';

  final String fluxModel = "black-forest-labs/FLUX.1-dev";
  final String fluxSchnellModel = "black-forest-labs/FLUX.1-schnell";
  final String stableDiffusionModel = "stabilityai/stable-diffusion-3.5-large";

  final bool _isDebug = true;

  Future<Map<String, Uint8List?>> generateImages(String prompt) async {
    _debugPrint('Starting image generation for prompt: "$prompt"');

    try {
      String enhancedPrompt = "High quality, detailed image of $prompt";

      final results = await Future.wait([
        _generateImage(enhancedPrompt, fluxModel).catchError((e) {
          _debugPrint('Error in FLUX model: $e');
          return null;
        }),
        _generateImage(enhancedPrompt, stableDiffusionModel).catchError((e) {
          _debugPrint('Error in Stable Diffusion: $e');
          return null;
        }),
        _generateImage(enhancedPrompt, fluxSchnellModel).catchError((e) {
          _debugPrint('Error in FLUX.Schnell model: $e');
          return null;
        }),
      ]);

      return {
        "FLUX AI 1.0": results[0],
        "Stable Diffusion 3.5": results[1],
        "FLUX Schnell": results[2],
      };
    } catch (e) {
      _debugPrint('Error in generateImages: $e');
      return {
        "FLUX AI 1.0": null,
        "Stable Diffusion 3.5": null,
        "FLUX Schnell": null,
      };
    }
  }

  Future<Uint8List?> _generateImage(String prompt, String model) async {
    _debugPrint('Requesting image from model: $model');

    try {
      final Map<String, dynamic> parameters =
          _getParametersForModel(model, prompt);

      final response = await http
          .post(
            Uri.parse("https://api-inference.huggingface.co/models/$model"),
            headers: {
              "Authorization": "Bearer $hfApiKey",
              "Content-Type": "application/json"
            },
            body: jsonEncode(parameters),
          )
          .timeout(Duration(seconds: 120));

      await _checkRateLimit(response, model);

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        if (response.body.contains("currently loading")) {
          _debugPrint('Model still loading. Retrying...');
          await Future.delayed(Duration(seconds: 10));
          return _retryGenerateImage(prompt, model);
        }
        return null;
      }
    } catch (e) {
      _debugPrint('Exception in _generateImage: $e');
      return null;
    }
  }

  Future<Uint8List?> _retryGenerateImage(String prompt, String model) async {
    try {
      final Map<String, dynamic> parameters =
          _getParametersForModel(model, prompt);

      final response = await http
          .post(
            Uri.parse("https://api-inference.huggingface.co/models/$model"),
            headers: {
              "Authorization": "Bearer $hfApiKey",
              "Content-Type": "application/json"
            },
            body: jsonEncode(parameters),
          )
          .timeout(Duration(seconds: 120));

      await _checkRateLimit(response, model);

      return response.statusCode == 200 ? response.bodyBytes : null;
    } catch (e) {
      _debugPrint('Retry failed: $e');
      return null;
    }
  }

  Map<String, dynamic> _getParametersForModel(String model, String prompt) {
    Map<String, dynamic> baseParams = {
      "inputs": prompt,
      "parameters": {
        "width": 512,
        "height": 512,
        "guidance_scale": 7.5,
        "num_inference_steps": 30,
        "negative_prompt": "blurry, bad quality, distorted, deformed",
      }
    };

    if (model == fluxModel) {
      baseParams["parameters"] = {
        "width": 768,
        "height": 768,
        "guidance_scale": 3.5,
        "num_inference_steps": 30,
        "negative_prompt":
            "poor quality, bad anatomy, worst quality, low quality",
      };
    } else if (model == fluxSchnellModel) {
      baseParams["parameters"] = {
        "guidance_scale": 0.0,
        "num_inference_steps": 4,
        "max_sequence_length": 256,
        "generator": "manual_seed_0"
      };
    } else if (model == stableDiffusionModel) {
      baseParams["parameters"] = {
        "width": 768,
        "height": 768,
        "guidance_scale": 7.0,
        "num_inference_steps": 30,
      };
    }

    return baseParams;
  }

  void _debugPrint(String msg) {
    if (_isDebug) print('[ImageService] $msg');
  }

  Future<void> _checkRateLimit(http.Response response, String model) async {
    final headers = response.headers;
    final remaining =
        int.tryParse(headers['x-ratelimit-remaining'] ?? '0') ?? 0;
    if (remaining < 5) {
      _debugPrint('Rate limit approaching for $model: $remaining remaining');
    }

    if (response.statusCode == 429) {
      _debugPrint('Rate limit hit. Delaying...');
      await Future.delayed(Duration(seconds: 15));
    }
  }
}

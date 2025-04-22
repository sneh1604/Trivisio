import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import '../services/image_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImageService _imageService = ImageService();
  final TextEditingController _promptController = TextEditingController();
  Map<String, Uint8List?> _generatedImages = {};
  bool _isLoading = false;
  String _message = "Enter a creative prompt to generate images!";

  Future<void> _generateImages() async {
    if (_promptController.text.trim().isEmpty) {
      setState(() {
        _message = "⚠️ Please enter a prompt!";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _generatedImages.clear();
      _message = "Generating images...";
    });

    try {
      final images = await _imageService.generateImages(_promptController.text);
      setState(() {
        _generatedImages = images;

        // Count how many images were successfully generated
        int successCount = 0;
        images.values.forEach((image) {
          if (image != null) successCount++;
        });

        if (successCount == 0) {
          _message = "❌ Failed to generate any images.";
        } else if (successCount < 3) {
          _message =
              "⚠️ Generated $successCount of 3 images. Some models failed.";
        } else {
          _message = "🎨 All images created successfully! Compare the results.";
        }
      });
    } catch (e) {
      setState(() {
        _message = "❌ Error generating images: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await AuthService().signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  Future<void> _downloadImage(Uint8List imageBytes, String imageName) async {
    try {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$imageName.png';

      File file = File(filePath);
      await file.writeAsBytes(imageBytes);

      final params = SaveFileDialogParams(sourceFilePath: filePath);
      final result = await FlutterFileDialog.saveFile(params: params);

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Image saved successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Image save canceled.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error saving image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(color: Colors.black),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _promptController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Enter your idea...",
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white10,
                    suffixIcon: Icon(Icons.edit, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _generateImages,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: Text("Generate Images"),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? Column(
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 10),
                          Text("Creating masterpieces...",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white70)),
                        ],
                      )
                    : _generatedImages.isNotEmpty
                        ? Column(
                            children: _generatedImages.entries.map((entry) {
                              return entry.value != null
                                  ? _buildImageCard(entry.key, entry.value!)
                                  : SizedBox();
                            }).toList(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              _message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(String title, Uint8List imageBytes) {
    return Card(
      color: Color(0xFF323232),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                imageBytes,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () =>
                  _downloadImage(imageBytes, title.replaceAll(" ", "_")),
              icon: Icon(Icons.download),
              label: Text("Download"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageGallerySaver {
  static Future<Map<String, dynamic>> saveImage(Uint8List imageBytes,
      {required String name}) async {
    throw UnimplementedError();
  }
}

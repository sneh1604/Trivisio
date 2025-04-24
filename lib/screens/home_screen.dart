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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ImageService _imageService = ImageService();
  final TextEditingController _promptController = TextEditingController();
  Map<String, Uint8List?> _generatedImages = {};
  bool _isLoading = false;
  String _message = "Enter a creative prompt to generate images!";
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
      final images = await _imageService.generateImages(_promptController.text, context);
      setState(() {
        _generatedImages = images;

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

  Future<void> _logout() async {
    await AuthService().signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "TRIVISIO",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C63FF),
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Create Visual Masterpieces",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "Powered by Triple AI Models",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _promptController,
                        style: TextStyle(color: Colors.white),
                        maxLines: 2,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: "Describe what you want to create...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(20),
                          prefixIcon: Icon(Icons.lightbulb_outline,
                              color: Colors.amber),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear, color: Colors.white54),
                            onPressed: () => _promptController.clear(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: _isLoading ? 60 : double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _generateImages,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(_isLoading ? 30 : 16),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 8,
                          shadowColor: Colors.purpleAccent.withOpacity(0.5),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.auto_awesome, size: 24),
                                  SizedBox(width: 10),
                                  Text(
                                    "Generate AI Art",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_isLoading)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LoadingAnimation(animation: _animation),
                          SizedBox(height: 15),
                          Text(
                            "Creating your masterpieces...",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? SizedBox()
                    : _generatedImages.isEmpty
                        ? _buildEmptyState()
                        : SingleChildScrollView(
                            child: _buildGeneratedImagesGallery(),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.create,
                size: 60,
                color: Colors.white54,
              ),
              SizedBox(height: 20),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Try: \"a serene lake with mountains at sunset\"",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white38,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneratedImagesGallery() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _generatedImages.entries.map((entry) {
        return entry.value != null
            ? _buildEnhancedImageCard(entry.key, entry.value!)
            : SizedBox.shrink();
      }).toList(),
    );
  }

  void _showFullImage(
      BuildContext context, Uint8List imageBytes, String title) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                    maxWidth: MediaQuery.of(context).size.width - 40,
                  ),
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4,
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                            child: Icon(Icons.error, color: Colors.red));
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
                label: Text("Close"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.7),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedImageCard(String title, Uint8List imageBytes) {
    final Map<String, Color> modelColors = {
      "FLUX AI 1.0": Colors.purpleAccent,
      "Stable Diffusion 3.5": Colors.blueAccent,
      "FLUX Schnell": Colors.orangeAccent,
    };

    final color = modelColors[title] ?? Colors.tealAccent;

    return Container(
      margin: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getIconForModel(title),
                          color: color,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "AI Generated",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 300,
              minHeight: 200,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Image.memory(
                imageBytes,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Icon(Icons.error, color: Colors.red));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 10,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _actionButton(
                      icon: Icons.zoom_in,
                      color: Colors.white,
                      onTap: () => _showFullImage(context, imageBytes, title),
                    ),
                    SizedBox(width: 10),
                    _actionButton(
                      icon: Icons.share,
                      color: Colors.white,
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                  onPressed: () =>
                      _downloadImage(imageBytes, title.replaceAll(" ", "_")),
                  icon: Icon(Icons.download),
                  label: Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                  ],
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: color,
          size: 22,
        ),
      ),
    );
  }

  IconData _getIconForModel(String modelName) {
    switch (modelName) {
      case "FLUX AI 1.0":
        return Icons.auto_awesome;
      case "Stable Diffusion 3.5":
        return Icons.diamond;
      case "FLUX Schnell":
        return Icons.bolt;
      default:
        return Icons.image;
    }
  }
}

class LoadingAnimation extends StatelessWidget {
  final Animation<double> animation;

  const LoadingAnimation({Key? key, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDot(0, Colors.purpleAccent),
            SizedBox(width: 10),
            _buildDot(0.2, Colors.blueAccent),
            SizedBox(width: 10),
            _buildDot(0.4, Colors.orangeAccent),
          ],
        );
      },
    );
  }

  Widget _buildDot(double delay, Color color) {
    final double size = 12 + (5 * ((animation.value + delay) % 1.0));
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
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

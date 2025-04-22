import 'package:flutter/material.dart';
import 'dart:math' as math;

class DescriptionScreen extends StatelessWidget {
  final List<Map<String, dynamic>> models = [
    {
      "name": "FLUX AI 1.0",
      "description":
          "FLUX AI represents a new generation of state-of-the-art image creation, excelling at photorealistic images with incredible detail and composition. Created by Black Forest Labs, it features heightened prompt adherence and exceptional handling of complex scenes.",
      "key_features": [
        "Photorealistic rendering with superior detail",
        "Enhanced understanding of complex prompts",
        "Exceptional lighting and shadow handling",
        "Superior composition and artistic styles"
      ],
      "icon": Icons.auto_awesome,
      "color": Colors.purpleAccent,
      "gradient": [Color(0xFF8A2BE2), Color(0xFF4B0082)],
    },
    {
      "name": "Stable Diffusion 3.5",
      "description":
          "Stable Diffusion 3.5 is the latest flagship model from Stability AI, featuring breakthrough improvements in image quality and prompt understanding. It excels at creating coherent, detailed images across a wide range of styles.",
      "key_features": [
        "Improved text-to-image alignment",
        "Superior image coherence and composition",
        "Enhanced facial and anatomical accuracy",
        "Wider aesthetic range from photorealism to stylized art"
      ],
      "icon": Icons.diamond,
      "color": Colors.blueAccent,
      "gradient": [Color(0xFF1E88E5), Color(0xFF0D47A1)],
    },
    {
      "name": "FLUX Schnell",
      "description":
          "FLUX Schnell is an optimized variant designed for rapid image generation while maintaining high quality. Developed by Black Forest Labs, this model excels at quickly producing draft concepts and design iterations.",
      "key_features": [
        "Ultra-fast image generation (4 inference steps)",
        "Optimized for rapid prototyping",
        "Maintains impressive quality despite speed",
        "Perfect for iterative design workflows"
      ],
      "icon": Icons.bolt,
      "color": Colors.orangeAccent,
      "gradient": [Color(0xFFFF9800), Color(0xFFFF5722)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      "AI Technology",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      "Powering your creative vision",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: models.length,
                  itemBuilder: (context, index) {
                    final model = models[index];
                    return _buildModelCard(model, context, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelCard(
      Map<String, dynamic> model, BuildContext context, int index) {
    return Hero(
      tag: "model_${model["name"]}",
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: model["gradient"],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),

                // Pattern overlay
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.07,
                    child: CustomPaint(
                      painter: PatternPainter(),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with icon
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              model["icon"],
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              model["name"],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          _buildBadge(index),
                        ],
                      ),

                      SizedBox(height: 15),

                      // Description
                      Text(
                        model["description"],
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Features list
                      ...model["key_features"].map<Widget>((feature) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.3,
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      SizedBox(height: 10),

                      // Info button
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            _showModelDetails(context, model);
                          },
                          icon: Icon(Icons.info_outline, color: Colors.white),
                          label: Text(
                            "Learn More",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(int index) {
    IconData icon;
    Color color;
    String label;

    if (index == 0) {
      icon = Icons.military_tech;
      color = Colors.amber;
      label = "PREMIUM";
    } else if (index == 1) {
      icon = Icons.auto_awesome;
      color = Colors.lightBlueAccent;
      label = "STANDARD";
    } else {
      icon = Icons.bolt;
      color = Colors.orangeAccent;
      label = "FAST";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showModelDetails(BuildContext context, Map<String, dynamic> model) {
    final modelIndex = models.indexWhere((m) => m["name"] == model["name"]);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model["name"] + " Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildDetailRow(Icons.speed, "Speed",
                      modelIndex == 2 ? "Very Fast" : "Standard"),
                  _buildDetailRow(
                      Icons.aspect_ratio, "Resolution", "Up to 1024x1024"),
                  _buildDetailRow(Icons.palette, "Style Range", "Wide"),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.white70),
          SizedBox(width: 10),
          Text(
            label + ":",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 50; i++) {
      final x = math.Random().nextDouble() * size.width;
      final y = math.Random().nextDouble() * size.height;
      final radius = math.Random().nextDouble() * 10 + 5;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    for (int i = 0; i < 20; i++) {
      final x1 = math.Random().nextDouble() * size.width;
      final y1 = math.Random().nextDouble() * size.height;
      final x2 = math.Random().nextDouble() * size.width;
      final y2 = math.Random().nextDouble() * size.height;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

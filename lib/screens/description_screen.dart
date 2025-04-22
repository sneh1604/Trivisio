import 'package:flutter/material.dart';

class DescriptionScreen extends StatelessWidget {
  final List<Map<String, dynamic>> models = [
    {
      "name": "Stable Diffusion 2",
      "description":
          "Stable Diffusion 2 enhances image resolution and coherence, creating sharper and more detailed images. Ideal for artistic and abstract visuals, but may struggle with multi-object complexity.",
      "key_features": [
        "Supports up to 768x768 resolution",
        "Improved denoising for cleaner images",
        "Better object consistency",
        "Best for artistic and conceptual visuals"
      ],
      "color": Colors.blueAccent,
    },
    {
      "name": "Stable Diffusion 3.5",
      "description":
          "Stable Diffusion 3.5 improves texture, lighting, and anatomy, making it perfect for more realistic images. It excels in detailed compositions and complex prompts.",
      "key_features": [
        "Higher detail rendering",
        "Enhanced prompt understanding",
        "Better facial & hand accuracy",
        "Best for semi-realistic and character design"
      ],
      "color": Colors.greenAccent,
    },
    {
      "name": "Stable Diffusion 3.5 Large Turbo",
      "description":
          "Optimized for speed and efficiency, this model generates high-quality images faster while reducing artifacts. Great for commercial use and high-volume AI-generated art.",
      "key_features": [
        "Speed optimized for faster image generation",
        "Reduced artifacts for cleaner results",
        "Scalable for handling multiple generations",
        "Best for fast prototyping and AI artwork"
      ],
      "color": Colors.orangeAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: models.length,
          itemBuilder: (context, index) {
            final model = models[index];
            return AnimatedContainer(
              duration: Duration(milliseconds: 500),
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: model["color"]!, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: model["color"]!.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: Offset(2, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model["name"]!,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: model["color"]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    model["description"]!,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Divider(color: model["color"]!.withOpacity(0.5)),
                  SizedBox(height: 10),
                  Column(
                    children: model["key_features"].map<Widget>((feature) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle,
                              color: model["color"], size: 18),
                          SizedBox(width: 8),
                          Expanded(
                              child: Text(feature,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[300]))),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

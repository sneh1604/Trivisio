import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sample_login/services/auth_service.dart';
import 'package:sample_login/screens/auth_check_screen.dart';
import 'package:sample_login/screens/home_screen.dart';
import 'package:sample_login/screens/description_screen.dart';
import 'package:sample_login/screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(),
        ),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          if (!authService.isInitialized) {
            // Show loading screen until auth state is determined
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.dark(),
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(),
            home: authService.user != null ? MainScreen() : LoginScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // Home screen for image generation
    DescriptionScreen(), // Details of AI models used
    AuthCheckScreen(), // Authentication check screen (previously the main screen)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // Close drawer when navigating
    });
  }

  Future<void> _logout() async {
    await Provider.of<AuthService>(context, listen: false).signOut();
    // The navigation will happen automatically due to the Consumer in MyApp
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Image Generator"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_fix_high_sharp,
                      size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text("AI Image Generator",
                      style: TextStyle(fontSize: 22, color: Colors.white)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Model Details"),
              onTap: () => _onItemTapped(1),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}

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

  // Load .env file first
  await dotenv.load(fileName: ".env");
  if (dotenv.env['HUGGINGFACE_API_TOKEN']?.isEmpty ?? true) {
    print('WARNING: HUGGINGFACE_API_TOKEN not found in .env file');
  }

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
              title: 'TRIVISIO',
              theme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Color(0xFF6C63FF),
                colorScheme: ColorScheme.dark(
                  primary: Color(0xFF6C63FF),
                  secondary: Color(0xFF03DAC5),
                  surface: Color(0xFF121212),
                  background: Color(0xFF121212),
                ),
                scaffoldBackgroundColor: Color(0xFF121212),
                fontFamily: 'Montserrat',
                textTheme: TextTheme(
                  headlineMedium: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                appBarTheme: AppBarTheme(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
              ),
              home: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "TRIVISIO",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C63FF),
                          letterSpacing: 3,
                        ),
                      ),
                      SizedBox(height: 20),
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'TRIVISIO',
            theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Color(0xFF6C63FF),
              colorScheme: ColorScheme.dark(
                primary: Color(0xFF6C63FF),
                secondary: Color(0xFF03DAC5),
                surface: Color(0xFF121212),
                background: Color(0xFF121212),
              ),
              scaffoldBackgroundColor: Color(0xFF121212),
              fontFamily: 'Montserrat',
              textTheme: TextTheme(
                headlineMedium: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              appBarTheme: AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
            ),
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
    final String _appBarTitles = ["Create", "Explore Models"][_selectedIndex];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TRIVISIO",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 2,
              ),
            ),
            Text(
              _appBarTitles,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: Icon(Icons.logout_outlined, color: Colors.white, size: 18),
            ),
            onPressed: _logout,
          ),
          SizedBox(width: 8),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6C63FF),
                      Color(0xFF5A56E0),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          Icon(Icons.flash_on, size: 30, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "TRIVISIO",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      "AI-Powered Image Generation",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      icon: Icons.auto_awesome,
                      title: "Create Images",
                      isSelected: _selectedIndex == 0,
                      onTap: () => _onItemTapped(0),
                    ),
                    _buildDrawerItem(
                      icon: Icons.psychology,
                      title: "AI Models",
                      isSelected: _selectedIndex == 1,
                      onTap: () => _onItemTapped(1),
                    ),
                    Divider(color: Colors.white12),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      title: "Settings",
                    ),
                    _buildDrawerItem(
                      icon: Icons.help_outline,
                      title: "Help & Support",
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "TRIVISIO v1.0",
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.auto_awesome),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology),
            label: 'Models',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            isSelected ? Theme.of(context).colorScheme.primary : Colors.white70,
      ),
      title: Text(
        title,
        style: TextStyle(
          color:
              isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}

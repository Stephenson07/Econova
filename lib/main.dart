import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase.dart';
import 'state/state.dart';
import 'screens/home_screen.dart';
import 'screens/store_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/signup_screen.dart';
import 'widgets/custom_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before running the app
  await FirebaseService.initializeFirebase();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Econova',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      home: const SignUpScreen(),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'Poppins'),
        bodyMedium: TextStyle(fontFamily: 'Poppins'),
        headlineLarge: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  // Define screens in a list for easy reference
  final List<Widget> _screens = const [
    HomeScreen(),
    ScanScreen(),
    StoreScreen(),
  ];

  // Handle navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const CustomDrawer(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Econova',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,
      actions: [
        Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black,
      backgroundColor: Colors.blue,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Capture'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
      ],
    );
  }
}

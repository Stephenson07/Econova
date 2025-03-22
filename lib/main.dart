import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase.dart';
import 'state/state.dart'; // Import UserProvider
import 'screens/home_screen.dart';
import 'screens/store_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/signup_screen.dart'; // Import the SignUpScreen
import 'widgets/custom_drawer.dart';
import 'state/auth_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import '../.env';

void main() async {
  await dotenv.load(fileName: "../.env");
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initializeFirebase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        // ChangeNotifierProvider(create: (create) => UserProviderAuth()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exonova',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
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
      ),
      // Set SignUpScreen as the home screen (initial screen)
      home: const SignUpScreen(),
    );
  }
}

// Define the MainAppScreen that users will see after signup
class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [HomeScreen(), ScanScreen(), StoreScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  icon: Image.network(
                    'https://cdn4.iconfinder.com/data/icons/wirecons-free-vector-icons/32/menu-alt-1024.png',
                    height: 20,
                    width: 20,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}

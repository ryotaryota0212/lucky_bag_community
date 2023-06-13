import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'my_page.dart';
import 'fukubukuro.dart';
import 'musician.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = 
  // 'pk_test_51MxRfkFYbsbXmSwajv11CsRKGFmXGRvW8USm9Un3USWiy4quYbVo7yvyC7CDpJ0Mfwduehfk5dPsQtjJt6GNMLIm00Nf0uRL84';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = 'pk_test_51MxRfkFYbsbXmSwajv11CsRKGFmXGRvW8USm9Un3USWiy4quYbVo7yvyC7CDpJ0Mfwduehfk5dPsQtjJt6GNMLIm00Nf0uRL84';
  await Stripe.instance.applySettings();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lucky Bag Community',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

        if (snapshot.hasData) {
          return MyHomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    FukubukuroPage(),
    MusicianListPage(),
    MyProfilePage(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: '福袋',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'ミュージシャン',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'マイページ',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

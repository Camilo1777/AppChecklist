import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'login.dart';
import 'services/auth_service.dart';
import 'control_page.dart';
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Checklist App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashGate(),
        '/landing': (_) => const MyHomePage(),
        '/login': (_) => const LoginPage(),
        '/home': (ctx) => const ControlPage(),
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}

/// Splash screen that decides where to go based on token presence/validity
class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    final hasToken = await AuthService.instance.hasValidToken();
    if (!mounted) return;
    if (hasToken) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/landing');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. ENCABEZADO NARANJA
            Container(
              color: Colors.orange,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "CHECKLIST",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset("assets/logo.png", height: 100),
                ],
              ),
            ),

            // 2. BARRA DE BOTONES
            Container(
              color: Colors.orangeAccent,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text("MAESTRO"),
                  ),
                  
                ],
              ),
            ),

            // 3. SECCION PUBLICIDAD / REFERRIDOS
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    items: [
                      "assets/ref1.png",
                      "assets/ref2.png",
                      "assets/ref3.png",
                    ].map(
                      (item) => Container(
                        margin: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            item,
                            fit: BoxFit.cover,
                            width: 1000,
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Si eres estudiante o empleado activo, "
                    "obtén \$150.000 por cada referido que se matricule.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            // 4. TEXTO UNIVERSIDAD
            const SizedBox(height: 10),
            const Text(
              "Universidad San Buenaventura",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),

            // 5. IMÁGENES DEL CAMPUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/campus1.png"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/campus2.jpg"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

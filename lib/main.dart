import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
      home: const MyHomePage(),
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
                children: const [
                  Text(
                    "REGISTRO ASISTENCIA",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "ADMINISTRADOR",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                    items:
                        [
                              "assets/ref1.png",
                              "assets/ref2.png",
                              "assets/ref3.png",
                            ]
                            .map(
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
                            )
                            .toList(),
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

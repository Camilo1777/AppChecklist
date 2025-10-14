import 'package:flutter/material.dart';

class ControlPage extends StatelessWidget {
  final String usuario;

  const ControlPage({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    // Mostrar el valor que se pase en `usuario` (preparado desde el login)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Panel de Control"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bienvenido maestro: $usuario 👋",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              onPressed: () {
                // Acción para Asignatura 1
              },
              child: const Text("Asignatura 1"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              onPressed: () {
                // Acción para Asignatura 2
              },
              child: const Text("Asignatura 2"),
            ),
          ],
        ),
      ),
    );
  }
}

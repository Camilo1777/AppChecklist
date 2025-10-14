import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'control_page.dart';
import 'nuevo.dart';
import 'api_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  bool cargando = false;
  String error = '';

  @override
  void dispose() {
    usuarioController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    setState(() {
      cargando = true;
      error = '';
    });

    try {
      final response = await http
          .post(
            Uri.parse('${apiBaseUrl()}/checklist_api/auth/login.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': usuarioController.text,
              'password': contrasenaController.text,
            }),
          )
          .timeout(const Duration(seconds: 50));

      // Antes de tocar el estado, verificar que el widget siga montado
      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      if (response.statusCode == 200) {
        // Parsear respuesta JSON y usar el objeto `user` si viene del backend.
        try {
          final data = jsonDecode(response.body);
          if (data is Map && (data['success'] == false || data['error'] == true)) {
            setState(() => error = data['message'] ?? 'Usuario o contraseña incorrectos');
            return;
          }

          if (data is Map && data['user'] is Map) {
            final user = data['user'] as Map;
            final nombre = (user['nombre'] ?? '').toString().trim();
            final apellido = (user['apellido'] ?? '').toString().trim();
            final displayName = [nombre, apellido].where((s) => s.isNotEmpty).join(' ');

            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ControlPage(usuario: displayName)),
            );
            return;
          }
        } catch (_) {
          // Si la respuesta no es JSON o no contiene user, caemos al fallback.
        }

        // Fallback: derivar un nombre legible desde el email (parte antes de @)
        String deriveNameFromEmail(String email) {
          final at = email.indexOf('@');
          final local = at > 0 ? email.substring(0, at) : email;
          final parts = local.split(RegExp(r'[._\-]'));
          final capitalized = parts.map((p) {
            final s = p.trim();
            if (s.isEmpty) return '';
            return s[0].toUpperCase() + (s.length > 1 ? s.substring(1) : '');
          }).where((s) => s.isNotEmpty).join(' ');
          return capitalized.isNotEmpty ? capitalized : email;
        }

        final displayName = deriveNameFromEmail(usuarioController.text);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ControlPage(usuario: displayName)),
        );
      } else {
        setState(() {
          error = 'Usuario o contraseña incorrectos';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        cargando = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text('Login Profesor'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: usuarioController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contrasenaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              if (error.isNotEmpty)
                Text(error, style: const TextStyle(color: Colors.red)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: cargando ? null : login,
                  child: cargando
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                      : const Text(
                          'Ingresar',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NuevoProfesorPage()),
                    );
                  },
                  child: const Text(
                    'Crear nuevo maestro',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helpers (apiBaseUrl) are defined in lib/api_config.dart


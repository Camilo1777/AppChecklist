// filepath: [nuevo.dart](http://_vscodecontentref_/1)
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/auth_service.dart';

class NuevoProfesorPage extends StatefulWidget {
  const NuevoProfesorPage({super.key});

  @override
  State<NuevoProfesorPage> createState() => _NuevoProfesorPageState();
}

class _NuevoProfesorPageState extends State<NuevoProfesorPage> {
  final idController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();
  bool cargando = false;
  String mensaje = '';

  Future<void> crearProfesor() async {
    setState(() {
      cargando = true;
      mensaje = '';
    });

    try {
      final response = await http
          .post(
            Uri.parse('${AuthService.baseUrl}/auth/register.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'idprofesor': idController.text.trim(),
              'nombre': nombreController.text.trim(),
              'apellido': apellidoController.text.trim(),
              'email': correoController.text.trim(),
              'password': contrasenaController.text,
            }),
          )
          .timeout(const Duration(seconds: 50));

      setState(() {
        cargando = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Intentar leer mensaje del backend
        String serverMsg = 'Profesor creado exitosamente';
        try {
          final data = jsonDecode(response.body);
          if (data is Map && data['message'] is String) {
            serverMsg = data['message'];
          }
        } catch (_) {}
        setState(() { mensaje = serverMsg; });
      } else {
        String serverMsg = 'Error al crear profesor (${response.statusCode})';
        try {
          final data = jsonDecode(response.body);
          if (data is Map && data['message'] is String) {
            serverMsg = data['message'];
          }
        } catch (_) {}
        setState(() { mensaje = serverMsg; });
      }
    } catch (e) {
      setState(() {
        cargando = false;
        mensaje = 'Error de conexión o tiempo de espera agotado';
      });
    }
  }

  bool esEmailValido(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool esIdValido(String id) {
    // Aceptar cualquier ID no vacío (puede ser alfanumérico). Ajusta si el backend exige otro formato.
    return id.trim().isNotEmpty;
  }

  @override
  void dispose() {
    idController.dispose();
    nombreController.dispose();
    apellidoController.dispose();
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Nuevo Profesor'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Crear nuevo maestro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ID (requerido)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contrasenaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
              const SizedBox(height: 24),
              if (mensaje.isNotEmpty)
                Text(mensaje, style: TextStyle(color: mensaje.contains('exitosamente') ? Colors.green : Colors.red)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: cargando
                      ? null
                      : () {
                          if (!esIdValido(idController.text)) {
                            setState(() { mensaje = 'Por favor ingresa un ID'; });
                            return;
                          }
                          if (!esEmailValido(correoController.text)) {
                            setState(() {
                              mensaje = 'Por favor ingresa un correo válido';
                            });
                            return;
                          }
                          crearProfesor();
                        },
                  child: cargando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Registrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
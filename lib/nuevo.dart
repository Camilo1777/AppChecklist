// filepath: [nuevo.dart](http://_vscodecontentref_/1)
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';

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

  @override
  void dispose() {
    idController.dispose();
    nombreController.dispose();
    apellidoController.dispose();
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  Future<void> crearProfesor() async {
    setState(() {
      cargando = true;
      mensaje = '';
    });

    try {
      final response = await http
          .post(
            Uri.parse('${apiBaseUrl()}/checklist_api/auth/register.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'idprofesor': idController.text,
              'nombre': nombreController.text,
              'apellido': apellidoController.text,
              'email': correoController.text,
              'password': contrasenaController.text,
            }),
          )
          .timeout(const Duration(seconds: 50));

      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      // Intentar leer mensaje del backend si devuelve JSON
      String backendMessage = '';
      try {
        final data = jsonDecode(response.body);
        if (data is Map && data['message'] != null) {
          backendMessage = data['message'].toString();
        }
      } catch (_) {
        // Ignorar parseo si la respuesta no es JSON
      }

      if (response.statusCode == 201) {
        setState(() {
          mensaje = backendMessage.isNotEmpty ? backendMessage : 'Profesor creado exitosamente';
        });
      } else {
        setState(() {
          mensaje = backendMessage.isNotEmpty ? backendMessage : 'Error al crear profesor';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        cargando = false;
        mensaje = e.toString();
      });
    }
  }

  bool esEmailValido(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool validarCampos() {
    if (idController.text.trim().isEmpty) {
      setState(() => mensaje = 'Por favor ingresa el ID');
      return false;
    }
    if (nombreController.text.trim().isEmpty) {
      setState(() => mensaje = 'Por favor ingresa el nombre');
      return false;
    }
    if (!esEmailValido(correoController.text)) {
      setState(() => mensaje = 'Por favor ingresa un correo válido');
      return false;
    }
    if (contrasenaController.text.length < 6) {
      setState(() => mensaje = 'La contraseña debe tener al menos 6 caracteres');
      return false;
    }
    return true;
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
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'ID'),
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
                keyboardType: TextInputType.emailAddress,
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
                          if (!validarCampos()) return;
                          crearProfesor();
                        },
                  child: cargando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
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
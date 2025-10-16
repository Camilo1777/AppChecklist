import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class ControlPage extends StatefulWidget {
  final String? usuario;

  const ControlPage({super.key, this.usuario});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  String? _displayName;
  String? _status;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Prefer stored display name; evita depender del endpoint protegido.
    String? name = widget.usuario;
    name ??= await AuthService.instance.getDisplayName();
    final hasToken = await AuthService.instance.hasValidToken();
    _status = hasToken ? 'Sesión activa' : 'Sin sesión';
    setState(() {
      _displayName = name ?? _displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              "Bienvenido${_displayName != null ? ', ${_displayName!}' : ''} 👋",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            if (_status != null)
              Text(
                _status!,
                style: const TextStyle(color: Colors.green),
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
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pushNamed('/profile'),
              child: const Text('Perfil / Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

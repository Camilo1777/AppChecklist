# 📱 Checklist

Un nuevo proyecto Flutter.

## 📝 Descripción

Este proyecto es un ejemplo visual de cómo quedará la aplicación final de Checklist. Su objetivo es servir como prototipo interactivo para mostrar la estructura, el diseño y la navegación de una app de checklist, permitiendo visualizar pantallas, flujos y funcionalidades principales antes de la implementación definitiva.

Incluye:
- 🖼️ Vistas de ejemplo de las pantallas principales.
- ✅ Ejemplo de creación, edición y marcado de tareas en una lista.
- 🎨 Diseño visual preliminar para revisión y validación.

## 🚀 Primeros pasos

Este proyecto es un punto de partida para una aplicación Flutter.

### 📚 Recursos útiles

- [📝 Lab: Escribe tu primera app Flutter](https://docs.flutter.dev/get-started/codelab)
- [🍳 Cookbook: Ejemplos útiles de Flutter](https://docs.flutter.dev/cookbook)

### 🛠️ Instalación rápida

1. **Clona el repositorio:**
   ```sh
   git clone <https://github.com/Camilo1777/AppChecklist.git>
   cd AppChecklist
   ```

2. **Instala las dependencias:**
   ```sh
   flutter pub get
   ```

3. **Ejecuta la aplicación:**
   ```sh
   flutter run
   ```

### 📄 Documentación

Para más ayuda sobre Flutter, consulta la [documentación en línea](https://docs.flutter.dev/), que ofrece tutoriales, ejemplos, guías de desarrollo móvil y una referencia completa de la API.

---

> Proyecto generado con [Flutter](https://flutter.dev/)

## 🔐 Autenticación JWT (mínimo)

Este proyecto implementa el flujo básico de autenticación:

- Pantalla pública de Login (`/login`).
- Home protegida (`/home`). Muestra estado de sesión activa cuando el token es válido.
- Perfil/Session (`/profile`) con botón Logout que borra el token seguro.
- Al abrir la app, un Splash (`/`) verifica si hay token válido y redirige a Home o a la pantalla de inicio.

### Configuración de BASE_URL

El servicio apunta por defecto a `https://checklistapi-production.up.railway.app` en `lib/services/auth_service.dart` (const `baseUrl`). Ajusta esa URL si tu backend cambia.

### Cómo probar login

1. Abre la app. Si no hay token, verás la pantalla de inicio. Pulsa “MAESTRO” para ir al Login.
2. Ingresa email y contraseña; al ingresar, se guarda el token en `flutter_secure_storage`.
3. Serás redirigido a Home. En Perfil puedes cerrar sesión.

### Endpoint protegido de ejemplo (opcional)

Se valida el token con `GET /auth/me.php`. Si devuelve 200, se muestra “Sesión activa”.

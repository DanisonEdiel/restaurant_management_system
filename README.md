# Restaurant Management System

Un sistema de gestión de restaurantes multiplataforma desarrollado con Flutter. Esta aplicación funciona en dispositivos móviles (iOS y Android), web y escritorio (Windows, macOS, Linux).

## Características

El sistema está organizado en 9 dominios principales:

1. **Autenticación**: Inicio de sesión, registro y gestión de usuarios
2. **Órdenes**: Gestión de pedidos y comandas
3. **Facturación**: Emisión de facturas y gestión de pagos
4. **Inventario**: Control de stock e ingredientes
5. **Gestión de Mesas**: Asignación y estado de mesas
6. **Proveedores y Compras**: Gestión de proveedores y pedidos
7. **Reportes**: Estadísticas e informes
8. **Notificaciones**: Sistema de alertas y notificaciones
9. **Utilidades**: Herramientas adicionales y configuración

## Estructura del Proyecto

El proyecto sigue una arquitectura limpia (Clean Architecture) con las siguientes capas:

- **Presentación**: UI, widgets, páginas y providers
- **Dominio**: Entidades, casos de uso e interfaces de repositorios
- **Datos**: Implementaciones de repositorios, fuentes de datos y modelos

```
lib/
├── core/                      # Componentes centrales
│   ├── di/                    # Inyección de dependencias
│   ├── navigation/            # Enrutamiento
│   └── theme/                 # Tema de la aplicación
├── features/                  # Características organizadas por dominio
│   ├── auth/                  # Autenticación
│   ├── orders/                # Órdenes
│   ├── billing/               # Facturación
│   ├── inventory/             # Inventario
│   ├── table_management/      # Gestión de mesas
│   ├── providers/             # Proveedores y compras
│   ├── reporting/             # Reportes
│   ├── notifications/         # Notificaciones
│   └── utilities/             # Utilidades
└── main.dart                  # Punto de entrada
```

## Requisitos

- Flutter SDK 3.0.0 o superior
- Dart SDK 3.0.0 o superior
- Dispositivo o emulador para pruebas

## Instalación

1. Instala Flutter siguiendo las [instrucciones oficiales](https://flutter.dev/docs/get-started/install)
2. Clona este repositorio
3. Ejecuta `flutter pub get` para instalar las dependencias
4. Ejecuta `flutter run` para iniciar la aplicación

## Credenciales de Prueba

Para probar la aplicación, puedes usar las siguientes credenciales:

- **Administrador**:
  - Email: admin@example.com
  - Contraseña: password123

- **Personal**:
  - Email: staff@example.com
  - Contraseña: password123

## Próximas Funcionalidades

- Implementación completa de todos los dominios
- Sincronización offline
- Impresión de tickets
- Integración con sistemas de pago
- Análisis avanzado de datos

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo LICENSE para más detalles.

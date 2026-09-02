# Changelog

Todos los cambios importantes de ARTEZA V se documentan aquí.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [1.0.0] - 2026-09-02

### Agregado
- ✨ Aplicación inicial de administración de consorcios
- 🔐 Integración con Supabase para autenticación y base de datos
- 🎨 UI responsive con Tailwind CSS
- 📊 Módulos principales:
  - Comunicados con categorización y prioridades
  - Gestión de expensas y liquidaciones
  - Reclamos y seguimiento
  - Galería de imágenes
  - Certificados de libre deuda
  - Gestión de perfiles y roles
- 📱 Modo oscuro/claro
- 🔒 Row Level Security (RLS) en todas las tablas
- 📄 Visor de PDFs integrado
- 💾 Almacenamiento seguro de archivos

### Seguridad
- 🔐 Autenticación con Supabase Auth
- 🛡️ Políticas RLS por rol (Administrador, Propietario, Inquilino)
- 🔑 Solo anon key expuesta en frontend
- ✅ Validación en cliente y servidor

### Configuración
- 📦 Cloudflare Pages ready
- 🌐 GitHub workflow templates
- 📝 Documentación completa
- 🚀 Deploy automático preparado

---

## Notas

- La versión inicial está lista para personalización
- Supabase debe configurarse manualmente
- Ver `README.md` para instrucciones de setup

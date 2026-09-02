# Guía de Contribución - ARTEZA V

## Bienvenido/a 👋

¡Gracias por tu interés en contribuir a ARTEZA V! Este documento te guiará en el proceso.

## Flujo de Trabajo

### 1. Ramas
- **`main`** - Producción (rama protegida)
- **`supabase-setup`** - Setup y configuración
- **Feature branches** - Para nuevas características: `feature/nombre-caracteristica`
- **Bugfix branches** - Para correcciones: `bugfix/nombre-del-error`

### 2. Crear una Feature/Bugfix

```bash
git checkout main
git pull origin main
git checkout -b feature/tu-caracteristica
```

### 3. Commits

Usa mensajes descriptivos:
- `feat: agregar funcionalidad X`
- `fix: corregir error Y`
- `docs: actualizar documentación`
- `refactor: mejorar código`
- `test: agregar pruebas`

### 4. Pull Request

1. Haz push a tu rama
2. Abre un PR contra `main`
3. Describe los cambios claramente
4. Espera revisión

## Estándares de Código

### HTML/JavaScript
- Usa 2 espacios para indentación
- Comenta código complejo
- Usa nombres de variables descriptivos
- Sigue el estilo existente

### Seguridad
- ⚠️ **NUNCA** coloques `SUPABASE_SERVICE_ROLE_KEY` en el código
- Solo usa `SUPABASE_ANON_KEY` en el frontend
- Valida datos en backend (RLS)

## Reportar Issues

Incluye:
- Descripción clara del problema
- Pasos para reproducir
- Comportamiento esperado
- Navegador/OS

## Preguntas?

Revisa el README.md o abre una discussion.

¡Gracias por contribuir! 🎉
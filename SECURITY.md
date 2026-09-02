# Política de Seguridad

## Reportar Vulnerabilidades de Seguridad

**Por favor NO abras un issue público** para reportar vulnerabilidades de seguridad.

Envía un correo a: [Tu email de contacto]

Por favor incluye:
- Descripción de la vulnerabilidad
- Pasos para reproducir
- Posible impacto
- Posibles soluciones

## Información de Seguridad Importante

### Supabase + Frontend

⚠️ **CRÍTICO**: Este proyecto utiliza Supabase con anon key en el navegador.

#### ✅ Seguridad correctamente implementada:
- ✓ RLS (Row Level Security) habilitado en todas las tablas
- ✓ Solo `SUPABASE_ANON_KEY` en el frontend
- ✓ `SERVICE_ROLE_KEY` solo en backend seguro
- ✓ Validación de datos en ambos lados

#### ❌ NUNCA hagas esto:
- ✗ Coloques `SERVICE_ROLE_KEY` en el código frontend
- ✗ Almacenes credenciales en archivos públicos
- ✗ Confíes solo en validación del cliente
- ✗ Expongas secrets en GitHub

### Variables de Entorno

Crea un archivo `.env.local` (nunca lo commits):

```
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIs...
```

### Authentication

- Las contraseñas se hashean con Supabase Auth
- MFA está disponible en Supabase
- RLS protege los datos a nivel de base de datos

## Versionado de Seguridad

Mantenemos las últimas 2 versiones menores con parches de seguridad.

## Dependencias

Revisa regularmente:
```bash
npm audit
```

## Agradecimientos

Agradecemos a quienes reportan responsablemente vulnerabilidades.
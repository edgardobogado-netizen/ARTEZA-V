# 🚀 Guía de Setup - ARTEZA V

## Prerequisitos

- Cuenta en [Supabase](https://supabase.com) (gratis)
- Cuenta en [Cloudflare](https://cloudflare.com) (gratis)
- Git instalado
- Navegador moderno (Chrome, Firefox, Safari, Edge)

## Paso 1: Crear Proyecto en Supabase

1. Ve a [supabase.com](https://supabase.com)
2. Haz clic en "New Project"
3. Completa los datos:
   - **Project Name**: `ARTEZA-V` (o tu nombre)
   - **Database Password**: Crea una contraseña segura
   - **Region**: Selecciona la más cercana (ej: São Paulo)
4. Haz clic en "Create new project"
5. Espera a que se cree (2-3 minutos)

## Paso 2: Configurar Base de Datos

1. En el dashboard de Supabase, ve a **SQL Editor**
2. Haz clic en **New Query**
3. Copia todo el contenido de `schema.sql`
4. Pega en el editor
5. Haz clic en **Run** ✓
6. Verifica que se crearon las tablas

## Paso 3: Crear Storage Bucket

1. Ve a **Storage** en el menu izquierdo
2. Haz clic en **New Bucket**
3. Nombre: `arteza`
4. Privacidad: **Private**
5. Haz clic en **Create Bucket**

## Paso 4: Configurar supabase-config.js

1. Ve a **Settings** > **API**
2. Copia:
   - `Project URL` → `SUPABASE_URL`
   - `anon public` → `SUPABASE_ANON_KEY`
3. Abre `supabase-config.js`
4. Reemplaza los valores:

```javascript
window.SUPABASE_URL = 'https://xxxxx.supabase.co';
window.SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

## Paso 5: Crear Usuario Administrador

1. Ve a **Authentication** > **Users**
2. Haz clic en **Invite user**
3. Email: tu correo
4. Haz clic en **Send invite**
5. Revisa tu email y completa el registro
6. En **SQL Editor**, ejecuta:

```sql
UPDATE public.profiles
SET role = 'Administrador', approved = true
WHERE email = 'tu-correo@ejemplo.com';
```

## Paso 6: Desplegar en Cloudflare Pages

### Opción A: Via GitHub (Recomendado)

1. Haz fork o copia del repositorio
2. Ve a [Cloudflare Dashboard](https://dash.cloudflare.com)
3. Selecciona tu cuenta
4. Ve a **Pages** > **Create a project**
5. Selecciona **Connect to Git**
6. Autoriza GitHub y selecciona el repo
7. Configuración:
   - **Framework preset**: None
   - **Build command**: (dejar vacío)
   - **Build output directory**: (dejar vacío)
8. Haz clic en **Save and Deploy**
9. ¡Listo! Tu sitio está en línea 🎉

### Opción B: Manual

1. Descarga los archivos
2. Ve a Cloudflare Pages
3. Haz clic en **Upload assets**
4. Sube `index.html` y `supabase-config.js`
5. ¡Listo!

## Paso 7: Probar la Aplicación

1. Abre tu URL de Cloudflare Pages
2. Haz clic en "Registrarse"
3. Usa el correo del admin que creaste
4. Ingresa contraseña
5. ¡Bienvenido! 👋

## Troubleshooting

### "Supabase no configurado"
- Verifica que `supabase-config.js` tenga los valores correctos
- Asegúrate que la URL y key no contengan "TU-PROYECTO"

### Error al subir archivos
- Verifica que el bucket `arteza` exista
- Comprueba que sea privado

### Error de autenticación
- Verifica que el usuario esté en la tabla `profiles`
- Comprueba que tenga `role = 'Administrador'` y `approved = true`

## Próximos Pasos

- [ ] Personalizar colores en `index.html`
- [ ] Agregar logo del consorcio
- [ ] Configurar dominio personalizado
- [ ] Habilitar 2FA en Supabase
- [ ] Configurar backups automáticos

## Ayuda

- Docs de Supabase: https://supabase.com/docs
- Docs de Cloudflare Pages: https://developers.cloudflare.com/pages/
- Issues: Abre un issue en GitHub

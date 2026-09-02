# 🎨 Guía de Personalización - ARTEZA V

## Cambiar Colores

Los colores están definidos en `index.html` línea 16:

```javascript
colors: {
  brand: {
    50: '#eef2ff',    // Más claro
    100: '#e0e7ff',
    500: '#6366f1',   // Principal
    600: '#4f46e5',
    700: '#4338ca',
    900: '#312e81'    // Más oscuro
  }
}
```

### Paletas Sugeridas

#### Azul Profesional
```javascript
50: '#eff6ff',
100: '#dbeafe',
500: '#0284c7',
600: '#0369a1',
700: '#075985',
900: '#082f49'
```

#### Verde Moderno
```javascript
50: '#f0fdf4',
100: '#dcfce7',
500: '#16a34a',
600: '#15803d',
700: '#166534',
900: '#15803d'
```

#### Rojo Corporativo
```javascript
50: '#fef2f2',
100: '#fee2e2',
500: '#dc2626',
600: '#b91c1c',
700: '#991b1b',
900: '#7f1d1d'
```

## Cambiar Logo/Icono

### Opción 1: Cambiar Icono Font Awesome

Línea 557 en `index.html`:

```html
<!-- Actual -->
<i class="fa-solid fa-building-user"></i>

<!-- Alternativas -->
<i class="fa-solid fa-building"></i>
<i class="fa-solid fa-house-building"></i>
<i class="fa-solid fa-home"></i>
```

Más iconos: https://fontawesome.com/icons

### Opción 2: Usar Logo Personalizado

Reemplaza el div del icono:

```html
<div class="w-16 h-16 rounded-2xl flex items-center justify-center mx-auto mb-4">
  <img src="tu-logo.png" class="w-full h-full object-cover rounded-2xl" />
</div>
```

## Cambiar Nombre/Título

Línea 559:

```html
<!-- Actual -->
<h2 class="font-bold text-2xl text-white">Consorcio<span class="text-indigo-400">Admin</span></h2>

<!-- Nuevo -->
<h2 class="font-bold text-2xl text-white">Mi<span class="text-indigo-400">Consorcio</span></h2>
```

## Cambiar Tipografía

Actual: Inter (línea 28)

```javascript
fontFamily: { sans: ['Inter','sans-serif'] }
```

### Alternativas Google Fonts

```javascript
// Poppins (moderno)
fontFamily: { sans: ['Poppins','sans-serif'] }

// Roboto (profesional)
fontFamily: { sans: ['Roboto','sans-serif'] }

// Montserrat (moderno y limpio)
fontFamily: { sans: ['Montserrat','sans-serif'] }
```

Recuerda agregar el link en `<head>`:

```html
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
```

## Personalizar Roles

En `schema.sql`, modifica los valores permitidos:

```sql
ALTER TABLE profiles
ADD CONSTRAINT roles_check CHECK (role IN ('Administrador', 'Propietario', 'Inquilino', 'Gerente'));
```

## Agregar Campos a Perfil

En `schema.sql`, agrega columnas:

```sql
ALTER TABLE profiles ADD COLUMN phone TEXT;
ALTER TABLE profiles ADD COLUMN address TEXT;
ALTER TABLE profiles ADD COLUMN document_id TEXT;
```

Luego actualiza el formulario en `index.html`.

## Cambiar Temas Dark Mode

Línea 58 en `index.html`:

```html
<!-- Actual -->
<body class="h-full text-slate-800 dark:text-slate-100 dark:bg-slate-900 ...">

<!-- Alternativa (Gris más cálido) -->
<body class="h-full text-gray-800 dark:text-gray-100 dark:bg-gray-900 ...">
```

## Personalizar Menú

Los tabs se definen en el componente App:

```javascript
const [currentTab, setCurrentTab] = useState('comunicados');

// Los tabs disponibles son:
// 'comunicados'
// 'residentes' (profiles)
// 'expensas'
// 'reclamos'
// 'galeria'
// 'pdfs'
// 'libre_deuda'
```

Agrega nuevos tabs modificando la lógica de renderizado.

## Agregar Modales Personalizados

Copia esta estructura:

```javascript
const [isCustomModalOpen, setIsCustomModalOpen] = useState(false);

return (
  // ...
  {isCustomModalOpen && (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
      <div className="bg-white dark:bg-slate-800 rounded-xl p-6 max-w-md w-full">
        {/* Tu contenido aquí */}
        <button onClick={() => setIsCustomModalOpen(false)}>Cerrar</button>
      </div>
    </div>
  )}
);
```

## Cambios en CSS

Tailwind CSS está incluido via CDN (línea 9).

Para clases personalizadas, agrégalas en la sección `<style>`:

```html
<style>
  .custom-class {
    @apply bg-blue-500 text-white rounded-lg p-4;
  }
</style>
```

## Cambiar Textos y Mensajes

Búsqueda global en `index.html`:
- "ConsorcioAdmin" → Tu nombre
- "Comunicados" → Tu término
- Mensajes de toast (showToast)

## Agregar Notificaciones por Email

Crea una función Edge en Supabase:

```javascript
// supabase/functions/send-notification/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

serve(async (req) => {
  const { email, message } = await req.json();
  // Usa tu proveedor de email aquí
  return new Response(JSON.stringify({ ok: true }));
});
```

## Desplegar Cambios

1. Modifica los archivos localmente
2. Haz commit: `git add . && git commit -m "Personalización"`
3. Push: `git push origin main`
4. Cloudflare Pages se actualiza automáticamente ✓

## Ayuda

- Tailwind Docs: https://tailwindcss.com/docs
- Font Awesome: https://fontawesome.com
- Colores: https://tailwindcss.com/docs/customizing-colors

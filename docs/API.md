# 📚 Documentación de API - ARTEZA V

## Tablas Principales

### `profiles`
Guarda información de usuarios registrados.

```sql
- id (UUID): ID del usuario (from auth.users)
- email (TEXT): Email del usuario
- name (TEXT): Nombre completo
- role (TEXT): 'Administrador' | 'Propietario' | 'Inquilino'
- unit (TEXT): Número de unidad
- avatar (TEXT): Path a avatar en storage
- approved (BOOLEAN): ¿Usuario aprobado?
- created_at (TIMESTAMP): Fecha de creación
```

### `comunicados`
Noticias y comunicaciones del consorcio.

```sql
- id (BIGINT): ID único
- title (TEXT): Título del comunicado
- content (TEXT): Contenido
- author (TEXT): Nombre del autor
- category (TEXT): Categoría
- priority (TEXT): 'Normal' | 'Urgente' | 'Crítico'
- status (TEXT): 'Borrador' | 'Publicado' | 'Archivado'
- pinned (BOOLEAN): ¿Fijado?
- has_attachment (BOOLEAN): ¿Tiene archivo?
- attachment_name (TEXT): Nombre del archivo
- attachment_path (TEXT): Path en storage
- date (TIMESTAMP): Fecha de publicación
```

### `expensas`
Expenses mensuales del consorcio.

```sql
- id (BIGINT): ID único
- period (TEXT): Ej: 'Agosto 2026'
- total (DECIMAL): Monto total
- description (TEXT): Descripción
- created_at (TIMESTAMP): Fecha
```

### `unit_expensas`
Expensas por unidad individual.

```sql
- id (BIGINT): ID único
- unit (TEXT): Número de unidad
- period (TEXT): Período
- amount (DECIMAL): Monto a pagar
- paid (BOOLEAN): ¿Pagado?
- due_date (DATE): Fecha de vencimiento
- created_at (TIMESTAMP): Fecha
```

### `reclamos`
Reclamos y quejas de residentes.

```sql
- id (BIGINT): ID único
- title (TEXT): Título del reclamo
- description (TEXT): Descripción
- reporter_id (UUID): ID de quien reporta
- status (TEXT): 'Abierto' | 'En proceso' | 'Resuelto'
- priority (TEXT): Prioridad
- date (TIMESTAMP): Fecha de reporte
```

### `galeria`
Galería de imágenes del consorcio.

```sql
- id (BIGINT): ID único
- title (TEXT): Título
- description (TEXT): Descripción
- url (TEXT): Path en storage
- category (TEXT): Categoría
- date (DATE): Fecha
- uploaded_by (UUID): ID de quien subió
```

### `expense_pdfs`
PDFs de liquidaciones de expensas.

```sql
- id (BIGINT): ID único
- period (TEXT): Período (Ej: 'Agosto 2026')
- file_name (TEXT): Nombre del archivo
- storage_path (TEXT): Path en storage Supabase
- uploaded_by (UUID): ID del admin que subió
- upload_date (TIMESTAMP): Fecha de upload
```

### `libre_deuda`
Certificados de libre deuda.

```sql
- id (BIGINT): ID único
- unit (TEXT): Número de unidad
- owner_name (TEXT): Nombre del propietario
- issue_date (DATE): Fecha de emisión
- expiry_date (DATE): Fecha de vencimiento
- generated_by (UUID): ID del admin
```

## Row Level Security (RLS)

Todas las tablas tienen políticas RLS que permiten:

### Administrador
- Ver todos los datos
- Crear, editar, eliminar cualquier cosa

### Propietario
- Ver comunicados públicos
- Ver expensas de su unidad
- Ver reclamos propios
- Ver galería

### Inquilino
- Ver comunicados públicos
- Ver expensas de su unidad
- Ver galería

## JavaScript API (Frontend)

### Crear Comunicado

```javascript
const payload = {
  title: 'Mantenimiento de fachada',
  category: 'Mantenimiento',
  priority: 'Normal',
  content: 'Se realizará...',
  author: 'Admin',
  attachment_path: 'comunicados/...',
  status: 'Publicado'
};

const { data, error } = await supabase
  .from('comunicados')
  .insert([payload])
  .select();
```

### Subir Archivo a Storage

```javascript
const file = document.getElementById('fileInput').files[0];
const path = `comunicados/${Date.now()}_${file.name}`;

const { data, error } = await supabase
  .storage
  .from('arteza')
  .upload(path, file, { upsert: true });
```

### Obtener URL Firmada

```javascript
const { data, error } = await supabase
  .storage
  .from('arteza')
  .createSignedUrl(storagePath, 60); // expira en 60 segundos
```

### Actualizar Perfil

```javascript
const { error } = await supabase
  .from('profiles')
  .update({ name: 'Nuevo Nombre' })
  .eq('id', userId);
```

## Variables de Entorno

```javascript
// supabase-config.js
window.SUPABASE_URL = 'https://xxxxx.supabase.co';
window.SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIs...';
```

⚠️ **NUNCA** uses `SERVICE_ROLE_KEY` en el frontend.

## Límites

- Máx. tamaño de archivo: 50MB (Supabase plan gratuito)
- Máx. resultados por query: 1000 (sin paginación)
- URLs firmadas: expiran según parámetro (máx 1 año)

## Error Handling

```javascript
const { data, error } = await supabase
  .from('table')
  .select();

if (error) {
  console.error('Error:', error.message);
  // Mostrar al usuario
}
```

## Más Información

- Supabase Docs: https://supabase.com/docs
- Supabase JS Client: https://supabase.com/docs/reference/javascript

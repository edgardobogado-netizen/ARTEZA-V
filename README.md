# ARTEZA V - versión preparada para Supabase + Cloudflare Pages

Este paquete parte de `consorcioadmin_arteza_v (8).html`, conservando su interfaz actual.

## Qué contiene
- `index.html`: aplicación original, lista para integrar la capa de datos.
- `supabase-config.js`: URL y anon key del proyecto.
- `schema.sql`: esquema PostgreSQL, autenticación de perfiles y RLS.

## Importante
La página original guarda actualmente la información en el estado de React. Este paquete incluye la estructura de base de datos y seguridad para la migración, pero **no se debe publicar como sistema productivo hasta conectar los handlers de cada módulo a Supabase**.

## Próximo paso
1. Crear un proyecto en Supabase.
2. Ejecutar `schema.sql` en SQL Editor.
3. Crear el bucket privado `arteza` en Storage.
4. Copiar URL y anon key a `supabase-config.js`.
5. Conectar los formularios de residentes, comunicados, expensas, reclamos, galería, PDFs y libre deuda a sus tablas.
6. Crear el usuario administrador en Supabase Auth y asignarle `Administrador` + `Aprobado` en `profiles`.
7. Publicar `index.html` en Cloudflare Pages.

Nunca colocar la `service_role key` en el navegador. Solo debe usarse la anon/public key.

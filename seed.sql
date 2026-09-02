-- seed.sql
-- Inserciones de ejemplo.
-- PASO RECOMENDADO: crear el usuario admin en Supabase Auth y usar su UUID en <ADMIN_UUID>.
-- Luego ejecutar el INSERT reemplazando <ADMIN_UUID>.

-- Reemplazar por el UUID real del usuario creado en Auth
insert into public.profiles (id, name, email, role, unit, phone, avatar, status)
values ('<ADMIN_UUID>'::uuid, 'Edgardo Luis Bogado', 'edgardogn@live.com.ar', 'Administrador', 'Adm General', '+5493487649549', '', 'Aprobado');

-- Residentes de ejemplo
insert into public.profiles (id, name, email, role, unit, phone, avatar, status)
values (gen_random_uuid(), 'Martín Suarez', 'msuarez@email.com', 'Propietario', 'PB A', '+54 9 11 1234-5678', '', 'Aprobado');

-- Comunicado de ejemplo
insert into public.comunicados (title, category, priority, content, author, pinned, has_attachment, attachment_name, attachment_path, status)
values ('Convocatoria a Asamblea General Ordinaria', 'Asamblea', 'Alta', 'Se convoca a todos los copropietarios a la Asamblea General Ordinaria. Orden del día: ...', 'Adm. Edgardo Bogado', true, false, null, null, 'Publicado');

-- Cobro por unidad ejemplo
insert into public.unit_expensas (unit, owner, period, ordinary_amount, extraordinary_amount, reserve_fund_amount, total_amount, status, due_date)
values ('PB A', 'Martín Suarez', 'Agosto 2026', 48000, 12000, 5000, 65000, 'Pagada', '2026-08-15');

-- Gasto general ejemplo
insert into public.expensas (concept, category, amount, period, status)
values ('Mantenimiento Ascensores OTIS', 'Servicios Generales', 185000, 'Agosto 2026', 'Liquidado');

-- Ticket ejemplo
insert into public.reclamos (title, unit, creator_id, priority, status, description)
values ('Filtración menor en marquesina', 'Hall Principal', (select id from public.profiles where unit = 'PB A' limit 1), 'Alta', 'En Proceso', 'Goteo cerca del interfonos principal.');

-- Galería ejemplo
insert into public.galeria (title, category, url, description, date)
values ('Fachada Principal y Acceso', 'Edificio', 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800&auto=format&fit=crop&q=80', 'Vista frontal del edificio ARTEZA V.', '12/08/2026');

-- Expense PDF ejemplo (si subes al bucket guarda storage_path)
insert into public.expense_pdfs (period, file_name, storage_path)
values ('Agosto 2026', 'Liquidacion_Expensas_Agosto.pdf', 'liquidaciones/2026-08/Liquidacion_Expensas_Agosto.pdf');

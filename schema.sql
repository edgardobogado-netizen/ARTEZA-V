-- schema.sql
-- Esquema recomendado para ARTEZA V (Supabase PostgreSQL)
create extension if not exists "pgcrypto";

-- profiles: datos extra del usuario, vinculado a auth.users(id)
create table if not exists public.profiles (
  id uuid primary key,                       -- debe coincidir con auth.users.id
  name text,
  email text,
  role text default 'Propietario',           -- 'Administrador' o 'Propietario' / 'Inquilino'
  unit text,                                 -- ejemplo: "PB A"
  phone text,
  avatar text,
  status text default 'Pendiente',           -- 'Pendiente' / 'Aprobado' / 'Bloqueado'
  created_at timestamptz default now()
);

-- comunicados (avisos)
create table if not exists public.comunicados (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  category text,
  priority text,
  content text,
  author text,
  pinned boolean default false,
  date timestamptz default now(),
  read_percentage int default 0,
  has_attachment boolean default false,
  attachment_name text,
  attachment_path text,
  status text default 'Publicado'
);

-- unit_expensas (cobros por unidad)
create table if not exists public.unit_expensas (
  id uuid default gen_random_uuid() primary key,
  unit text not null,
  owner text,
  period text,
  concept text,
  ordinary_amount numeric default 0,
  extraordinary_amount numeric default 0,
  reserve_fund_amount numeric default 0,
  fine_amount numeric default 0,
  interest_amount numeric default 0,
  total_amount numeric default 0,
  due_date date,
  status text default 'Pendiente',            -- Pagada, Pendiente, Adeuda
  payment_date date,
  created_at timestamptz default now()
);

-- expensas generales (gastos)
create table if not exists public.expensas (
  id uuid default gen_random_uuid() primary key,
  concept text,
  category text,
  amount numeric default 0,
  period text,
  status text,
  created_at timestamptz default now()
);

-- reclamos / tickets
create table if not exists public.reclamos (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  unit text,
  creator_id uuid references public.profiles(id) on delete set null,
  priority text,
  status text default 'Pendiente',
  description text,
  date timestamptz default now()
);

-- galeria de fotos
create table if not exists public.galeria (
  id uuid default gen_random_uuid() primary key,
  title text,
  category text,
  url text,
  description text,
  date text,
  uploaded_by uuid references public.profiles(id)
);

-- expense_pdfs (liquidaciones oficiales)
create table if not exists public.expense_pdfs (
  id uuid default gen_random_uuid() primary key,
  period text,
  file_name text,
  storage_path text,
  uploaded_by uuid references public.profiles(id),
  upload_date timestamptz default now()
);

-- libre_deuda (certificados)
create table if not exists public.libre_deuda (
  id uuid default gen_random_uuid() primary key,
  unit text,
  owner text,
  dni text,
  issue_date date,
  period_until text,
  balance numeric default 0,
  purpose text,
  body_text text,
  admin_name text,
  status text default 'Vigente',
  created_at timestamptz default now()
);

-- índices útiles
create index if not exists idx_profiles_unit on public.profiles(unit);
create index if not exists idx_expense_pdfs_period on public.expense_pdfs(period);
create index if not exists idx_unit_expensas_unit on public.unit_expensas(unit);

-- ROW LEVEL SECURITY (RLS) y políticas mínimas
alter table public.profiles enable row level security;

-- Allow user to insert their own profile after signUp
create policy "profiles_insert_self" on public.profiles
  for insert with check (id = auth.uid());

create policy "profiles_self_or_admin_select" on public.profiles
  for select using (
    id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'Administrador')
  );

create policy "profiles_self_update" on public.profiles
  for update using (id = auth.uid()) with check (id = auth.uid());

create policy "profiles_admin_full_access" on public.profiles
  for all using (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'Administrador')
  );

-- Comunicados
alter table public.comunicados enable row level security;
create policy "comunicados_select_auth" on public.comunicados for select using (auth.role() = 'authenticated');
create policy "comunicados_admin_crud" on public.comunicados for all using (EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'Administrador'));

-- Unit expensas
alter table public.unit_expensas enable row level security;
create policy "unit_expensas_select_owner_or_admin" on public.unit_expensas
  for select using (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND (p.role = 'Administrador' OR p.unit = unit))
  );
create policy "unit_expensas_admin_crud" on public.unit_expensas
  for all using (EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'Administrador'));

-- Expensas generales
alter table public.expensas enable row level security;
create policy "expensas_select_auth" on public.expensas for select using (auth.role() = 'authenticated');
create policy "expensas_admin_crud" on public.expensas for all using (EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'Administrador'));

-- Reclamos
alter table public.reclamos enable row level security;
create policy "reclamos_select_auth" on public.reclamos for select using (auth.role() = 'authenticated');
create policy "reclamos_insert_authenticated" on public.reclamos for insert with check (auth.role() = 'authenticated');
create policy "reclamos_update_creator_or_admin" on public.reclamos for update using (creator_id = auth.uid() OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'Administrador'));
create policy "reclamos_delete_creator_or_admin" on public.reclamos for delete using (creator_id = auth.uid() OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'Administrador'));

-- Galeria
alter table public.galeria enable row level security;
create policy "galeria_select_auth" on public.galeria for select using (auth.role() = 'authenticated');
create policy "galeria_insert_auth" on public.galeria for insert with check (auth.role() = 'authenticated');
create policy "galeria_update_owner_or_admin" on public.galeria for update using (uploaded_by = auth.uid() OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'Administrador'));
create policy "galeria_delete_owner_or_admin" on public.galeria for delete using (uploaded_by = auth.uid() OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'Administrador'));

-- Expense PDFs
alter table public.expense_pdfs enable row level security;
create policy "expense_pdfs_select_auth" on public.expense_pdfs for select using (auth.role() = 'authenticated');
create policy "expense_pdfs_admin_crud" on public.expense_pdfs for all using (EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'Administrador'));

-- Libre de deuda
alter table public.libre_deuda enable row level security;
create policy "libredeuda_select_auth" on public.libre_deuda for select using (auth.role() = 'authenticated');
create policy "libredeuda_admin_crud" on public.libre_deuda for all using (EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'Administrador'));

-- FIN schema.sql

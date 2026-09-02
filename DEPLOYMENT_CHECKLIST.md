# 📋 DEPLOYMENT CHECKLIST - ARTEZA V

## 🟢 FASE 1: SUPABASE SETUP
**Responsable:** Edgardo Bogado  
**Tiempo estimado:** 15 minutos

### Crear Proyecto
- [ ] Registro en [supabase.com](https://supabase.com)
- [ ] Crear proyecto "arteza-v"
- [ ] Región: São Paulo (South America)
- [ ] Guardar database password de forma segura
- [ ] Proyecto creado y accesible ✅

### Obtener Credenciales
- [ ] Settings → API → Copiar **Project URL**
- [ ] Settings → API → Copiar **anon key**
- [ ] ⚠️ NO copiar `service_role key` (solo para backend)
- [ ] Guardar en lugar seguro

### Crear Esquema
- [ ] SQL Editor → Pegar contenido de `schema.sql`
- [ ] Ejecutar script
- [ ] Verificar tablas creadas:
  - [ ] `public.profiles`
  - [ ] `public.comunicados`
  - [ ] `public.unit_expensas`
  - [ ] `public.expensas`
  - [ ] `public.reclamos`
  - [ ] `public.galeria`
  - [ ] `public.expense_pdfs`
  - [ ] `public.libre_deuda`

### Crear Usuario Admin
- [ ] Authentication → Users → Add user
- [ ] Email: `edgardogn@live.com.ar`
- [ ] Password: (guardar de forma segura)
- [ ] Copiar **User ID** (UUID)
- [ ] Usuario creado ✅

### Cargar Datos de Ejemplo
- [ ] Reemplazar `<ADMIN_UUID>` en `seed.sql` con UUID del admin
- [ ] SQL Editor → Pegar contenido de `seed.sql`
- [ ] Ejecutar script
- [ ] Verificar datos:
  - [ ] Admin perfil creado
  - [ ] Comunicado de ejemplo
  - [ ] Expensa de ejemplo
  - [ ] Reclamo de ejemplo

### Crear Storage
- [ ] Storage → New bucket
- [ ] Nombre: `arteza`
- [ ] Privado: SÍ ✅
- [ ] Bucket creado ✅

### Configurar Aplicación
- [ ] Abrir `supabase-config.js`
- [ ] Reemplazar URL con Project URL
- [ ] Reemplazar ANON_KEY con anon key
- [ ] NO comitear este archivo (añadido a `.gitignore`)
- [ ] Archivo configurado ✅

---

## 🟡 FASE 2: CLOUDFLARE PAGES SETUP
**Responsable:** Edgardo Bogado  
**Tiempo estimado:** 10 minutos

### Crear Cuenta Cloudflare
- [ ] Registro en [cloudflare.com](https://cloudflare.com)
- [ ] Email verificado
- [ ] Cuenta activa ✅

### Conectar GitHub
- [ ] Cloudflare Dashboard → Pages
- [ ] Create a project
- [ ] Connect to Git
- [ ] Autorizar GitHub
- [ ] Seleccionar repo: `edgardobogado-netizen/ARTEZA-V`
- [ ] Instalar & Autorizar ✅

### Configurar Build
- [ ] Production branch: `main`
- [ ] Build command: (vacío)
- [ ] Build output: `/`
- [ ] Root directory: `/`
- [ ] Save and Deploy

### Verificar Deployment
- [ ] Deployment completado (⏳ esperar 2-5 min)
- [ ] URL asignada: `https://arteza-v.pages.dev`
- [ ] URL accesible y con contenido ✅

### Configurar Dominio (Opcional)
- [ ] Si tienes dominio personalizado
- [ ] Pages → Settings → Custom domains
- [ ] Add domain
- [ ] Configurar registros DNS (si es necesario)
- [ ] Dominio apuntando correctamente

---

## 🟣 FASE 3: VERIFICACIÓN FUNCIONAL
**Responsable:** Edgardo Bogado  
**Tiempo estimado:** 10 minutos

### Acceso a la Aplicación
- [ ] Abrir: `https://arteza-v.pages.dev`
- [ ] Página carga sin errores
- [ ] Login screen visible
- [ ] No hay errores en console (F12)

### Autenticación
- [ ] Email: `edgardogn@live.com.ar`
- [ ] Password: (la guardada)
- [ ] Login exitoso
- [ ] Redirige a dashboard
- [ ] Perfil cargado correctamente

### Datos Visibles
- [ ] Comunicados cargados (ejemplo de asamblea)
- [ ] Expensas visibles
- [ ] Galería cargada
- [ ] Reclamos visible
- [ ] Libre de deuda accesible

### Funcionalidades Básicas
- [ ] Crear nuevo comunicado (si es admin)
- [ ] Subir PDF (si es admin)
- [ ] Ver perfil
- [ ] Logout funciona

---

## 🟢 FASE 4: SEGURIDAD & PRODUCCIÓN
**Responsable:** Edgardo Bogado  
**Tiempo estimado:** 5 minutos

### Configuración de Seguridad
- [ ] `.gitignore` incluye `supabase-config.js`
- [ ] RLS habilitado en todas las tablas
- [ ] Bucket `arteza` es privado
- [ ] NO hay credenciales en commits
- [ ] Service role key NO en frontend

### Variables de Entorno (Cloudflare)
- [ ] Cloudflare Pages → Settings → Environment variables
- [ ] Agregar `SUPABASE_URL`
- [ ] Agregar `SUPABASE_ANON_KEY`
- [ ] Variables configuradas ✅

### Monitoreo
- [ ] Activar analytics en Supabase
- [ ] Activar analytics en Cloudflare
- [ ] Email alerts configuradas

### Backups
- [ ] Supabase: habilitar backups automáticos
- [ ] Guardar credentials en lugar seguro (password manager)
- [ ] Documentación guardada

---

## 📊 RESUMEN DEPLOYMENT

| Fase | Status | Fecha | Notas |
|------|--------|-------|-------|
| Supabase | ✅ | | Database + Auth + Storage |
| Cloudflare | ✅ | | Hosting + CI/CD automático |
| Verificación | ✅ | | Todas funcionalidades OK |
| Seguridad | ✅ | | RLS + .gitignore correcto |

---

## 🚀 GO LIVE

Cuando todos los items estén ✅:

1. **Notificar a usuarios:**
   ```
   Tu plataforma está en: https://arteza-v.pages.dev
   ```

2. **Crear primeros propietarios:**
   - Admin invita usuarios
   - O usuarios se registran (si habilitado)

3. **Migrar datos reales:**
   - Importar residentes existentes
   - Cargar comunicados anteriores
   - Subir documentos de expensas

---

## 📞 Contacto & Soporte

**Problemas técnicos:**
- Supabase Docs: https://supabase.com/docs
- Cloudflare Support: support.cloudflare.com
- GitHub Issues: reportar en el repo

**Creador:** Edgardo Bogado  
**Email:** edgardogn@live.com.ar  
**Repo:** edgardobogado-netizen/ARTEZA-V

---

**¡SISTEMA LISTO PARA PRODUCCIÓN! 🎉**

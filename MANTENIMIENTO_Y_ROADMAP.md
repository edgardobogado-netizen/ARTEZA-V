# 🔧 GUÍA DE MANTENIMIENTO Y PRÓXIMOS PASOS

## 📌 Después del Deploy Inicial

Una vez que tu sistema esté en producción, sigue estos pasos para mantenerlo seguro y eficiente.

---

## 🛠️ MANTENIMIENTO MENSUAL

### Base de Datos (Supabase)
```
1️⃣ Revisar Backups
   - Supabase → Database → Backups
   - Verificar que los backups automáticos están activos
   - Hacer backup manual antes de cambios importantes

2️⃣ Monitorear Límites de Uso
   - Supabase → Billing
   - Revisar storage usage
   - Revisar queries/API calls
   - Aumentar plan si es necesario

3️⃣ Limpiar Datos Antiguos
   - Archivos no usados en Storage
   - Comunicados archivados
   - Logs de auditoría (después de 90 días)

4️⃣ Optimizar Índices
   - Supabase → Database → Indexes
   - Verificar que los índices están siendo usados
```

### Hosting (Cloudflare Pages)
```
1️⃣ Revisar Deploys
   - Cloudflare → Pages → Deployments
   - Verificar que los deploys automáticos funcionan
   - Revisar logs si hay errores

2️⃣ Monitorear Rendimiento
   - Cloudflare → Analytics
   - Revisar Request count
   - Revisar Error rate
   - Optimizar si hay lentitud

3️⃣ Actualizar DNS (si usas dominio)
   - Verificar que los registros DNS están correctos
   - Revisar certificado SSL (auto-renovación)
```

---

## 🚀 PRÓXIMOS PASOS - FUNCIONALIDADES AVANZADAS

### SEMANA 1-2: Conectar Formularios a Base de Datos

**Archivo a editar:** `index.html` (buscar comentarios con "TODO")

#### 1. Sistema de Registro de Propietarios
```javascript
// Actualmente: Los datos se guardan en estado de React (temporal)
// Próximo: Guardar en tabla `profiles` de Supabase

const handleRegisterNewOwner = async (formData) => {
  // 1. Crear usuario en Auth
  const { data: authUser, error: authError } = await supabase.auth.signUp({
    email: formData.email,
    password: formData.password
  });
  
  // 2. Crear perfil en `profiles` table
  const { error: profileError } = await supabase.from('profiles').insert([{
    id: authUser.user.id,
    name: formData.fullName,
    unit: formData.unit,
    phone: formData.phone,
    role: 'Propietario',
    status: 'Pendiente'  // Admin debe aprobar
  }]);
  
  // 3. Notificar admin
  await sendEmailNotification(adminEmail, 'Nuevo propietario pendiente de aprobación');
};
```

#### 2. Sistema de Notificaciones
```javascript
// Cuando admin publica comunicado
const handlePublishComunicado = async (data) => {
  // 1. Guardar en tabla
  await supabase.from('comunicados').insert([data]);
  
  // 2. Enviar email a propietarios
  const { data: profiles } = await supabase
    .from('profiles')
    .select('email')
    .eq('status', 'Aprobado');
  
  for (let profile of profiles) {
    await sendEmail({
      to: profile.email,
      subject: `Nuevo comunicado: ${data.title}`,
      body: data.content
    });
  }
};
```

### SEMANA 2-3: Conectar Gestión de Expensas

#### 1. Crear Liquidación Mensual
```javascript
const handleCreateExpensas = async (mes, gastos) => {
  // 1. Calcular total de gastos
  const totalExpensas = gastos.reduce((sum, g) => sum + g.amount, 0);
  
  // 2. Distribuir entre unidades
  const { data: units } = await supabase
    .from('profiles')
    .select('unit')
    .eq('role', 'Propietario')
    .distinct();
  
  const amountPerUnit = totalExpensas / units.length;
  
  // 3. Crear cobros por unidad
  for (let unit of units) {
    await supabase.from('unit_expensas').insert([{
      unit: unit.unit,
      period: mes,
      ordinary_amount: amountPerUnit,
      total_amount: amountPerUnit,
      due_date: new Date(Date.now() + 10*24*60*60*1000), // 10 días
      status: 'Pendiente'
    }]);
  }
};
```

#### 2. Generar PDFs de Liquidación Automáticamente
```javascript
const handleGenerateExpensaPdf = async (period) => {
  // 1. Obtener datos del período
  const { data: expenses } = await supabase
    .from('expensas')
    .select('*')
    .eq('period', period);
  
  // 2. Generar HTML
  const html = `
    <h1>Liquidación de Expensas - ${period}</h1>
    ${expenses.map(e => `
      <tr>
        <td>${e.concept}</td>
        <td>$${e.amount}</td>
      </tr>
    `).join('')}
  `;
  
  // 3. Convertir a PDF y guardar en Storage
  const pdf = html2pdf().set(options).from(html).outputPdf();
  await supabase.storage
    .from('arteza')
    .upload(`liquidaciones/${period}/liquidacion.pdf`, pdf);
};
```

### SEMANA 3-4: Sistema de Pagos

#### 1. Integrar Pasarela de Pagos (Stripe/MercadoPago)
```javascript
// Opción 1: Stripe
const handlePaymentWithStripe = async (expensaId, amount) => {
  const stripe = Stripe('pk_live_...');
  
  const { sessionId } = await fetch('/create-checkout-session', {
    method: 'POST',
    body: JSON.stringify({ expensaId, amount })
  }).then(r => r.json());
  
  stripe.redirectToCheckout({ sessionId });
};

// Opción 2: MercadoPago
const handlePaymentWithMP = async (expensaId, amount) => {
  const preference = await fetch('/create-mp-preference', {
    method: 'POST',
    body: JSON.stringify({ expensaId, amount })
  }).then(r => r.json());
  
  window.location.href = preference.init_point;
};
```

#### 2. Registrar Pagos
```javascript
const handlePaymentConfirmed = async (expensaId, paymentProof) => {
  // Actualizar estado
  await supabase.from('unit_expensas')
    .update({
      status: 'Pagada',
      payment_date: new Date()
    })
    .eq('id', expensaId);
  
  // Guardar comprobante
  await supabase.storage
    .from('arteza')
    .upload(`comprobantes/${expensaId}/${Date.now()}.pdf`, paymentProof);
};
```

---

## 🔐 SEGURIDAD - CHECKLIST

### Antes de Ir a Producción Real

- [ ] **Autenticación 2FA**
  ```javascript
  // Supabase → Authentication → Two-Factor Authentication
  // Habilitar para admin
  ```

- [ ] **Rate Limiting**
  ```javascript
  // En Cloudflare Workers, limitar requests por IP
  const rateLimit = (ip) => {
    // máx 100 requests por minuto
  };
  ```

- [ ] **Validación de Datos**
  ```javascript
  // Validar TODOS los inputs antes de guardar
  const validateEmail = (email) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  const validateAmount = (amount) => !isNaN(amount) && amount > 0;
  ```

- [ ] **Encriptación de Datos Sensibles**
  ```javascript
  // Supabase PgCrypto para datos sensibles
  const encryptSensitive = async (data) => {
    // Usar pgp_sym_encrypt() en la base de datos
  };
  ```

- [ ] **Auditoría de Cambios**
  ```sql
  -- Crear tabla de logs
  CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    user_id UUID,
    action TEXT,
    table_name TEXT,
    old_values JSONB,
    new_values JSONB,
    timestamp TIMESTAMPTZ DEFAULT NOW()
  );
  ```

---

## 📊 MONITOREO Y ALERTAS

### Configurar Notificaciones

#### 1. Email Alerts (Supabase)
```
Settings → Email Templates
- New user signup
- Database threshold exceeded
- Backup completed
```

#### 2. Slack Integration
```javascript
// Cuando hay error crítico
const notifySlack = async (message) => {
  await fetch('https://hooks.slack.com/services/YOUR/WEBHOOK', {
    method: 'POST',
    body: JSON.stringify({
      text: `⚠️ ALERTA ARTEZA V: ${message}`,
      username: 'ARTEZA Bot'
    })
  });
};
```

#### 3. Uptime Monitoring
```
- Usar UptimeRobot.com
- Verificar sitio cada 5 minutos
- Notificar si cae
```

---

## 🆘 TROUBLESHOOTING COMÚN

### "No puedo hacer login"
**Solución:**
1. Verificar que el usuario existe en Supabase → Authentication
2. Verificar que tiene un perfil en tabla `profiles`
3. Revisar RLS policies en la tabla
4. Comprobar que el token no expiró

### "Las imágenes no cargan"
**Solución:**
1. Verificar que el bucket `arteza` existe
2. Comprobar que los storage paths en base de datos son correctos
3. Regenerar signed URLs (expiran en 60 segundos)

### "Muy lento"
**Solución:**
1. Revisar índices en Supabase
2. Optimizar queries (usar select específico, no *)
3. Habilitar caché en Cloudflare
4. Aumentar computación en Supabase si es necesario

### "Error 429 - Too Many Requests"
**Solución:**
1. Revisar Cloudflare Rate Limiting
2. Implementar debounce en formularios
3. Aumentar límite si es tráfico legítimo

---

## 📞 RECURSOS Y DOCUMENTACIÓN

### Oficial
- [Supabase Docs](https://supabase.com/docs)
- [Cloudflare Pages](https://pages.cloudflare.com/)
- [React Documentation](https://react.dev)

### Tutoriales Útiles
- Supabase + React: https://supabase.com/docs/guides/getting-started/quickstarts/react
- Authentication: https://supabase.com/docs/guides/auth
- Row Level Security: https://supabase.com/docs/guides/auth/row-level-security

### Comunidades
- Supabase Discord: https://discord.supabase.com
- Cloudflare Community: https://community.cloudflare.com
- React Community: https://react.dev/community

---

## 📋 CHECKLIST DE FEATURES COMPLETADOS

- [x] Autenticación básica
- [x] Gestión de perfiles
- [x] Sistema de comunicados
- [ ] Pagos en línea
- [ ] Notificaciones por email
- [ ] Reportes automáticos
- [ ] App móvil (futuro)
- [ ] Integración con contador

---

## 🎯 ROADMAP 2026-2027

**Trimestre 1 2026:**
- Completar sistema de pagos
- Añadir notificaciones por email
- Dashboard de reportes

**Trimestre 2 2026:**
- App móvil (React Native)
- Integración con bancos
- Firma digital

**Trimestre 3 2026:**
- Machine Learning para predicción de pagos
- Chatbot de soporte
- Integración con seguros

**Trimestre 4 2026:**
- Escalabilidad (múltiples consorcios)
- API pública para terceros
- Certificación de seguridad

---

**¡Tu plataforma está lista para crecer! 🚀**

¿Necesitas ayuda con algún feature específico? Contacta al equipo de desarrollo.

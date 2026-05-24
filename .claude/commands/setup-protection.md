# /setup-protection — Configurar protección de rama main

Activa las reglas de protección de la rama `main` para que el auto-merge solo se active cuando CI pase. **Ejecuta este comando una sola vez, después de que el primer PR haya corrido CI.**

---

## Por qué es necesario

Sin branch protection, `gh pr merge --auto` fusiona inmediatamente. Con protection, espera a que los checks de `ci.yml` (analyze + test) pasen.

## Pasos

### 1. Verificar que los checks existen (necesitan haber corrido al menos una vez)

```bash
gh api repos/Jorgeasen/Leopolis/commits/main/check-runs \
  --jq '.check_runs[] | {name: .name, status: .status}'
```

Si la lista está vacía, necesitas que primero se ejecute CI en un PR. Crea un PR de prueba o espera al primer `/next-issue`.

### 2. Activar branch protection

```bash
gh api repos/Jorgeasen/Leopolis/branches/main/protection \
  --method PUT \
  --input - << 'JSON'
{
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "🔍 Analizar código",
      "🧪 Tests"
    ]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": null,
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
JSON
```

### 3. Verificar la configuración

```bash
gh api repos/Jorgeasen/Leopolis/branches/main/protection \
  --jq '{required_checks: .required_status_checks.contexts, enforce_admins: .enforce_admins}'
```

## Si los nombres de checks no coinciden

Obtén los nombres exactos de los checks del último run de CI:

```bash
gh api repos/Jorgeasen/Leopolis/actions/runs \
  --jq '.workflow_runs[:3] | .[] | {id: .id, name: .name, status: .status}'
```

Luego obtén los jobs de ese run:

```bash
gh api repos/Jorgeasen/Leopolis/actions/runs/RUN_ID/jobs \
  --jq '.jobs[] | .name'
```

Usa esos nombres en el campo `contexts` del paso 2.

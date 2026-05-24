# /issue-status — Estado del pipeline agentic

Muestra el estado actual de todos los issues del roadmap: cuáles están listos, bloqueados, en progreso o completados.

---

## Ejecuta estos comandos y analiza el resultado:

```bash
# 1. Issues abiertos con sus labels y milestones
gh issue list \
  --repo Jorgeasen/Leopolis \
  --state open \
  --json number,title,milestone,labels,assignees \
  --limit 50

# 2. Issues cerrados recientemente
gh issue list \
  --repo Jorgeasen/Leopolis \
  --state closed \
  --json number,title,closedAt \
  --limit 20

# 3. PRs activos
gh pr list \
  --repo Jorgeasen/Leopolis \
  --state open \
  --json number,title,headRefName,statusCheckRollup,autoMergeRequest

# 4. PRs mergeados recientemente
gh pr list \
  --repo Jorgeasen/Leopolis \
  --state merged \
  --json number,title,mergedAt \
  --limit 10
```

---

## Formato de respuesta esperado

Presenta la información en este formato:

```
═══════════════════════════════════════════
   LEÓPOLIS — Estado del pipeline agentic
   [fecha actual]
═══════════════════════════════════════════

✅ COMPLETADOS (cerrados)
  #N — Título

🔄 EN PROGRESO (PRs abiertos)
  #N — Título → PR #M (CI: pasando/fallando/pendiente)

🟢 LISTOS PARA IMPLEMENTAR (agent-ready, sin dependencias bloqueantes)
  #N — Título [milestone]

🔴 BLOQUEADOS (agent-ready, pero dependen de issues abiertos)
  #N — Título → bloqueado por #M (Título del bloqueante)

📋 PRÓXIMOS MILESTONES
  v1.0 Las Letras: X/4 issues completados
  v1.1 Las Palabras: X/3 issues completados
  v1.2 Juegos: X/3 issues completados
  v1.3 Premios: X/3 issues completados

💡 SIGUIENTE ACCIÓN RECOMENDADA
  Ejecuta /next-issue para implementar: #N — Título
```

Para determinar si un issue está bloqueado, lee su body y busca la sección `## Dependencias`.

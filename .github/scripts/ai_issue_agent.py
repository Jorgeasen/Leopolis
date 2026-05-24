import os
import json
import urllib.request
from openai import OpenAI

title = os.environ.get("ISSUE_TITLE", "")
body = os.environ.get("ISSUE_BODY", "")

client = OpenAI(
    base_url="https://models.inference.ai.azure.com",
    api_key=os.environ["GH_TOKEN"],
)

prompt = f"""Eres un agente de soporte técnico especializado en la app Leópolis, una aplicación Flutter para que niños de 6 años aprendan a leer y escribir.

Se ha abierto el siguiente issue en GitHub:

**Título:** {title}
**Descripción:** {body}

Por favor:
1. **Clasifica** el issue: Bug / Mejora de UX / Feature request / Otro
2. **Prioridad sugerida**: Alta / Media / Baja (considerando que afecta a niños)
3. **Causa probable**: ¿Qué puede estar causando el problema?
4. **Pasos para reproducir** (si aplica)
5. **Solución sugerida**: Código Dart/Flutter si es posible
6. **Labels recomendados** para el issue

Sé concreto y útil. Si el problema afecta la experiencia del niño, dale máxima prioridad."""

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": prompt}],
    max_tokens=1024,
)

analysis = response.choices[0].message.content
comment = (
    "## 🤖 Análisis automático del Agente Leópolis (GitHub Models)\n\n"
    f"{analysis}\n\n"
    "---\n"
    "*Análisis generado automáticamente · Sin coste adicional vía GitHub Models*\n"
    "*Recuerda revisar y validar las sugerencias antes de aplicarlas*"
)

token = os.environ["GH_TOKEN"]
issue = os.environ["ISSUE_NUMBER"]
repo = os.environ["REPO"]

comment_payload = json.dumps({"body": comment}).encode()
comment_req = urllib.request.Request(
    f"https://api.github.com/repos/{repo}/issues/{issue}/comments",
    data=comment_payload,
    headers={
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json",
        "Content-Type": "application/json"
    }
)
urllib.request.urlopen(comment_req)
print(f"Análisis publicado en issue #{issue}")

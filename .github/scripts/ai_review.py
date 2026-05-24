import os
import json
import urllib.request
from openai import OpenAI

diff = open('pr_diff.txt').read()
if not diff.strip():
    print("Sin cambios Dart, saltando revisión.")
    exit(0)

client = OpenAI(
    base_url="https://models.inference.ai.azure.com",
    api_key=os.environ["GH_TOKEN"],
)

prompt = f"""Eres un experto en Flutter y Dart revisando código de una app educativa para niños de 6 años llamada Leópolis.

Analiza el siguiente diff de un Pull Request y proporciona:

1. **Resumen** (2-3 líneas) de qué hace el cambio
2. **Puntos positivos** del código
3. **Posibles problemas** (bugs, performance, UX para niños, accesibilidad)
4. **Sugerencias de mejora** concretas con ejemplos de código si aplica
5. **Veredicto**: ✅ Aprobado / ⚠️ Aprobado con cambios menores / ❌ Requiere cambios

Sé constructivo. Ten en cuenta que es una app para un niño de 6 años: UX y rendimiento son clave.

DIFF:
```
{diff[:8000]}
```"""

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": prompt}],
    max_tokens=1024,
)

review = response.choices[0].message.content
comment = f"## 🤖 Revisión automática (GitHub Models / GPT-4o)\n\n{review}\n\n---\n*Análisis generado automáticamente · Sin coste adicional vía GitHub Models*"

token = os.environ["GH_TOKEN"]
pr = os.environ["PR_NUMBER"]
repo = os.environ["REPO"]

comment_payload = json.dumps({"body": comment}).encode()
comment_req = urllib.request.Request(
    f"https://api.github.com/repos/{repo}/issues/{pr}/comments",
    data=comment_payload,
    headers={
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json",
        "Content-Type": "application/json"
    }
)
urllib.request.urlopen(comment_req)
print("Revisión publicada en el PR.")

# Laboratorio 2 — Respuestas de análisis

Repositorio: https://github.com/Fabio0406/ci-cd-labs
Rama de funcionalidad: `feature/12345_update_readme`

---

## Parte 1

**¿Qué evento provoca actualmente la ejecución del pipeline?**
Originalmente, un `push` a la rama `main`. Tras este laboratorio, el pipeline se ejecuta con `push` a `main` o a `feature/**`, y con `pull_request` dirigido a `main`.

---

## Parte 6. Análisis del flujo

**1. ¿Por qué es conveniente trabajar en una rama independiente?**
Porque aísla el cambio: `main` se mantiene estable y desplegable mientras el trabajo está incompleto o roto, y varias personas pueden avanzar en paralelo sin pisarse.

**2. ¿Qué ventaja proporciona realizar el Pull/Merge Request antes del merge?**
Introduce un punto de control antes de tocar `main`: revisión humana, discusión del cambio, historial de por qué se integró y ejecución obligatoria del CI sobre el resultado propuesto.

**3. ¿En qué momento se ejecutó el pipeline?**
Al hacer `push` de la rama `feature/12345_update_readme` y nuevamente al abrir/actualizar el Pull Request hacia `main`.

**4. ¿Qué ocurriría si el pipeline fallara?**
El PR queda marcado con el check en rojo y, con la protección de `main` activada, el botón de merge se bloquea hasta que se corrija el error y el pipeline vuelva a pasar.

**5. ¿Qué diferencia existe entre revisar código manualmente y validarlo mediante CI?**
La revisión manual juzga diseño, legibilidad e intención, pero es subjetiva y se cansa; el CI ejecuta siempre las mismas verificaciones objetivas y repetibles. Son complementarias: el CI verifica que funciona, la revisión que está bien hecho.

---

## Parte 7. Protección de la rama principal

Reglas configuradas en GitHub (Settings → Branches → Add branch ruleset / Add rule, patrón `main`):

- Restrict deletions y bloqueo de escritura directa sobre `main`.
- Require a pull request before merging (mínimo 1 aprobación).
- Require status checks to pass before merging → check obligatorio: **Hello CI**.
- Require branches to be up to date before merging.
- Block force pushes.

Efecto: ningún commit llega a `main` sin PR y sin que el pipeline termine en verde.

---

## Parte 8. Experimentación (fallo deliberado)

**Cambio que provoca el fallo:** se añadió a `README.md` una línea con el marcador `TODO`, que el paso obligatorio *Validar documentación* (`scripts/validate-docs.sh`) rechaza con `exit 1`.

**Observado:**
- Resultado del pipeline: `failure` en el job **Hello CI**, paso *Validar documentación*.
- Mensaje de error: `ERROR: README.md contiene marcadores TODO sin resolver.`
- Estado del Pull Request: check en rojo, "Some checks were not successful"; con la protección activa el merge queda deshabilitado.

**Corrección:** se eliminó el marcador `TODO` del `README.md`, se hizo commit y push; el pipeline volvió a ejecutarse y terminó en `success`, habilitando nuevamente el merge.

**Conclusión:** la estrategia de branching define cómo fluye el código; el CI decide automáticamente si ese flujo puede continuar.

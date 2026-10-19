# Reglas del proyecto miconsumo

## Git: los commits los hace el usuario

- NUNCA ejecutar `git add`, `git commit`, `git push`, ni cualquier `git reset` que reescriba historia.
- Los agentes de IA dejan los cambios en el árbol de trabajo y reportan qué archivos tocaron.
- El usuario revisa y commitea. Ningún cambio se considera "listo" hasta que él lo commitee.
- Solo lectura permitida: `git status`, `git diff`, `git log`, `git show`, `git branch`.
- NUNCA ejecutar `specify extension add git` (esa extensión automatiza ramas y commits).

## Flujo de trabajo

Las funcionalidades se desarrollan con los comandos de Spec Kit (`/speckit.specify`,
`/speckit.plan`, ...), respetando `.specify/memory/constitution.md`.

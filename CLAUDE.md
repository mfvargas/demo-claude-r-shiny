# Demo Shiny App

Aplicacion R Shiny de ejemplo que explora el dataset `mtcars`.

## Desarrollo

```bash
docker compose up --build -d
```

Abrir <http://localhost:3838> en el navegador.

## Despliegue a shinyapps.io

1. Copiar `.env.example` a `.env` y llenar las credenciales de <https://www.shinyapps.io/admin/#/tokens>
2. `make deploy`

## Despliegue a Hugging Face Spaces

Automatico via GitHub Actions al hacer push a main.
URL: <https://huggingface.co/spaces/mfvargas/demo-mtcars-explorer>

## Estructura

- `app.R` — Aplicacion Shiny (UI + Server)
- `Dockerfile` — Imagen Docker para desarrollo local
- `Dockerfile.hf` — Imagen Docker para Hugging Face Spaces (puerto 7860)
- `docker-compose.yml` — Orquestacion con volumen para desarrollo en vivo
- `deploy.R` — Script de despliegue a shinyapps.io
- `.env` — Credenciales de shinyapps.io (NO se commitea)
- `.env.example` — Plantilla para credenciales
- `Makefile` — Targets: `dev`, `rebuild`, `deploy`

## Paquetes R

- `shiny` — Framework web interactivo
- `ggplot2` — Graficos
- `DT` — Tablas interactivas
- `rsconnect` — Despliegue a shinyapps.io

## Flujo de trabajo

1. Editar `app.R` en VS Code con Claude Code
2. Recargar navegador en localhost:3838 para ver cambios
3. `git commit` y `git push`
4. GitHub Actions despliega automaticamente a shinyapps.io y Hugging Face Spaces

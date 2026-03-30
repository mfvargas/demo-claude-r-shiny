# Demo Shiny App

Aplicación R Shiny de ejemplo que explora el dataset `mtcars`.

## Ejecutar

```bash
docker compose up --build
```

Abrir http://localhost:3838 en el navegador.

## Estructura

- `app.R` — Aplicación Shiny (UI + Server)
- `Dockerfile` — Imagen basada en `rocker/shiny` con ggplot2 y DT
- `docker-compose.yml` — Orquestación con volumen para desarrollo en vivo

## Paquetes R

- `shiny` — Framework web interactivo
- `ggplot2` — Gráficos
- `DT` — Tablas interactivas

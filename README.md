# Explorador de mtcars

[![Deploy to shinyapps.io](https://github.com/mfvargas/demo-claude-r-shiny/actions/workflows/deploy.yml/badge.svg)](https://github.com/mfvargas/demo-claude-r-shiny/actions/workflows/deploy.yml)

Aplicacion R Shiny interactiva para explorar el dataset `mtcars`. Permite seleccionar variables para los ejes X/Y y el color de un grafico de dispersion, junto con una tabla interactiva de datos.

**App en produccion:** <https://mfvargas.shinyapps.io/demo-mtcars-explorer/>

## Setup rapido

```bash
# Clonar
git clone git@github.com:mfvargas/demo-claude-r-shiny.git
cd demo-claude-r-shiny

# Configurar credenciales de shinyapps.io
cp .env.example .env
# Editar .env con tus credenciales

# Levantar
docker compose up --build -d
```

Abrir <http://localhost:3838> en el navegador.

## Comandos

| Comando | Descripcion |
|---|---|
| `make dev` | Levantar contenedor |
| `make rebuild` | Reconstruir imagen y levantar |
| `make deploy` | Desplegar a shinyapps.io |

## Tecnologias

- **R** + Shiny, ggplot2, DT
- **Docker** para ambiente de desarrollo
- **GitHub Actions** para despliegue automatico
- **shinyapps.io** para produccion

## Documentacion

- [Flujo de trabajo detallado](flujo-de-trabajo.md)

## Licencia

[MIT](LICENSE)

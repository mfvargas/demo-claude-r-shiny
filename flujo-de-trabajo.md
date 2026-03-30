# Flujo de trabajo: desarrollo y despliegue de la aplicacion Shiny

Esta guia describe el flujo de trabajo completo para desarrollar y desplegar la aplicacion **Explorador de mtcars**, desde la configuracion del ambiente local hasta la publicacion en produccion.

## 1. Requisitos previos

| Herramienta | Proposito | Instalacion |
|---|---|---|
| **Docker** | Ejecutar R y Shiny Server en un contenedor | [docs.docker.com/get-docker](https://docs.docker.com/get-docker/) |
| **Git** | Control de versiones | `sudo apt install git` |
| **gh CLI** | Interaccion con GitHub desde terminal | [cli.github.com](https://cli.github.com/) |
| **VS Code** | Editor de codigo | [code.visualstudio.com](https://code.visualstudio.com/) |
| **Claude Code** | Asistente de desarrollo con IA | Extension de VS Code |
| **Cuenta shinyapps.io** | Hosting de la app en produccion | [shinyapps.io](https://www.shinyapps.io/) |

> **Nota:** R no se instala localmente. Todo se ejecuta dentro del contenedor Docker.

### Extensiones recomendadas de VS Code

- **R** (REditorSupport) — resaltado de sintaxis, autocompletado, terminal R interactiva
- **Docker** (Microsoft) — gestion visual de contenedores e imagenes

## 2. Configuracion inicial

### 2.1 Clonar el repositorio

```bash
git clone git@github.com:mfvargas/demo-claude-r-shiny.git
cd demo-claude-r-shiny
```

### 2.2 Configurar credenciales de shinyapps.io

1. Ir a <https://www.shinyapps.io/admin/#/tokens>
2. Copiar el **Name**, **Token** y **Secret**
3. Crear el archivo `.env` a partir de la plantilla:

```bash
cp .env.example .env
```

4. Editar `.env` y llenar los valores:

```
SHINYAPPS_NAME=tu_nombre_de_cuenta
SHINYAPPS_TOKEN=tu_token
SHINYAPPS_SECRET=tu_secret
```

> **Importante:** `.env` contiene credenciales y esta excluido de Git via `.gitignore`. Nunca debe commitearse.

### 2.3 Levantar el ambiente de desarrollo

```bash
docker compose up --build -d
```

Esto:
- Descarga la imagen `rocker/shiny` (si es la primera vez)
- Instala los paquetes R: `ggplot2`, `DT`, `rsconnect`
- Inicia Shiny Server en el puerto 3838

Abrir el navegador en: **<http://localhost:3838>**

## 3. Ambiente de desarrollo

### Arquitectura local

```
+-------------------+       +----------------------------+
|     VS Code       |       |   Contenedor Docker        |
|                   |       |                            |
|  app.R (edicion)  |--+--->|  /srv/shiny-server/app.R   |
|                   |  |    |                            |
|  Claude Code      |  |    |  Shiny Server :3838        |
|                   |  |    |                            |
|  Terminal         |  |    |  R 4.5 + ggplot2 + DT      |
+-------------------+  |    |        + rsconnect         |
                       |    +----------------------------+
                       |
                  volumen Docker
                  (montaje en vivo)
```

El archivo `app.R` se monta como **volumen** en el contenedor. Esto significa que cualquier cambio que hagas en VS Code se refleja inmediatamente dentro del contenedor, sin necesidad de reconstruir la imagen.

### Como funciona el hot-reload

Shiny Server detecta cambios en `app.R` automaticamente. Despues de editar:

1. Guarda el archivo en VS Code (`Ctrl+S`)
2. Recarga la pagina en el navegador (`F5`)
3. La app se reinicia con los cambios

### Uso de Claude Code

Claude Code actua como asistente de desarrollo dentro de VS Code. Puede:

- Editar `app.R` directamente (agregar graficos, cambiar UI, etc.)
- Ejecutar comandos Docker desde la terminal
- Hacer commit y push a GitHub
- Desplegar a shinyapps.io con `make deploy`

Ejemplo de interaccion:

> "Agrega un histograma debajo del grafico de dispersion"
>
> Claude Code edita `app.R`, vos recargais el navegador y ves el cambio.

## 4. Ciclo de desarrollo

```
  +----------+     +-----------+     +--------+
  |  Editar  |---->|  Recargar |---->| Probar |
  |  app.R   |     |  browser  |     |        |
  +----------+     +-----------+     +--------+
       ^                                  |
       |                                  |
       +------------- Iterar -------------+
```

### Pasos detallados

1. **Editar**: Modifica `app.R` en VS Code (manualmente o con Claude Code)
2. **Recargar**: Abre <http://localhost:3838> y recarga la pagina
3. **Probar**: Interactua con la app — cambia los selectores, revisa el grafico y la tabla
4. **Iterar**: Si algo no esta bien, vuelve al paso 1

### Si cambias el Dockerfile

Si necesitas agregar un nuevo paquete R (por ejemplo, `leaflet`):

1. Editar `Dockerfile` — agregar el paquete a la linea `install2.r`
2. Reconstruir la imagen:

```bash
make rebuild
```

3. Esperar a que se instalen los paquetes (puede tardar unos minutos)

## 5. Control de versiones

### Que se commitea y que NO

| Se commitea | NO se commitea |
|---|---|
| `app.R` | `.env` (credenciales) |
| `Dockerfile` | `.Renviron` |
| `docker-compose.yml` | `rsconnect/` (metadata local) |
| `deploy.R` | `.Rproj.user/` |
| `Makefile` | `.Rhistory`, `.RData` |
| `.env.example` | `.claude/` |
| `.gitignore` | `.vscode/` |
| `.dockerignore` | |
| `CLAUDE.md` | |

### Flujo Git

Despues de completar un cambio funcional:

```bash
# Ver que archivos cambiaron
git status

# Agregar archivos especificos
git add app.R

# Crear commit con mensaje descriptivo
git commit -m "Add histogram below scatter plot"

# Subir a GitHub
git push
```

> **Buena practica:** Hacer commits pequenos y frecuentes. Un commit por cada cambio logico (nueva funcionalidad, correccion de bug, etc.).

## 6. Despliegue a produccion

### Comando de despliegue

```bash
make deploy
```

### Que hace internamente

`make deploy` ejecuta:

```bash
docker compose exec shiny-app Rscript /home/shiny/deploy.R
```

Esto corre `deploy.R` dentro del contenedor, que:

1. Lee las credenciales de las variables de entorno (`SHINYAPPS_NAME`, `SHINYAPPS_TOKEN`, `SHINYAPPS_SECRET`)
2. Registra la cuenta con `rsconnect::setAccountInfo()`
3. Empaqueta `app.R` y lo sube a shinyapps.io
4. shinyapps.io instala las dependencias R automaticamente desde CRAN
5. La app se inicia en produccion

### Verificar el despliegue

Despues de que `make deploy` termine exitosamente, visitar:

**<https://mfvargas.shinyapps.io/demo-mtcars-explorer/>**

### Nota importante

shinyapps.io **no usa Docker**. Ejecuta R de forma nativa e instala los paquetes desde CRAN. El Dockerfile es exclusivamente para el ambiente de desarrollo local.

## 7. Flujo completo

```
 DESARROLLO                          PRODUCCION
 ==========                          ==========

 +---------+    +---------+
 | Editar  |--->| Probar  |
 | app.R   |    | :3838   |---+
 +---------+    +---------+   |
      VS Code     Docker      |
                              |
                    +---------+---------+
                    |                   |
               +----v----+       +-----v------+
               |   git   |       |   make     |
               |  commit |       |  deploy    |
               |  + push |       +-----+------+
               +----+----+             |
                    |                  |
               +----v----+       +----v---------+
               | GitHub  |       | shinyapps.io |
               | (repo)  |       | (produccion) |
               +---------+       +--------------+
```

### Resumen del ciclo

| Paso | Accion | Comando |
|---|---|---|
| 1 | Editar codigo | VS Code + Claude Code |
| 2 | Probar localmente | Recargar <http://localhost:3838> |
| 3 | Guardar en Git | `git add app.R && git commit -m "mensaje"` |
| 4 | Subir a GitHub | `git push` |
| 5 | Desplegar | `make deploy` |
| 6 | Verificar produccion | Visitar la URL de shinyapps.io |

## 8. Comandos de referencia rapida

| Comando | Descripcion |
|---|---|
| `make dev` | Levantar contenedor (sin reconstruir) |
| `make rebuild` | Reconstruir imagen y levantar contenedor |
| `make deploy` | Desplegar a shinyapps.io |
| `docker compose down` | Detener y eliminar contenedor |
| `docker compose logs -f` | Ver logs del contenedor en tiempo real |
| `docker compose exec shiny-app R` | Abrir consola R dentro del contenedor |
| `git status` | Ver estado de archivos modificados |
| `git add <archivo>` | Agregar archivo al staging |
| `git commit -m "mensaje"` | Crear commit |
| `git push` | Subir a GitHub |
| `git log --oneline` | Ver historial de commits |

## 9. Resolucion de problemas

### El contenedor no levanta

```bash
# Ver logs para identificar el error
docker compose logs

# Reconstruir desde cero
docker compose down
docker compose up --build -d
```

### La app no carga en el navegador

1. Verificar que el contenedor esta corriendo: `docker compose ps`
2. Verificar que el puerto 3838 no esta ocupado: `lsof -i :3838`
3. Revisar logs: `docker compose logs -f`

### Error de credenciales al desplegar

```
Error: Missing shinyapps.io credentials.
```

1. Verificar que `.env` tiene los valores correctos
2. Reiniciar el contenedor para que lea las nuevas variables:

```bash
docker compose down && docker compose up -d
```

3. Intentar de nuevo: `make deploy`

### El despliegue falla en shinyapps.io

1. Revisar el log de despliegue en <https://www.shinyapps.io/admin/#/dashboard>
2. Causas comunes:
   - Paquete R no disponible en CRAN
   - Error de sintaxis en `app.R`
   - Limite de apps en cuenta gratuita (5 apps)

### Los cambios en app.R no se reflejan

1. Verificar que guardaste el archivo (`Ctrl+S`)
2. Recargar la pagina del navegador (`F5` o `Ctrl+Shift+R` para cache limpio)
3. Si no funciona, reiniciar el contenedor: `docker compose restart`

library(rsconnect)

name   <- Sys.getenv("SHINYAPPS_NAME")
token  <- Sys.getenv("SHINYAPPS_TOKEN")
secret <- Sys.getenv("SHINYAPPS_SECRET")

if (nchar(token) == 0 || nchar(secret) == 0 || nchar(name) == 0) {
  stop(
    "Missing shinyapps.io credentials.\n",
    "Set SHINYAPPS_NAME, SHINYAPPS_TOKEN, and SHINYAPPS_SECRET in .env file.\n",
    "Get these from https://www.shinyapps.io/admin/#/tokens"
  )
}

rsconnect::setAccountInfo(name = name, token = token, secret = secret)

rsconnect::deployApp(
  appDir       = "/srv/shiny-server",
  appName      = "demo-mtcars-explorer",
  appTitle     = "Explorador de mtcars",
  forceUpdate  = TRUE,
  launch.browser = FALSE
)

cat("\nDeployment complete!\n")
cat("App URL: https://", name, ".shinyapps.io/demo-mtcars-explorer/\n", sep = "")

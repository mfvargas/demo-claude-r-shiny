FROM rocker/shiny:4.5.3

RUN install2.r --error --skipinstalled \
    ggplot2 \
    DT \
    rsconnect

RUN rm -rf /srv/shiny-server/*

COPY app.R /srv/shiny-server/app.R

EXPOSE 3838

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:3838/ || exit 1

CMD ["/usr/bin/shiny-server"]

FROM rocker/shiny:latest

RUN install2.r --error --skipinstalled \
    ggplot2 \
    DT \
    rsconnect

RUN rm -rf /srv/shiny-server/*

COPY app.R /srv/shiny-server/app.R

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
